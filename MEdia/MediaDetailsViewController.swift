//
//  MediaDetailsViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 24/06/2025.
//

import UIKit
import CoreData

class MediaDetailsViewController: UIViewController {

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
    
    var movie: Movie?
    var showcaseMovie: ShowcaseMovies?
    var mode: DetailMode = .fromSearch(targetPosition: 1)
    var blurColour : UIColor?
    
    enum DetailMode {
        case viewingShowcase(position: Int64)
        case fromSearch(targetPosition: Int64?)
    }
    
    @IBOutlet var actionBtnOut: UIButton!
    @IBAction func actionBtn(_ sender: UIButton) {
        /*let searchVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseSearchViewController") as! ShowcaseSearchViewController
        searchVC.delegate = self
        searchVC.targetPosition = Int64(indexPath.row + 1)
        searchVC.blurColour = blurColour
        present(searchVC, animated: true)*/
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
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = view.bounds
        blurView.backgroundColor = blurColour?.withAlphaComponent(0.9)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        mediaDetailsLbl.font = UIFont(name: "Silkscreen", size: 32)
        
        setupView()
    }

}
