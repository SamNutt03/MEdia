//
//  ViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 11/06/2025.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var MainBG: UIImageView!
    
    var room : UIImage = UIImage(named: "defaultRoomBG")!
    var rug : UIImage = UIImage(named: "Rug1")!
    var controllers : UIImage = UIImage(named: "Controllers")!
    var tv : UIImage = UIImage(named: "boxTV")!
    var window : UIImage = UIImage(named: "SunsetWindow")!
    var bookshelf : UIImage = UIImage(named: "Books8")!
    var vinyl : UIImage = UIImage(named: "Vinyl1")!
    var plant : UIImage = UIImage(named: "Plant1")!
    var frames : UIImage = UIImage(named: "Frames2")!
        
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
        let contentWidth = scrollView.contentSize.width
        let contentHeight = scrollView.contentSize.height
        let scrollViewWidth = scrollView.frame.size.width
        let middleOffsetX = (contentWidth - scrollViewWidth) / 2
        scrollView.setContentOffset(CGPoint(x: middleOffsetX, y: 0), animated: false)
        
        let layers = [room, rug, controllers, tv, window, bookshelf, vinyl, plant, frames]
        let size = CGSize(width: contentWidth, height: contentHeight)
        
        if let stackedImage = stackImages(layers: layers, size: size) {
            MainBG.image = stackedImage
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async{
            self.createBackground()
        }
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


}

