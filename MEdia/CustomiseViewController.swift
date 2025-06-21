//
//  CustomiseViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 12/06/2025.
//

import UIKit
import CoreData

protocol CustomiseViewControllerDelegate: AnyObject {
    func exitCustomisationView(save: Bool)
}

class CustomiseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: CustomiseViewControllerDelegate?
    var blurColour : UIColor?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements[currElement].availableImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCell", for: indexPath) as! ThemeCell
        cell.themeThumbnail.image = UIImage(named: elements[currElement].availableImages[indexPath.item]+"TN")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = (collectionView.bounds.height - 40) / 3
        if elements[currElement].availableImages.count < 7 {
            size = (collectionView.bounds.width - 40) / 3
        }
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        elements[currElement].selectedImageName = elements[currElement].availableImages[indexPath.item]
        doAnUpdate()
    }
    
    
    var elements: [CustomBedroomElement] = []

    @IBAction func saveChanges(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BedroomLayers> = BedroomLayers.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            let bgLayers: BedroomLayers
            
            if let existing = results.first {
                bgLayers = existing
            } else {
                bgLayers = BedroomLayers(context: context)
            }
            
            for element in elements {
                switch element.name {
                case "Wallpaper":
                    bgLayers.room = element.selectedImageName
                case "Rug":
                    bgLayers.rug = element.selectedImageName
                case "Pet":
                    bgLayers.animal = element.selectedImageName
                case "Television":
                    bgLayers.tv = element.selectedImageName
                case "Window View":
                    bgLayers.window = element.selectedImageName
                case "Bookshelves":
                    bgLayers.bookshelf = element.selectedImageName
                case "Record Player":
                    bgLayers.vinyl = element.selectedImageName
                case "Plant":
                    bgLayers.plant = element.selectedImageName
                case "Photo Frames":
                    bgLayers.frames = element.selectedImageName
                default:
                    break
                }
            }
            
            try context.save()
            print("Customisation saved")
            dismiss(save: true)
        }
        catch {
            print("Error: \(error)")
        }
    }
    
    private func dismiss(save: Bool = false) {
        delegate?.exitCustomisationView(save: save)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelChanges(_ sender: UIButton) {
        dismiss()
    }
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nowCustomisingLbl: UILabel!
    @IBOutlet var chooseThemeLbl: UILabel!
    @IBOutlet var mainThumbnail: UIImageView!
    @IBOutlet var leftThumbnail: UIImageView!
    @IBOutlet var rightThumbnail: UIImageView!
    var currElement = 0
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
        var nextElement = currElement + 1
        if nextElement == 9 {nextElement = 0}
        var prevElement = currElement - 1
        if prevElement == -1 {prevElement = 8}
        nowCustomisingLbl.text = elements[currElement].name
        mainThumbnail.image = UIImage(named: elements[currElement].selectedImageName + "TN")
        rightThumbnail.image = UIImage(named: elements[nextElement].selectedImageName + "TN")
        leftThumbnail.image = UIImage(named: elements[prevElement].selectedImageName + "TN")
        collectionView.reloadData()
    }
    
    func fetchElements() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BedroomLayers> = BedroomLayers.fetchRequest()
        do{
            let currElements = try context.fetch(fetchRequest).first!
            
            elements = [
                CustomBedroomElement(name: "Wallpaper", selectedImageName: (currElements.room)!, availableImages: ["defaultRoomBG", "purpleRoomBG", "greenRoomBG", "redRoomBG", "blueRoomBG", "greyRoomBG"]),
                CustomBedroomElement(name: "Rug", selectedImageName: (currElements.rug)!, availableImages: ["Rug1", "Rug2", "Rug3", "Rug4"]),
                CustomBedroomElement(name: "Pet", selectedImageName: (currElements.animal)!, availableImages: ["Animal1", "Animal2", "Animal3", "Animal4", "Animal5"]),
                CustomBedroomElement(name: "Television", selectedImageName: (currElements.tv)!, availableImages: ["boxTV", "flatTV"]),
                CustomBedroomElement(name: "Window View", selectedImageName: (currElements.window)!, availableImages: ["SunsetWindow", "BeachWindow", "FarmWindow", "DesertWindow", "JungleWindow", "SnowWindow", "SpaceWindow"]),
                CustomBedroomElement(name: "Bookshelves", selectedImageName: (currElements.bookshelf)!, availableImages: ["Books1", "Books2", "Books3", "Books4", "Books5", "Books6", "Books7", "Books8", "Books9"]),
                CustomBedroomElement(name: "Record Player", selectedImageName: (currElements.vinyl)!, availableImages: ["Vinyl1", "Vinyl2", "Vinyl3", "Vinyl4"]),
                CustomBedroomElement(name: "Plant", selectedImageName: (currElements.plant)!, availableImages: ["Plant1", "Plant2", "Plant3"]),
                CustomBedroomElement(name: "Photo Frames", selectedImageName: (currElements.frames)!, availableImages: ["Frames1", "Frames2", "Frames3"])
            ]
        }catch{
            print("Error: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if blurColour == nil {
            blurColour = .systemGray2
        }
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = view.bounds
        blurView.backgroundColor = blurColour?.withAlphaComponent(0.6)
        blurView.alpha = 0.8
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        nowCustomisingLbl.font = UIFont(name: "Silkscreen", size: 40)
        chooseThemeLbl.font = UIFont(name: "Silkscreen", size: 28)
        
        fetchElements()
        doAnUpdate()
    }
    

}
