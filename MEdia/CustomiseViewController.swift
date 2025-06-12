//
//  CustomiseViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 12/06/2025.
//

import UIKit

class CustomiseViewController: UIViewController {

    @IBAction func saveChanges(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelChanges(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = view.bounds
        blurView.backgroundColor = .darkGray.withAlphaComponent(0.75)
        blurView.alpha = 0.66
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
    }
    

}
