//
//  MediaListCell.swift
//  MEdia
//
//  Created by Sam Nuttall on 27/06/2025.
//

import UIKit

class MediaListCell: UICollectionViewCell {

    @IBOutlet var mediaImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
        mediaImage.layer.cornerRadius = 5
        mediaImage.layer.masksToBounds = true
        
        
        
    }

}
