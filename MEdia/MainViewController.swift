//
//  ViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 11/06/2025.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var MainBG: UIImageView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let contentWidth = scrollView.contentSize.width
        let scrollViewWidth = scrollView.frame.size.width
        let middleOffsetX = (contentWidth - scrollViewWidth) / 2
        scrollView.setContentOffset(CGPoint(x: middleOffsetX, y: 0), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        MainBG.image = UIImage(named: "defaultRoomBG")
    }


}

