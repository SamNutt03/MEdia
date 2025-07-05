//
//  MoviesAPIResultsCell.swift
//  MEdia
//
//  Created by Sam Nuttall on 20/06/2025.
//

import UIKit

class MoviesAPIResultsCell: UITableViewCell {

    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: "Silkscreen", size: 12)
        posterImage.layer.masksToBounds = true
        posterImage.layer.cornerRadius = 5
        selectedBackgroundView = {
            let view = UIView.init()
            view.backgroundColor = .clear
            return view
        }()
        
    }

}
