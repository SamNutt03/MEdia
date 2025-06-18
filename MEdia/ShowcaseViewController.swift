//
//  ShowcaseViewController.swift
//  MEdia
//
//  Created by Sam Nuttall on 17/06/2025.
//

import UIKit

class ShowcaseViewController: UIViewController {
    
    var testText : String?
    
    @IBAction func backbutton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBOutlet var test: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        test.text = testText
    }


}
