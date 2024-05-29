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
    
    var recipe:[String:String]?
    var index:Int?
    var delegate:addToPicksDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.rowHeight = UITableView.automaticDimension
        //detailTableView.estimatedRowHeight = 600
        detailTableView.dataSource = self
        detailTableView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = false
        title = recipe?["RCP_NM"]
        detailTableView.separatorStyle = .none
        detailTableView.register(UINib(nibName: "HowToMakeCell", bundle: nil), forCellReuseIdentifier: "HowToMakeCell")

    }

}

extension DetailRecipeViewController:UITableViewDelegate, UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "DetailRecipeCell", for: indexPath) as! DetailRecipeCell
            cell.configure(recipe:self.recipe)
            cell.selectionStyle = .none
            
            return cell
        }else{
            
            let cell = detailTableView.dequeueReusableCell(withIdentifier: "HowToMakeCell", for: indexPath) as! HowToMakeCell
            cell.recipeLabel.text = recipe?["MANUAL0\(indexPath.row)"]
            if let imageUrl = recipe?["MANUAL_IMG0\(indexPath.row)"]{
                print(imageUrl)
                let url = URL(string: imageUrl)
                cell.recipeImageView.kf.setImage(with: url)
            }
            return cell
        }
        
        
    }
    


    
    
}
