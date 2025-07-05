//
//  GamesShowcaseViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 20/06/2025.
//

import UIKit
import CoreData

class GamesShowcaseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var blurColour : UIColor?
    var listMode = true
    
    @IBOutlet var watchlistBtn: UIButton!
    @IBOutlet var wishlistBtn: UIButton!
    
    @IBOutlet var mediaListCollectionView: UICollectionView!
    @IBOutlet var mediaListBgLbl: UILabel!
    @IBOutlet var showcaseCollectionView: UICollectionView!
    @IBOutlet var showcaseCollectionHeight: NSLayoutConstraint!
    var showcaseItems: [ShowcaseGames?] = [nil, nil, nil]
    var mediaListItems: [ShowcaseGames?] = []
    var wishListItems: [ShowcaseGames?] = []
    
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
    
    func updateEmptyLbl() {
        if listMode == true {
            mediaListBgLbl.isHidden = !mediaListItems.isEmpty
        } else {
            mediaListBgLbl.isHidden = !wishListItems.isEmpty
        }
    }

    func updateMediaList() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShowcaseGames> = ShowcaseGames.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "showcasePosition == 0 AND alreadyPlayed == true")
        mediaListItems = (try? context.fetch(fetchRequest)) ?? []
        
        fetchRequest.predicate = NSPredicate(format: "showcasePosition == 0 AND alreadyPlayed == false")
        wishListItems = (try? context.fetch(fetchRequest)) ?? []
        
        updateEmptyLbl()
        mediaListCollectionView.reloadData()
    }
    
    func updateShowcase() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShowcaseGames> = ShowcaseGames.fetchRequest()
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
            return 4
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
            if indexPath.row == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameShowcaseTitlesCell", for: indexPath) as! GameShowcaseTitlesCell
                if let item1 = showcaseItems[0] {
                    cell.goldMedal.isHidden = false
                    cell.firstTitle.text = item1.title
                }
                if let item2 = showcaseItems[1] {
                    cell.silverMedal.isHidden = false
                    cell.secondTitle.text = item2.title
                }
                if let item3 = showcaseItems[2] {
                    cell.bronzeMedal.isHidden = false
                    cell.thirdTitle.text = item3.title
                }
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowcaseCell", for: indexPath) as! ShowcaseCell
            
            if let item = showcaseItems[indexPath.row] {
                if let urlString = item.imageURL, let url = URL(string: urlString) {
                    loadImage(from: url, into: cell.showcaseItemImg)
                }
            } else {
                cell.showcaseItemImg.image = UIImage(named: "addImage")
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
                    cell.mediaImage.image = UIImage(named: "addImage")
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
                    cell.mediaImage.image = UIImage(named: "addImage")
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
            let width = (showcaseCollectionView.bounds.width - 20) / 2
            let height = width * (9/16)
            return CGSize(width: width, height: height)
        } else {
            let width = (mediaListCollectionView.bounds.width - 20) / 3
            let height = width * (9/16)
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if collectionView == showcaseCollectionView {
            if indexPath.row == 3 {
                return
            }
            
            let position = Int64(indexPath.row + 1)
            
            if let selectedGame = showcaseItems[indexPath.row] {
                let detailVC = storyboard.instantiateViewController(withIdentifier: "GamesDetailsViewController") as! GamesDetailsViewController
                
                detailVC.bgColour = blurColour
                detailVC.showcaseGame = selectedGame
                detailVC.mode = .fromShowcase(position: position)
                detailVC.completionHandler = { [weak self] in
                    self?.updateShowcase()
                    self?.updateMediaList()
                }
                present(detailVC, animated: true)
            } else {
                let searchVC = storyboard.instantiateViewController(withIdentifier: "GamesShowcaseSearchViewController") as! GamesShowcaseSearchViewController
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
                    let searchVC = storyboard.instantiateViewController(withIdentifier: "GamesShowcaseSearchViewController") as! GamesShowcaseSearchViewController
                    searchVC.targetPosition = 0
                    searchVC.alreadyPlayed = true
                    searchVC.bgColour = blurColour
                    searchVC.completionHandler = { [weak self] in
                        self?.updateMediaList()
                    }
                    present(searchVC, animated: true)
                } else {
                    if let selectedGame = mediaListItems.reversed()[indexPath.row - 1] {
                        let detailVC = storyboard.instantiateViewController(withIdentifier: "GamesDetailsViewController") as! GamesDetailsViewController
                        
                        detailVC.bgColour = blurColour
                        detailVC.showcaseGame = selectedGame
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
                    let searchVC = storyboard.instantiateViewController(withIdentifier: "GamesShowcaseSearchViewController") as! GamesShowcaseSearchViewController
                    searchVC.targetPosition = 0
                    searchVC.alreadyPlayed = false
                    searchVC.bgColour = blurColour
                    searchVC.completionHandler = { [weak self] in
                        self?.updateMediaList()
                    }
                    present(searchVC, animated: true)
                } else {
                    if let selectedGame = wishListItems.reversed()[indexPath.row - 1] {
                        let detailVC = storyboard.instantiateViewController(withIdentifier: "GamesDetailsViewController") as! GamesDetailsViewController
                        
                        detailVC.bgColour = blurColour
                        detailVC.showcaseGame = selectedGame
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
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func segmentTapped(_ sender: UIButton) {
        if sender == watchlistBtn {
            watchlistBtn.setTitleColor(.white, for: .normal)
            wishlistBtn.setTitleColor(.gray, for: .normal)
            listMode = true
        } else if sender == wishlistBtn {
            watchlistBtn.setTitleColor(.gray, for: .normal)
            wishlistBtn.setTitleColor(.white, for: .normal)
            listMode = false
        }
        
        updateEmptyLbl()
        mediaListCollectionView.reloadData()
    }
    
    
    override func viewWillLayoutSubviews() {
        let width = (showcaseCollectionView.bounds.width - 20) / 2
        let height = width * (9/16) * 2 + 20
        showcaseCollectionHeight.constant = height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showcaseCollectionView.dataSource = self
        showcaseCollectionView.delegate = self
        mediaListCollectionView.dataSource = self
        mediaListCollectionView.delegate = self
        mediaListCollectionView.layer.cornerRadius = 5
        
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
        updateShowcase()
        updateMediaList()
        
        segmentTapped(watchlistBtn)
        wishlistBtn.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
        watchlistBtn.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
    }

}
