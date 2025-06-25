//
//  MediaDetailsViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 24/06/2025.
//

import UIKit
import CoreData

class MediaDetailsViewController: UIViewController {

    var completionHandler: (() -> Void)?

    @IBOutlet var mediaDetailsLbl: UILabel!
    @IBOutlet var mediaImage: UIImageView!
    @IBOutlet var mediaTitleLbl: UILabel!
    @IBOutlet var mediaCreatorLbl: UILabel!
    @IBOutlet var mediaRatingLbl: UILabel!
    @IBOutlet var mediaReleaseLbl: UILabel!
    @IBOutlet var mediaOverviewLbl: UILabel!
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func dismissToShowcase(completion: (() -> Void)? = nil) {
        var presenter = self.presentingViewController

        while let current = presenter {
            if current is ShowcaseViewController {
                current.dismiss(animated: true, completion: completion)
                return
            }
            presenter = current.presentingViewController
        }

        self.dismiss(animated: true, completion: completion)
    }
    
    var bgColour: UIColor?
    var movie: Movie?
    var showcaseMovie: ShowcaseMovies?
    var mode: DetailMode = .fromSearch(targetPosition: 1)
    
    enum DetailMode {
        case viewingShowcase(position: Int64)
        case fromSearch(targetPosition: Int64)
    }
    
    @IBOutlet var actionBtnOut: UIButton!
    @IBAction func actionBtn(_ sender: UIButton) {
        switch mode {
        case .fromSearch(let targetPosition):
            guard let movie = movie else { return }
            saveMovieToCoreData(movie: movie, position: targetPosition)
            dismissToShowcase {
                self.completionHandler?()
            }
            
        case .viewingShowcase(let position):
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let searchVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseSearchViewController") as! ShowcaseSearchViewController
            searchVC.bgColour = bgColour
            searchVC.targetPosition = position
            searchVC.completionHandler = self.completionHandler
            present(searchVC, animated: true)
            
        }
    }
    
    
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.mediaImage.image = image
                }
            }
        }.resume()
    }
    
    
    
    func setupView() {
        switch mode {
        case .fromSearch:
            actionBtnOut.setTitle("Add to Showcase", for: .normal)
        case .viewingShowcase:
            actionBtnOut.setTitle("Replace in Showcase", for: .normal)
        }
        
        if let movie = movie {
            configureView(with: movie)
        } else if let showcaseMovie = showcaseMovie {
            configureView(with: showcaseMovie)
        }
    }
    
    func configureView(with movie: Movie) {
        mediaTitleLbl.text = movie.title
        mediaOverviewLbl.text = movie.overview
        mediaCreatorLbl.text = "Directed by: \(movie.director ?? "Unknown")"
        mediaReleaseLbl.text = "Release Date: \(movie.releaseDate ?? "N/A")"
        mediaRatingLbl.text = "Rating: \(String(format: "%.1f", movie.rating ?? 0))/10"
        if let url = movie.fullPosterURL {
            loadImage(from: url)
        }
    }
    
    func configureView(with movie: ShowcaseMovies) {
        mediaTitleLbl.text = movie.title
        mediaOverviewLbl.text = movie.overview
        mediaCreatorLbl.text = "Directed by: \(movie.director ?? "Unknown")"
        mediaReleaseLbl.text = "Release Date: \(movie.releaseDate ?? "N/A")"
        mediaRatingLbl.text = "Rating: \(String(format: "%.1f", movie.rating))/10"
        
        if let urlString = movie.imageURL, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.mediaImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
    
    
    func saveMovieToCoreData(movie: Movie, position: Int64) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShowcaseMovies> = ShowcaseMovies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "showcasePosition == %d", position)
        
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
        newEntry.showcasePosition = position
        
        do {
            try context.save()
            print("Movie saved successfully at showcase position", position)
        } catch {
            print("Failed to save movie: \(error)")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = bgColour
        mediaDetailsLbl.font = UIFont(name: "Silkscreen", size: 32)
        
        setupView()
    }

}
