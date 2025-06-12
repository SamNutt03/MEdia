//
//  CustomiseViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 12/06/2025.
//

import UIKit

class CustomiseViewController: UIViewController {
    
    var elements: [CustomBedroomElement] = [
        CustomBedroomElement(name: "Wallpaper", selectedImageName: "defaultRoomBG", availableImages: ["defaultRoomBG", "purpleRoomBG", "greenRoomBG", "redRoomBG", "blueRoomBG", "greyRoomBG"]),
        CustomBedroomElement(name: "Rug", selectedImageName: "Rug1", availableImages: ["Rug1", "Rug2", "Rug3", "Rug4"]),
        CustomBedroomElement(name: "Pet", selectedImageName: "Animal2", availableImages: ["Animal1", "Animal2", "Animal3", "Animal4", "Animal5"]),
        CustomBedroomElement(name: "Television", selectedImageName: "boxTV", availableImages: ["boxTV", "flatTV"]),
        CustomBedroomElement(name: "Window View", selectedImageName: "SunsetWindow", availableImages: ["SunsetWindow", "BeachWindow", "FarmWindow", "DesertWindow", "JungleWindow", "SnowWindow", "SpaceWindow"]),
        CustomBedroomElement(name: "Bookshelves", selectedImageName: "Books8", availableImages: ["Books1", "Books2", "Books3", "Books4", "Books5", "Books6", "Books7", "Books8", "Books9"]),
        CustomBedroomElement(name: "Record Player", selectedImageName: "Vinyl1", availableImages: ["Vinyl1", "Vinyl2", "Vinyl3", "Vinyl4"]),
        CustomBedroomElement(name: "Plant", selectedImageName: "Plant1", availableImages: ["Plant1", "Plant2", "Plant3"]),
        CustomBedroomElement(name: "Photo Frames", selectedImageName: "Frames2", availableImages: ["Frames1", "Frames2", "Frames3"])
    ]
    var currElement = 0

    @IBAction func saveChanges(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelChanges(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var nowCustomisingLbl: UILabel!
    
    @IBAction func leftArrowBtn(_ sender: UIButton) {
        if currElement == 0 {
            currElement = 9
        }
        currElement -= 1
        doAnUpdate()
        
    }
    
    @IBAction func rightArrowBtn(_ sender: UIButton) {
        if currElement == 8 {
            currElement = -1
        }
        currElement += 1
        doAnUpdate()
    }
    
    
    func doAnUpdate() {
        nowCustomisingLbl.text = elements[currElement].name
        nowCustomisingLbl.font = UIFont(name: "Silkscreen", size: 40)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = view.bounds
        blurView.backgroundColor = .darkGray.withAlphaComponent(0.75)
        blurView.alpha = 0.75
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        doAnUpdate()
        
    }
    

}
