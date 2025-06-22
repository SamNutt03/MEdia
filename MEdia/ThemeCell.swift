//
//  ThemeCell.swift
//  MEdia
//
//  Created by Sam Nuttall on 13/06/2025.
//

import UIKit

class ThemeCell: UICollectionViewCell {
    @IBOutlet var themeThumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Setup initial appearance
        themeThumbnail.contentMode = .scaleAspectFit
        themeThumbnail.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        contentView.layer.masksToBounds = true
    }
}
