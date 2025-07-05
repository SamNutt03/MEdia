//
//  ViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 11/06/2025.
//

import UIKit
import CoreData

extension BedroomViewController: CustomiseViewControllerDelegate {
    func exitCustomisationView(save: Bool) {
        customiseBtnOut.isHidden = false
        if save {
            createBackground()
        }
    }
}

class BedroomViewController: UIViewController {

    @IBOutlet var customiseBtnTopConstraint: NSLayoutConstraint!
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
        
        customiseBtnTopConstraint.constant = contentViewHeight * 0.0925
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
    
    @IBOutlet var framesBtn: UIView!
    @IBOutlet var vinylsBtn: UIView!
    @IBOutlet var booksBtn: UIView!
    @IBOutlet var controllersBtn: UIView!
    @IBOutlet var tvsBtn: UIView!
    
    var bgColour : UIColor?
    
    @IBAction func customiseBtn(_ sender: UIButton) {
        customiseBtnOut.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customiseVC = storyboard.instantiateViewController(withIdentifier: "CustomiseViewController") as! CustomiseViewController
        customiseVC.delegate = self
        customiseVC.blurColour = bgColour

        present(customiseVC, animated: true, completion: nil)
    }
    
    @objc func framesButton() {

    }

    @objc func booksButton() {

    }
    
    @objc func vinylsButton() {
   
    }
    
    @objc func tvsButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showcaseVC = storyboard.instantiateViewController(withIdentifier: "MoviesShowcaseViewController") as! MoviesShowcaseViewController
        
        showcaseVC.blurColour = bgColour

        present(showcaseVC, animated: true, completion: nil)
    }
    
    @objc func controllersButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showcaseVC = storyboard.instantiateViewController(withIdentifier: "GamesShowcaseViewController") as! GamesShowcaseViewController
        
        showcaseVC.blurColour = bgColour

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
            guard let bgLayers = try context.fetch(fetchRequest).first else {
                // return default
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
                bgColour = UIColor(named: "defaultRoomColour")
                
                return
            }

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
                bgColour = UIColor(named: "blueRoomColour")
            }else if bgLayers.room == "greyRoomBG" {
                customiseBtnOut.setBackgroundImage(UIImage(named: "customiseGrey"), for: .normal)
                bgColour = .gray
            }else if bgLayers.room == "greenRoomBG" {
                customiseBtnOut.setBackgroundImage(UIImage(named: "customiseGreen"), for: .normal)
                bgColour = UIColor(named: "greenRoomColour")
            }else if bgLayers.room == "purpleRoomBG" {
                customiseBtnOut.setBackgroundImage(UIImage(named: "customisePurple"), for: .normal)
                bgColour = UIColor(named: "purpleRoomColour")
            }else if bgLayers.room == "redRoomBG" {
                customiseBtnOut.setBackgroundImage(UIImage(named: "customiseRed"), for: .normal)
                bgColour = UIColor(named: "redRoomColour")
            }else{
                customiseBtnOut.setBackgroundImage(UIImage(named: "customiseRed"), for: .normal)
                bgColour = UIColor(named: "defaultRoomColour")
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
        scrollView.panGestureRecognizer.cancelsTouchesInView = false
        let vinylTap = UITapGestureRecognizer(target: self, action: #selector(vinylsButton))
        vinylsBtn.addGestureRecognizer(vinylTap)
        let tvsTap = UITapGestureRecognizer(target: self, action: #selector(tvsButton))
        tvsBtn.addGestureRecognizer(tvsTap)
        let framesTap = UITapGestureRecognizer(target: self, action: #selector(framesButton))
        framesBtn.addGestureRecognizer(framesTap)
        let controllersTap = UITapGestureRecognizer(target: self, action: #selector(controllersButton))
        controllersBtn.addGestureRecognizer(controllersTap)
        let booksTap = UITapGestureRecognizer(target: self, action: #selector(booksButton))
        booksBtn.addGestureRecognizer(booksTap)
        
    }
    
}

