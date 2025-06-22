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
    
    @IBOutlet var showcaseCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowcaseCell", for: indexPath) as! ShowcaseCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (showcaseCollectionView.bounds.width - 40) / 3
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    

    @IBOutlet var selectedMediaLbl: UILabel!
    @IBOutlet var mediaTypeLbl: UILabel!
    
    var mediaType : String?
    
    @IBAction func editMediaBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showcaseVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseSearchViewController") as! ShowcaseSearchViewController
        showcaseVC.delegate = self
        
        present(showcaseVC, animated: true, completion: nil)
        
    }
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func updateShowcase() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ShowcaseMovies> = ShowcaseMovies.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "showcasePosition == 1")
        
        do {
            let result = try context.fetch(fetchRequest).first
            selectedMediaLbl.text = result?.title
        }catch {
            print("Failed to fetch data")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showcaseCollectionView.dataSource = self
        showcaseCollectionView.delegate = self
        
        mediaTypeLbl.font = UIFont(name: "Silkscreen", size: 32)
        mediaTypeLbl.text = mediaType
        updateShowcase()
        
        // Do any additional setup after loading the view.
    }

}
