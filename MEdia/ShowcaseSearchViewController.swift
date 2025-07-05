//
//  ShowcaseSearchViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 17/06/2025.
//

import UIKit
import CoreData

class ShowcaseSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var completionHandler: (() -> Void)?
    var targetPosition: Int64 = 1
    var alreadyWatched: Bool = true
    var bgColour: UIColor?
    let api_key = "62c81dfd789425652560fe982d478f9b"
    var searchResults : [Movie] = []
    var searchTask: DispatchWorkItem?
    @IBOutlet var searchBar: UISearchBar!
    
    func loadTrendingMovies() {
        let urlString = "https://api.themoviedb.org/3/trending/movie/week?api_key=\(api_key)"
        loadData(from: urlString)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()

        guard searchText.count >= 3 else {
            loadTrendingMovies()
            return
        }
        
        let task = DispatchWorkItem { [weak self] in
            self?.performBasicSearch(query: searchText)
        }

        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
    
    func loadData(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(TMDbSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.searchResults = response.results
                    self.resultsTable.reloadData()
                }
            } catch {
                print("JSON decode error:", error)
            }
        }.resume()
    }

    func performBasicSearch(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.themoviedb.org/3/search/movie?query=\(encodedQuery)&api_key=\(api_key)"
        loadData(from: urlString)
    }
    
    func fetchFullDetails(for movie: Movie, completion: @escaping (Movie) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movie.id)?api_key=\(api_key)&append_to_response=credits"


        guard let url = URL(string: urlString) else {
            completion(movie)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(movie)
                return
            }

            do {
                let fullMovieDetails = try JSONDecoder().decode(Movie.self, from: data)
                completion(fullMovieDetails)
            } catch {
                print("Error decoding credits:", error)
                completion(movie)
            }
        }.resume()
    }
    
    
    func loadImage(from url: URL, into imageView: UIImageView) {
        let cacheKey = url.absoluteString as NSString
        
        if let cachedImage = FetchedImageCache.shared.object(forKey: cacheKey) {
            imageView.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            FetchedImageCache.shared.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apiResult", for: indexPath) as! APIResultsCell
        let movie = searchResults[indexPath.row]
        
        cell.titleLabel?.text = movie.title
        cell.overviewLabel?.text = movie.overview
        
        if let url = movie.fullPosterURL {
            loadImage(from: url, into: cell.posterImage)
        } else {
            cell.posterImage.image = UIImage(named: "noImageAvailable")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = searchResults[indexPath.row]
            
        fetchFullDetails(for: selected) { updatedMovie in
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let detailVC = storyboard.instantiateViewController(withIdentifier: "MediaDetailsViewController") as! MediaDetailsViewController

                detailVC.bgColour = self.bgColour
                detailVC.movie = updatedMovie
                detailVC.alreadyWatched = self.alreadyWatched
                detailVC.mode = .fromSearch(targetPosition: self.targetPosition)
                detailVC.completionHandler = self.completionHandler

                self.present(detailVC, animated: true)
            }
        }
    }
    
    @IBOutlet var resultsTable: UITableView!
    

    @IBOutlet var backButtonOut: UIButton!
    @IBAction func backbutton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = bgColour
        resultsTable.showsVerticalScrollIndicator = false
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.leftView?.tintColor = .lightGray
            textField.backgroundColor = .white.withAlphaComponent(0.15)
            textField.textColor = .white
            textField.attributedPlaceholder = NSAttributedString(
                string: searchBar.placeholder ?? "Search Media...",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        }
        
        loadTrendingMovies()
    }


}
