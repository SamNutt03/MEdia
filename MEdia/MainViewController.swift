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
                print("poo")
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

