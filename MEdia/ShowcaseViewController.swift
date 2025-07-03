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
    var listMode = true
    
    @IBOutlet var collectionSelector: UIStackView!
    @IBOutlet var watchlistBtn: UIButton!
    @IBOutlet var wishlistBtn: UIButton!
    
    @IBOutlet var mediaListCollectionView: UICollectionView!
    @IBOutlet var mediaListBgLbl: UILabel!
    @IBOutlet var showcaseCollectionView: UICollectionView!
    @IBOutlet var showcaseCollectionHeight: NSLayoutConstraint!
    var showcaseItems: [ShowcaseMovies?] = [nil, nil, nil]
    var mediaListItems: [ShowcaseMovies?] = []
    var wishListItems: [ShowcaseMovies?] = []
    
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

    func updateMediaList() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShowcaseMovies> = ShowcaseMovies.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "showcasePosition == 0 AND alreadyWatched == true")
        do {
            mediaListItems = try context.fetch(fetchRequest)
            if mediaListItems.isEmpty {
                mediaListBgLbl.isHidden = false
            } else {
                mediaListBgLbl.isHidden = true
            }
            mediaListCollectionView.reloadData()
        } catch {
            print("Failed to fetch media list items: \(error)")
        }
        
        fetchRequest.predicate = NSPredicate(format: "showcasePosition == 0 AND alreadyWatched == false")
        do {
            wishListItems = try context.fetch(fetchRequest)
            if wishListItems.isEmpty {
                mediaListBgLbl.isHidden = false
            } else {
                mediaListBgLbl.isHidden = true
            }
            mediaListCollectionView.reloadData()
        } catch {
            print("Failed to fetch media list items: \(error)")
        }
    }
    
    func updateShowcase() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShowcaseMovies> = ShowcaseMovies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "showcasePosition > 0")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "showcasePosition", ascending: true)]

        do {
            let fetched = try context.fetch(fetchRequest)
            showcaseItems = [nil, nil, nil]

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
        if collectionView == self.showcaseCollectionView {
            return 3
        } else {
            if listMode == true {
                return mediaListItems.count + 1
            } else {
                return wishListItems.count + 1
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == showcaseCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowcaseCell", for: indexPath) as! ShowcaseCell
            
            if let item = showcaseItems[indexPath.row] {
                if let urlString = item.imageURL, let url = URL(string: urlString) {
                    loadImage(from: url, into: cell.showcaseItemImg)
                }
            } else {
                cell.showcaseItemImg.image = UIImage(named: "showcasePlaceholder")
            }
            
            
            switch indexPath.row {
            case 0:
                cell.layer.borderColor = UIColor(named: "gold")?.cgColor
                cell.backgroundColor = UIColor(named: "gold")
            case 1:
                cell.layer.borderColor = UIColor(named: "silver")?.cgColor
                cell.backgroundColor = UIColor(named: "silver")
            case 2:
                cell.layer.borderColor = UIColor(named: "bronze")?.cgColor
                cell.backgroundColor = UIColor(named: "bronze")
            default:
                break
            }
            
            return cell
        } else {
            if listMode == true {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaListCell", for: indexPath) as! MediaListCell
                cell.backgroundColor = blurColour?.withAlphaComponent(0.2)
                if indexPath.row == 0 {
                    cell.mediaImage.image = UIImage(named: "showcasePlaceholder")
                } else {
                    let reversedList = Array(mediaListItems.reversed())
                    let selectedItem = reversedList[indexPath.row - 1]
                    if let urlString = selectedItem?.imageURL, let url = URL(string: urlString) {
                        loadImage(from: url, into: cell.mediaImage)
                    } else {
                        cell.mediaImage.image = UIImage(named: "noImageAvailable")
                    }
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaListCell", for: indexPath) as! MediaListCell
                cell.backgroundColor = blurColour?.withAlphaComponent(0.2)
                if indexPath.row == 0 {
                    cell.mediaImage.image = UIImage(named: "showcasePlaceholder")
                } else {
                    let reversedList = Array(wishListItems.reversed())
                    let selectedItem = reversedList[indexPath.row - 1]
                    if let urlString = selectedItem?.imageURL, let url = URL(string: urlString) {
                        loadImage(from: url, into: cell.mediaImage)
                    } else {
                        cell.mediaImage.image = UIImage(named: "noImageAvailable")
                    }
                }
                return cell
            }
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == showcaseCollectionView {
            let width = (showcaseCollectionView.bounds.width - 20) / 3
            let height = width * 1.5
            return CGSize(width: width, height: height)
        } else {
            let width = (mediaListCollectionView.bounds.width - 20) / 4
            let height = width * 1.5
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if collectionView == showcaseCollectionView {
            let position = Int64(indexPath.row + 1)
            
            if let selectedMovie = showcaseItems[indexPath.row] {
                let detailVC = storyboard.instantiateViewController(withIdentifier: "MediaDetailsViewController") as! MediaDetailsViewController
                
                detailVC.bgColour = blurColour
                detailVC.showcaseMovie = selectedMovie
                detailVC.mode = .fromShowcase(position: position)
                detailVC.completionHandler = { [weak self] in
                    self?.updateShowcase()
                    self?.updateMediaList()
                }
                present(detailVC, animated: true)
            } else {
                let searchVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseSearchViewController") as! ShowcaseSearchViewController
                searchVC.targetPosition = position
                searchVC.bgColour = blurColour
                searchVC.completionHandler = { [weak self] in
                    self?.updateShowcase()
                    self?.updateMediaList()
                }
                present(searchVC, animated: true)
            }
        } else {
            if listMode == true {
                if indexPath.row == 0 {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let searchVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseSearchViewController") as! ShowcaseSearchViewController
                    searchVC.targetPosition = 0
                    searchVC.alreadyWatched = true
                    searchVC.bgColour = blurColour
                    searchVC.completionHandler = { [weak self] in
                        self?.updateMediaList()
                    }
                    present(searchVC, animated: true)
                } else {
                    if let selectedMovie = mediaListItems[indexPath.row] {
                        let detailVC = storyboard.instantiateViewController(withIdentifier: "MediaDetailsViewController") as! MediaDetailsViewController
                        
                        detailVC.bgColour = blurColour
                        detailVC.showcaseMovie = selectedMovie
                        detailVC.mode = .fromMediaList
                        detailVC.completionHandler = { [weak self] in
                            self?.updateMediaList()
                        }
                        present(detailVC, animated: true)
                    }
                }
            } else {
                if indexPath.row == 0 {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let searchVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseSearchViewController") as! ShowcaseSearchViewController
                    searchVC.targetPosition = 0
                    searchVC.alreadyWatched = false
                    searchVC.bgColour = blurColour
                    searchVC.completionHandler = { [weak self] in
                        self?.updateMediaList()
                    }
                    present(searchVC, animated: true)
                } else {
                    if let selectedMovie = wishListItems[indexPath.row] {
                        let detailVC = storyboard.instantiateViewController(withIdentifier: "MediaDetailsViewController") as! MediaDetailsViewController
                        
                        detailVC.bgColour = blurColour
                        detailVC.showcaseMovie = selectedMovie
                        detailVC.mode = .fromMediaList
                        detailVC.completionHandler = { [weak self] in
                            self?.updateMediaList()
                        }
                        present(detailVC, animated: true)
                    }
                }
            }
        }
    }
    
    @IBOutlet var mediaTypeLbl: UILabel!
    var mediaType : String?
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func segmentTapped(_ sender: UIButton) {
        if sender == watchlistBtn {
            watchlistBtn.setTitleColor(.white, for: .normal)
            wishlistBtn.setTitleColor(.gray, for: .normal)
            listMode = true
            mediaListCollectionView.reloadData()
        } else if sender == wishlistBtn {
            watchlistBtn.setTitleColor(.gray, for: .normal)
            wishlistBtn.setTitleColor(.white, for: .normal)
            listMode = false
            mediaListCollectionView.reloadData()
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        let width = (showcaseCollectionView.bounds.width - 20) / 3
        let height = width * 1.5
        showcaseCollectionHeight.constant = height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showcaseCollectionView.dataSource = self
        showcaseCollectionView.delegate = self
        mediaListCollectionView.dataSource = self
        mediaListCollectionView.delegate = self
        
        segmentTapped(watchlistBtn)
        wishlistBtn.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
        watchlistBtn.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
        
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
        updateMediaList()
        
        print(wishListItems)
        
    }

}
