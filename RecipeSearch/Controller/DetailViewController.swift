//
//  DtailViewController.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/26/24.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet var mainImageVIew: UIImageView!
    @IBOutlet var info01Label: UILabel!
    @IBOutlet var info02Label: UILabel!
    @IBOutlet var info03Label: UILabel!
    @IBOutlet var info04Label: UILabel!
    @IBOutlet var info05Label: UILabel!
    
    @IBOutlet var ingredientsLabel: UILabel!


    @IBOutlet var recipeLabels: [UILabel]!
    @IBOutlet var recipeImageViews: [UIImageView]!
    
    var recipe:[String:String]?
    var index:Int?
    var delegate:addToPicksDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        configure()
    }

    func configure(){
        if let imageUrl = recipe?["ATT_FILE_NO_MK"]{
            print(imageUrl)
            let url = URL(string: imageUrl)
            mainImageVIew.kf.setImage(with: url)
        }
        title = recipe?["RCP_NM"]
        
        info01Label.text = recipe?["INFO_ENG"]
        info02Label.text = recipe?["INFO_CAR"]
        info03Label.text = recipe?["INFO_PRO"]
        info04Label.text = recipe?["INFO_FAT"]
        info05Label.text = recipe?["INFO_NA"]
        
        ingredientsLabel.text = recipe?["RCP_PARTS_DTLS"]
        for i in 0..<recipeLabels.count{
            recipeLabels[i].text = recipe?["MANUAL0\(i+1)"]
            recipeLabels[i].numberOfLines = 0
            
            if recipe?["MANUAL0\(i+1)"] == ""{
                recipeLabels[i].text = ""
            }
        }
        
        for i in 0..<recipeImageViews.count{
            if let imageUrl = recipe?["MANUAL_IMG0\(i+1)"]{
                print(imageUrl)
                let url = URL(string: imageUrl)
                recipeImageViews[i].kf.setImage(with: url)
            }

        }
        
        mainImageVIew.contentMode = .scaleAspectFill
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let index else { return }
        delegate?.saveRecipe(index)
        navigationController?.popViewController(animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    

}
