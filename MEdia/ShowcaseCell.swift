//
//  ShowcaseCell.swift
//  MEdia
//
//  Created by Sam Nuttall on 22/06/2025.
//

import UIKit

class ShowcaseCell: UICollectionViewCell {
    
    @IBOutlet var showcaseItemImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 3
        
    }
}
