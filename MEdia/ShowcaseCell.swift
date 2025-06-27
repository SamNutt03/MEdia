//
//  ShowcaseCell.swift
//  MEdia
//
//  Created by Sam Nuttall on 22/06/2025.
//

import UIKit

class ShowcaseCell: UICollectionViewCell {
    
    @IBOutlet var showcaseItemLbl: UILabel!
    @IBOutlet var showcaseItemImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showcaseItemLbl.font = UIFont(name: "Silkscreen", size: 10)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 3
        
    }
}
