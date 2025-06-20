//
//  APIResultsCell.swift
//  MEdia
//
//  Created by Sam Nuttall on 20/06/2025.
//

import UIKit

class APIResultsCell: UITableViewCell {

    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: "Silkscreen", size: 12)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
