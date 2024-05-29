//
//  DetailRecipeCell.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/28/24.
//

import UIKit

class DetailRecipeCell: UITableViewCell {

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var info01Label: UILabel!
    @IBOutlet var info02Label: UILabel!
    @IBOutlet var info03Label: UILabel!
    @IBOutlet var info04Label: UILabel!
    @IBOutlet var info05Label: UILabel!
    
    @IBOutlet var ingredientsLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(recipe:Recipes?){
        
        if let imagUrl = recipe?.imageUrl{
            let url = URL(string: imagUrl)
            mainImageView.kf.setImage(with: url)
        }
        
        info01Label.text = recipe?.recipeCal
        info02Label.text = recipe?.infoCar
        info03Label.text = recipe?.infoPro
        info04Label.text = recipe?.infoFat
        info05Label.text = recipe?.infoNa
        
        ingredientsLabel.text = recipe?.ingredient

        
        mainImageView.contentMode = .scaleAspectFill
    }

}
