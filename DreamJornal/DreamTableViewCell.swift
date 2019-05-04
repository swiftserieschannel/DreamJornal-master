//
//  DreamTableViewCell.swift
//  DreamJornal
//
//  Created by Adriana Pedroza Larsson on 2019-04-14.
//  Copyright © 2019 Adriana Pedroza Larsson. All rights reserved.
//

import UIKit

class DreamTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    @IBOutlet weak var imageCell: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
