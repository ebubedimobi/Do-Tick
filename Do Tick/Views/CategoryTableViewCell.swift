//
//  CategoryTableViewCell.swift
//  Do Tick
//
//  Created by Ebubechukwu Dimobi on 21.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryViewHolder: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryViewHolder.layer.cornerRadius = categoryViewHolder.frame.size.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
