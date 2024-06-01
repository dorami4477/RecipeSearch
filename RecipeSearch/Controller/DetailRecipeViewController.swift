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
    let coreManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = recipe?.recipeName
        configureTableView()
    }
    
    func configureTableView(){
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.rowHeight = UITableView.automaticDimension
        detailTableView.separatorStyle = .none
        detailTableView.register(UINib(nibName: "HowToMakeCell", bundle: nil), forCellReuseIdentifier: "HowToMakeCell")
        
        //이미지 navigation bar 위로 올리기
        if #available(iOS 11.0, *)
        {   self.detailTableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    //add MyPick
    @IBAction func addMyPickButtonTapped(_ sender: UIButton) {
        if let recipe{
            coreManager.saveToDoData(pickRecipeData: recipe) {
                print("코어 데이터에 저장")
            }
        }
        navigationController?.popViewController(animated: true)
    }

}



// MARK: - UITableView
extension DetailRecipeViewController:UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //footer
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
            return recipe?.manualSet.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = detailTableView.dequeueReusableCell(withIdentifier: DetailRecipeCell.identifier, for: indexPath) as! DetailRecipeCell
            cell.configure(recipe:self.recipe)
            cell.selectionStyle = .none
            
            return cell
        }else{
            let cell = detailTableView.dequeueReusableCell(withIdentifier: HowToMakeCell.identifier, for: indexPath) as! HowToMakeCell
            cell.selectionStyle = .none
            guard let recipe else { return UITableViewCell()}
            cell.configureData(recipe, indexPath: indexPath)
            
            return cell
            }
        
        
    }
    


    
    
}


