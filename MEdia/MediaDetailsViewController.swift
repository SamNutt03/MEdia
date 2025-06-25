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
    
    enum DetailMode {
        case viewingShowcase(position: Int)
        case fromSearch(targetPosition: Int?)
    }
    
    var movie: Movie?
    var showcaseMovie: ShowcaseMovies?
    var mode: DetailMode = .fromSearch(targetPosition: nil)
    var blurColour : UIColor?
    
    func presentSearch(position: Int) {
        
    }
    
    func saveToShowcase(position: Int) {
        
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        switch mode {
            case .viewingShowcase(let position):
                // Show search view to replace this position
                presentSearch(position: position)

            case .fromSearch(let targetPosition):
                // Save this movie to Core Data at the given position
                saveToShowcase(position: targetPosition ?? 1)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = view.bounds
        blurView.backgroundColor = blurColour?.withAlphaComponent(0.75)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        mediaDetailsLbl.font = UIFont(name: "Silkscreen", size: 32)
        //mediaDetailsLbl.text =
    }

}
