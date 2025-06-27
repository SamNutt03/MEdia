//
//  ShowcaseViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 20/06/2025.
//

import UIKit
import CoreData

class ShowcaseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var blurColour : UIColor?
    
    @IBOutlet var showcaseCollectionView: UICollectionView!
    var showcaseItems: [ShowcaseMovies?] = [nil, nil, nil]
    
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


    
    func updateShowcase() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShowcaseMovies> = ShowcaseMovies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "showcasePosition > 0")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "showcasePosition", ascending: true)]

        do {
            let fetched = try context.fetch(fetchRequest)
            showcaseItems = [nil, nil, nil] // Reset

            for item in fetched {
                let index = Int(item.showcasePosition) - 1
                if index >= 0 && index < showcaseItems.count {
                    showcaseItems[index] = item
                }
            }

            showcaseCollectionView.reloadData()

        } catch {
            print("Failed to fetch showcase items: \(error)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowcaseCell", for: indexPath) as! ShowcaseCell
        
        if let item = showcaseItems[indexPath.row] {
            if let urlString = item.imageURL, let url = URL(string: urlString) {
                loadImage(from: url, into: cell.showcaseItemImg)
            }
        } else {
            cell.showcaseItemImg.image = UIImage(named: "showcasePlaceholder")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (showcaseCollectionView.bounds.width - 40) / 3
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let position = Int64(indexPath.row + 1)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let selectedMovie = showcaseItems[indexPath.row] {
            let detailVC = storyboard.instantiateViewController(withIdentifier: "MediaDetailsViewController") as! MediaDetailsViewController
            
            detailVC.bgColour = blurColour
            detailVC.showcaseMovie = selectedMovie
            detailVC.mode = .viewingShowcase(position: position)
            detailVC.completionHandler = { [weak self] in
                self?.updateShowcase()
            }
            present(detailVC, animated: true)
        } else {
            let searchVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseSearchViewController") as! ShowcaseSearchViewController
            searchVC.targetPosition = position
            searchVC.bgColour = blurColour
            searchVC.completionHandler = { [weak self] in
                self?.updateShowcase()
            }
            present(searchVC, animated: true)
        }
    }
    
    @IBOutlet var mediaTypeLbl: UILabel!
    var mediaType : String?
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showcaseCollectionView.dataSource = self
        showcaseCollectionView.delegate = self
        
        if blurColour == nil {
            blurColour = .lightGray
        }
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = view.bounds
        blurView.backgroundColor = blurColour?.withAlphaComponent(0.9)
        blurView.alpha = 0.9
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        mediaTypeLbl.font = UIFont(name: "Silkscreen", size: 32)
        mediaTypeLbl.text = mediaType
        updateShowcase()
        
    }

}
