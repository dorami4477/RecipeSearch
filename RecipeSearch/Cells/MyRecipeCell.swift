//
//  MyRecipeCell.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/31/24.
//

import UIKit

class MyRecipeCell: UITableViewCell {

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var rcpWayLabel: UILabel!
    @IBOutlet var caloryLabel: UILabel!
    
    var index:Int16 = 0
    var recipeID:Int64? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI(){
        titleLabel.font = .boldSystemFont(ofSize: 18)
        rcpWayLabel.textColor = .darkGray
        rcpWayLabel.font = .systemFont(ofSize: 14)
        caloryLabel.font = .systemFont(ofSize: 14)
    }


    func configureData(_ recipe: Recipe){
        if let imageUrl = recipe.imageUrl, let url = URL(string: imageUrl){
            mainImageView.kf.setImage(with: url)
        }
        index = recipe.recipeIndex
        recipeID = recipe.recipeID
        
        titleLabel.text = (recipe.recipeType ?? "한식") + " | " + (recipe.recipeName ?? "음식이름")
        rcpWayLabel.text = "조리방법 :" + (recipe.recipeWay ?? "굽기")
        caloryLabel.text = "열량 :" + (recipe.recipeCal ?? "0")

    }
}
