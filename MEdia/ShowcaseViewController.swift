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

class ShowcaseViewController: UIViewController {

    @IBOutlet var selectedMediaLbl: UILabel!
    @IBOutlet var testLbl: UILabel!
    
    var testText : String?
    
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
        testLbl.text = testText
        updateShowcase()
        
        // Do any additional setup after loading the view.
    }

}
