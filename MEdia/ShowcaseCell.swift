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
        showcaseItemLbl.font = UIFont(name: "Munro", size: 14)
        
    }
}
