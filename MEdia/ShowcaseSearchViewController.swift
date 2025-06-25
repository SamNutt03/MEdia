//
//  ShowcaseViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 17/06/2025.
//

import UIKit
import CoreData

class ShowcaseSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var completionHandler: (() -> Void)?
    var targetPosition: Int64 = 1
    var bgColour: UIColor?
    
    let api_key = "62c81dfd789425652560fe982d478f9b"
    
    
    
    
    
    func loadTrendingMovies() {
        let urlString = "https://api.themoviedb.org/3/trending/movie/week?api_key=\(api_key)"
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
                print("Trending decode error:", error)
            }
        }.resume()
    }
    
    
    var searchResults : [Movie] = []
    var searchTask: DispatchWorkItem?
    @IBOutlet var searchBar: UISearchBar!
    
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

    func performBasicSearch(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.themoviedb.org/3/search/movie?query=\(encodedQuery)&api_key=\(api_key)"

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
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apiResult", for: indexPath) as! APIResultsCell
        let movie = searchResults[indexPath.row]
        
        cell.titleLabel?.text = movie.title
        cell.overviewLabel?.text = movie.overview
        
        if let url = movie.fullPosterURL {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        // Ensure the cell is still visible when the image arrives
                        if let visibleCell = tableView.cellForRow(at: indexPath) as? APIResultsCell {
                            visibleCell.posterImage.image = image
                        }
                    }
                }.resume()
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
                detailVC.mode = .fromSearch(targetPosition: self.targetPosition)
                detailVC.completionHandler = self.completionHandler

                self.present(detailVC, animated: true)
            }
        }
    }
    
    @IBOutlet var resultsTable: UITableView!
    
    
    
    
    
    
    func saveMovieToCoreData(movie: Movie) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShowcaseMovies> = ShowcaseMovies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "showcasePosition == %d", targetPosition)
        
        if let existing = try? context.fetch(fetchRequest).first {
            context.delete(existing)
        }
        
        let newEntry = ShowcaseMovies(context: context)
        newEntry.title = movie.title
        newEntry.overview = movie.overview
        newEntry.imageURL = movie.fullPosterURL?.absoluteString
        newEntry.director = movie.director
        newEntry.releaseDate = movie.releaseDate
        newEntry.rating = movie.rating ?? 0.0
        newEntry.showcasePosition = targetPosition
        
        do {
            try context.save()
            print("Movie saved successfully at showcase position", targetPosition)
        } catch {
            print("Failed to save movie: \(error)")
        }
    }
    

    @IBOutlet var backButtonOut: UIButton!
    @IBAction func backbutton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = bgColour
        loadTrendingMovies()
    }


}
