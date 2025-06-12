//
//  CustomiseViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 12/06/2025.
//

import UIKit

class CustomiseViewController: UIViewController {

    @IBAction func buttonn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = view.bounds
        blurView.alpha = 0.95
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
    }
    

}
