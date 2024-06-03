//
//  HowToMakeCell.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/28/24.
//

import UIKit

final class HowToMakeCell: UITableViewCell {

    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureData(_ data:Recipes, indexPath:IndexPath){
        recipeLabel.text = data.manualSet[indexPath.row]
        let url = URL(string: data.manualImgSet[indexPath.row])
        recipeImageView.kf.setImage(with: url)
        
    }
}
