//
//  CommentsTableViewCell.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 18/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var commentsLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
