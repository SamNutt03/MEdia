//
//  ShowcaseViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 17/06/2025.
//

import UIKit
import CoreData

protocol ShowcaseSearchViewControllerDelegate: AnyObject {
    func exitSearchView()
}

class ShowcaseSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: ShowcaseSearchViewControllerDelegate?
    
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchTask?.cancel()

            guard searchText.count >= 3 else {
                loadTrendingMovies()
                return
            }

            let task = DispatchWorkItem { [weak self] in
                self?.performSearch(query: searchText)
            }

            searchTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
        }

        func performSearch(query: String) {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apiResult", for: indexPath) as! APIResultsCell
        let movie = searchResults[indexPath.row]
        
        cell.titleLabel?.text = movie.title
        cell.overviewLabel?.text = movie.overview
        
        if let url = movie.fullPosterURL {
                URLSession.shared.dataTask(with: url) { data, response, error in
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
        saveMovieToCoreData(movie: selected)
        delegate?.exitSearchView()
        dismiss(animated: true)
    }
    
    @IBOutlet var resultsTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    func saveMovieToCoreData(movie: Movie) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShowcaseMovies> = ShowcaseMovies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "showcasePosition == 1")
        
        if let existing = try? context.fetch(fetchRequest).first {
            context.delete(existing)
        }
        
        // Create new entry
        let newEntry = ShowcaseMovies(context: context)
        newEntry.title = movie.title
        newEntry.overview = movie.overview
        newEntry.imageURL = movie.fullPosterURL?.absoluteString
        newEntry.showcasePosition = 1
        
        do {
            try context.save()
            print("Movie saved successfully at position 1")
        } catch {
            print("Failed to save movie: \(error)")
        }
    }
    
    @IBAction func backbutton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadTrendingMovies()
    }


}
