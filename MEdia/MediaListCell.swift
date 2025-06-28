//
//  MediaListCell.swift
//  MEdia
//
//  Created by Sam Nuttall on 27/06/2025.
//

import UIKit

class MediaListCell: UICollectionViewCell {

    @IBOutlet var mediaImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.5
        mediaImage.layer.cornerRadius = 10
        mediaImage.layer.masksToBounds = true
        
        self.titleLabel.font = UIFont(name: "Silkscreen", size: 10)
        titleLabel.text = "testing"
        mediaImage.image = UIImage(named: "noImageAvailable")
        
        
        
    }

}
