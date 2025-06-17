//
//  ViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 11/06/2025.
//

import UIKit
import CoreData

extension MainViewController: CustomiseViewControllerDelegate {
    func didFinishCustomising() {
        customiseBtnOut.isHidden = false
        createBackground()
    }
}

class MainViewController: UIViewController {
    
    @IBOutlet var framesLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var framesTopConstraint: NSLayoutConstraint!
    @IBOutlet var vinylsTopConstraint: NSLayoutConstraint!
    @IBOutlet var vinylsLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var booksTopConstraint: NSLayoutConstraint!
    @IBOutlet var booksLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var controllersTopConstraint: NSLayoutConstraint!
    @IBOutlet var controllersLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var tvsTopConstraint: NSLayoutConstraint!
    @IBOutlet var tvsLeadingConstraint: NSLayoutConstraint!
    
    func configureButtonConstraints() {
        let contentViewWidth = contentView.bounds.width
        let contentViewHeight = contentView.bounds.height
        
        framesLeadingConstraint.constant = contentViewWidth * 0.0782
        framesTopConstraint.constant = contentViewHeight * 0.141
        vinylsLeadingConstraint.constant = contentViewWidth * 0.18
        vinylsTopConstraint.constant = contentViewHeight * 0.411
        booksLeadingConstraint.constant = contentViewWidth * 0.704
        booksTopConstraint.constant = contentViewHeight * 0.176
        controllersLeadingConstraint.constant = contentViewWidth * 0.548
        controllersTopConstraint.constant = contentViewHeight * 0.722
        tvsLeadingConstraint.constant = contentViewWidth * 0.767
        tvsTopConstraint.constant = contentViewHeight * 0.505
    }
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var customiseBtnOut: UIButton!
    @IBOutlet var MainBG: UIImageView!
    
    @IBAction func customiseBtn(_ sender: UIButton) {
        customiseBtnOut.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customiseVC = storyboard.instantiateViewController(withIdentifier: "CustomiseViewController") as! CustomiseViewController
        customiseVC.delegate = self

        present(customiseVC, animated: true, completion: nil)
    }
    
    @IBAction func framesButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showcaseVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseViewController") as! ShowcaseViewController
        
        showcaseVC.testText = "frames"
        
        present(showcaseVC, animated: true, completion: nil)
    }
    @IBAction func booksButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showcaseVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseViewController") as! ShowcaseViewController
        
        showcaseVC.testText = "books"

        present(showcaseVC, animated: true, completion: nil)
    }
    @IBAction func vinylsButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showcaseVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseViewController") as! ShowcaseViewController
        
        showcaseVC.testText = "vinyls"

        present(showcaseVC, animated: true, completion: nil)
    }
    @IBAction func tvsButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showcaseVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseViewController") as! ShowcaseViewController
        
        showcaseVC.testText = "tvs"

        present(showcaseVC, animated: true, completion: nil)
    }
    @IBAction func controllersButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showcaseVC = storyboard.instantiateViewController(withIdentifier: "ShowcaseViewController") as! ShowcaseViewController
        
        showcaseVC.testText = "controllers"

        present(showcaseVC, animated: true, completion: nil)
    }
    
        
    func stackImages(layers: [UIImage], size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        for layer in layers {
            layer.draw(in: CGRect(origin: .zero, size: size))
        }

        let stackedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return stackedImage
    }
    
    func createBackground() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BedroomLayers> = BedroomLayers.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            if results == [] {
                let initialLayers: BedroomLayers = BedroomLayers(context: context)
                initialLayers.room = "defaultRoomBG"
                initialLayers.rug = "Rug1"
                initialLayers.controller = "Controllers"
                initialLayers.animal = "Animal2"
                initialLayers.tv = "boxTV"
                initialLayers.window = "SunsetWindow"
                initialLayers.bookshelf = "Books8"
                initialLayers.vinyl = "Vinyl1"
                initialLayers.plant = "Plant1"
                initialLayers.frames = "Frames2"
                try context.save()
            }else{
                let bgLayers: BedroomLayers = try context.fetch(fetchRequest).first!
                let room : UIImage = UIImage(named: bgLayers.room!)!
                let rug : UIImage = UIImage(named: bgLayers.rug!)!
                let controllers : UIImage = UIImage(named: bgLayers.controller!)!
                let animal : UIImage = UIImage(named: bgLayers.animal!)!
                let tv : UIImage = UIImage(named: bgLayers.tv!)!
                let window : UIImage = UIImage(named: bgLayers.window!)!
                let bookshelf : UIImage = UIImage(named: bgLayers.bookshelf!)!
                let vinyl : UIImage = UIImage(named: bgLayers.vinyl!)!
                let plant : UIImage = UIImage(named: bgLayers.plant!)!
                let frames : UIImage = UIImage(named: bgLayers.frames!)!
                
                let contentWidth = scrollView.contentSize.width
                let contentHeight = scrollView.contentSize.height
                let scrollViewWidth = scrollView.frame.size.width
                let middleOffsetX = (contentWidth - scrollViewWidth) / 2
                scrollView.setContentOffset(CGPoint(x: middleOffsetX, y: 0), animated: false)
                let layers = [room, rug, controllers, animal, tv, window, bookshelf, vinyl, plant, frames]
                let size = CGSize(width: contentWidth, height: contentHeight)
                
                if let stackedImage = stackImages(layers: layers, size: size) {
                    MainBG.image = stackedImage
                }
                
                if bgLayers.room == "blueRoomBG" {
                    customiseBtnOut.setBackgroundImage(UIImage(named: "customiseBlue"), for: .normal)
                }else if bgLayers.room == "greyRoomBG" {
                    customiseBtnOut.setBackgroundImage(UIImage(named: "customiseGrey"), for: .normal)
                }else if bgLayers.room == "greenRoomBG" {
                    customiseBtnOut.setBackgroundImage(UIImage(named: "customiseGreen"), for: .normal)
                }else if bgLayers.room == "purpleRoomBG" {
                    customiseBtnOut.setBackgroundImage(UIImage(named: "customisePurple"), for: .normal)
                }else {
                    customiseBtnOut.setBackgroundImage(UIImage(named: "customiseRed"), for: .normal)
                }
            }
        }catch {
            print("Error: \(error)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async{
            self.createBackground()
            self.configureButtonConstraints()
            self.customiseBtnOut.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customiseBtnOut.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


}

