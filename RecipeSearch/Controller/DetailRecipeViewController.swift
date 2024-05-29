//
//  DetailRecipeViewController.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/28/24.
//

import UIKit
import Kingfisher

class DetailRecipeViewController: UIViewController{

    

    @IBOutlet var detailTableView: UITableView!
    
    var recipe: Recipes?
    var index:Int?
    var delegate:addToPicksDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.rowHeight = UITableView.automaticDimension
        //detailTableView.estimatedRowHeight = 600
        detailTableView.dataSource = self
        detailTableView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = false
        title = recipe?.recipeName
        detailTableView.separatorStyle = .none
        detailTableView.register(UINib(nibName: "HowToMakeCell", bundle: nil), forCellReuseIdentifier: "HowToMakeCell")

    }
    
    @IBAction func addMyPickButtonTapped(_ sender: UIButton) {
        print(#function)
        guard let index else { return }
        delegate?.saveRecipe(index)
        navigationController?.popViewController(animated: true)
    }
    
}

extension DetailRecipeViewController:UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return (recipe?.manualSet.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "DetailRecipeCell", for: indexPath) as! DetailRecipeCell
            cell.configure(recipe:self.recipe)
            cell.selectionStyle = .none
            
            return cell
        }else{
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "HowToMakeCell", for: indexPath) as! HowToMakeCell
            cell.selectionStyle = .none
            cell.recipeLabel.text = recipe?.manualSet[indexPath.row]
            if let imageUrl = recipe?.manualImgSet[indexPath.row]{
                print(imageUrl)
                let url = URL(string: imageUrl)
                cell.recipeImageView.kf.setImage(with: url)
            }
            return cell
        }
        
        
    }
    


    
    
}
