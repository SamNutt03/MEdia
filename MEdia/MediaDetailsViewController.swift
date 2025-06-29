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
    var dismissing = true

    @IBOutlet var createdByLbl: UILabel!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet var releaseLbl: UILabel!
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
    
    func dismissToShowcase() {
        var presenter = self.presentingViewController

        while let current = presenter {
            if current is ShowcaseViewController {
                current.dismiss(animated: false)
                return
            }
            presenter = current.presentingViewController
        }

        self.dismiss(animated: false)
    }
    
    var bgColour: UIColor?
    var movie: Movie?
    var showcaseMovie: ShowcaseMovies?
    var mode: DetailMode = .fromSearch(targetPosition: 1)
    
    enum DetailMode {
        case fromShowcase(position: Int64)
        case fromSearch(targetPosition: Int64)
        case fromMediaList
    }
    
    @IBOutlet var actionBtnOut: UIButton!
    @IBAction func actionBtn(_ sender: UIButton) {
        switch mode {
        case .fromSearch(let targetPosition):
            guard let movie = movie else { return }
            saveMovieToCoreData(movie: movie, position: targetPosition)
            if dismissing == true {
                dismissToShowcase()
                self.completionHandler?()
            }
            
            
        case .fromShowcase(let position):
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let searchVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseSearchViewController") as! ShowcaseSearchViewController
            searchVC.bgColour = bgColour
            searchVC.targetPosition = position
            searchVC.completionHandler = self.completionHandler
            present(searchVC, animated: true)
    
        case .fromMediaList:
            let alert = UIAlertController(title: "Remove from list", message: "Are you sure you want to remove this item from your media list?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext, let movieToRemove = self.showcaseMovie else { return }
                context.delete(movieToRemove)
                do {
                    try context.save()
                    self.dismiss(animated: false) {
                        self.completionHandler?()
                    }
                } catch {
                    print("Failed to delete from Core Data: \(error)")
                }
            }
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            alert.view.backgroundColor = bgColour
            alert.view.tintColor = bgColour
            alert.view.layer.borderColor = bgColour?.cgColor
            alert.view.layer.cornerRadius = 5
            alert.view.layer.borderWidth = 2
            present(alert, animated: true)
            
        }
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

    
    
    
    func setupView() {
        switch mode {
        case .fromSearch:
            actionBtnOut.setTitle("Add to Showcase", for: .normal)
        case .fromShowcase:
            actionBtnOut.setTitle("Replace in Showcase", for: .normal)
        case .fromMediaList:
            actionBtnOut.setTitle("Remove from Watchlist", for: .normal)
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
        mediaCreatorLbl.text = movie.director ?? "Unknown"
        mediaReleaseLbl.text = movie.releaseDate ?? "N/A"
        mediaRatingLbl.text = "\(String(format: "%.1f", movie.rating ?? 0))/10"
        if let url = movie.fullPosterURL {
            loadImage(from: url, into: self.mediaImage)
        }
    }
    
    func configureView(with movie: ShowcaseMovies) {
        mediaTitleLbl.text = movie.title
        mediaOverviewLbl.text = movie.overview
        mediaCreatorLbl.text = movie.director ?? "Unknown"
        mediaReleaseLbl.text = movie.releaseDate ?? "N/A"
        mediaRatingLbl.text = "\(String(format: "%.1f", movie.rating))/10"
        
        if let urlString = movie.imageURL, let url = URL(string: urlString) {
            loadImage(from: url, into: self.mediaImage)
        }
    }
    
    
    
    func saveMovieToCoreData(movie: Movie, position: Int64) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShowcaseMovies> = ShowcaseMovies.fetchRequest()
        
        if position != 0 {
            fetchRequest.predicate = NSPredicate(format: "showcasePosition == %d", position)
            if let existing = try? context.fetch(fetchRequest).first {
                context.delete(existing)
            }
        } else {
            fetchRequest.predicate = NSPredicate(format: "title == %@ AND showcasePosition == 0", movie.title)
            if let existing = try? context.fetch(fetchRequest), !existing.isEmpty {
                let alert = UIAlertController(title: "Item already added!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay.", style: .cancel, handler: { _ in
                    self.dismiss(animated: true)
                }))
                alert.view.backgroundColor = bgColour
                alert.view.tintColor = bgColour
                alert.view.layer.borderColor = bgColour?.cgColor
                alert.view.layer.cornerRadius = 5
                alert.view.layer.borderWidth = 2
                present(alert, animated: true)
                dismissing = false
                return
            }
        }
        
        dismissing = true
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
            print("Movie saved at position", position)
        } catch {
            print("Failed to save movie: \(error)")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = bgColour
        mediaImage.layer.cornerRadius = 5
        mediaImage.layer.masksToBounds = true
        mediaImage.layer.borderColor = UIColor.white.withAlphaComponent(0.75).cgColor
        mediaImage.layer.borderWidth = 1
        mediaDetailsLbl.font = UIFont(name: "Silkscreen", size: 16)
        mediaTitleLbl.font = UIFont(name: "Silkscreen", size: 24)
        mediaRatingLbl.font = UIFont(name: "Silkscreen", size: 16)
        mediaCreatorLbl.font = UIFont(name: "Silkscreen", size: 16)
        mediaReleaseLbl.font = UIFont(name: "Silkscreen", size: 16)
        mediaOverviewLbl.font = UIFont(name: "Silkscreen", size: 14)
        createdByLbl.font = UIFont(name: "Silkscreen", size: 12)
        ratingLbl.font = UIFont(name: "Silkscreen", size: 12)
        releaseLbl.font = UIFont(name: "Silkscreen", size: 12)
        
        setupView()
    }

}
