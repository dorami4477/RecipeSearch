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
    
    func configure(recipe:[String:String]?){
        if let imageUrl = recipe?["ATT_FILE_NO_MK"]{
            print("여기서?\(imageUrl)")
            let url = URL(string: imageUrl)
            mainImageView.kf.setImage(with: url)
        }
        
        info01Label.text = recipe?["INFO_ENG"]
        info02Label.text = recipe?["INFO_CAR"]
        info03Label.text = recipe?["INFO_PRO"]
        info04Label.text = recipe?["INFO_FAT"]
        info05Label.text = recipe?["INFO_NA"]
        
        ingredientsLabel.text = recipe?["RCP_PARTS_DTLS"]

        
        mainImageView.contentMode = .scaleAspectFill
    }

}
