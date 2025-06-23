//
//  ShowcaseViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 20/06/2025.
//

import UIKit
import CoreData

extension ShowcaseViewController: ShowcaseSearchViewControllerDelegate {
    func exitSearchView() {
        updateShowcase()
    }
}

class ShowcaseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var blurColour : UIColor?
    
    @IBOutlet var showcaseCollectionView: UICollectionView!
    var showcaseItems: [ShowcaseMovies?] = [nil, nil, nil]

    
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
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        guard let data = data, let image = UIImage(data: data) else { return }
                        DispatchQueue.main.async {
                            if let currentCell = collectionView.cellForItem(at: indexPath) as? ShowcaseCell {
                                currentCell.showcaseItemImg.image = image
                            }
                        }
                    }.resume()
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseSearchViewController") as! ShowcaseSearchViewController
        searchVC.delegate = self
        searchVC.targetPosition = Int64(indexPath.row + 1)
        searchVC.blurColour = blurColour
        present(searchVC, animated: true)
    }
    
    @IBOutlet var mediaTypeLbl: UILabel!
    var mediaType : String?
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func printAllShowcaseMovies() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShowcaseMovies> = ShowcaseMovies.fetchRequest()
        
        do {
            let allItems = try context.fetch(fetchRequest)
            
            if allItems.isEmpty {
                print("📭 No ShowcaseMovies entries found.")
            } else {
                print("🎬 All ShowcaseMovies entries:")
                for item in allItems {
                    print("""
                        ————————————————
                        Title: \(item.title ?? "N/A")
                        Overview: \(item.overview ?? "N/A")
                        Image URL: \(item.imageURL ?? "N/A")
                        Position: \(item.showcasePosition)
                        """)
                }
            }
            
        } catch {
            print("❌ Failed to fetch ShowcaseMovies:", error)
        }
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
        
        //printAllShowcaseMovies()
    }

}
