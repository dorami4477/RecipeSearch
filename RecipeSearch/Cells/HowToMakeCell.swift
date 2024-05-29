//
//  HowToMakeCell.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/28/24.
//

import UIKit

class HowToMakeCell: UITableViewCell {

    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
