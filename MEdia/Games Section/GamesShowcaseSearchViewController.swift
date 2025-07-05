//
//  GamesShowcaseSearchViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 17/06/2025.
//

import UIKit
import CoreData

class GamesShowcaseSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var completionHandler: (() -> Void)?
    var targetPosition: Int64 = 1
    var alreadyPlayed: Bool = true
    var bgColour: UIColor?
    let api_key = "d4a7930856694574b3ca9c4dc2ca87fe"
    var searchResults : [Game] = []
    var searchTask: DispatchWorkItem?
    @IBOutlet var searchBar: UISearchBar!
    
    func loadTrendingGames() {
        let urlString = "https://api.rawg.io/api/games?key=\(api_key)&ordering=-added"
        loadData(from: urlString)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()

        guard searchText.count >= 3 else {
            loadTrendingGames()
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
                let response = try JSONDecoder().decode(RAWGSearchResponse.self, from: data)
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
        let urlString = "https://api.rawg.io/api/games?key=\(api_key)&search=\(encodedQuery)"
        loadData(from: urlString)
    }
    
    func fetchFullDetails(for game: Game, completion: @escaping (Game) -> Void) {
        let urlString = "https://api.rawg.io/api/games/\(game.id)?key=\(api_key)"


        guard let url = URL(string: urlString) else {
            completion(game)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let details = try? JSONDecoder().decode(GameDetails.self, from: data) else {
                completion(game)
                return
            }
            
            var updatedGame = game
            updatedGame.details = details
            
            completion(updatedGame)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamesAPIResults", for: indexPath) as! GamesAPIResultsCell
        let game = searchResults[indexPath.row]
        
        cell.titleLabel.text = game.name
        cell.ratingLabel.text = "Rated:   \(game.rating ?? 0) / 5"
        cell.releasedLabel.text = "Released:   \(game.released ?? "Unknown")"
        
        if let url = game.fullImageURL {
            loadImage(from: url, into: cell.posterImage)
        } else {
            cell.posterImage.image = UIImage(named: "noImageAvailable")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = searchResults[indexPath.row]
            
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "GamesDetailsViewController") as! GamesDetailsViewController

        detailVC.bgColour = self.bgColour
        detailVC.game = selected
        detailVC.alreadyPlayed = self.alreadyPlayed
        detailVC.mode = .fromSearch(targetPosition: self.targetPosition)
        detailVC.completionHandler = self.completionHandler

        self.present(detailVC, animated: true)
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
        
        loadTrendingGames()
    }


}
