//
//  DetailRecipeViewController.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/28/24.
//

import UIKit
import Kingfisher

final class DetailRecipeViewController: UIViewController{

    @IBOutlet var detailTableView: UITableView!
    @IBOutlet var addButton: UIButton!
    
    var recipe: Recipes?
    let coreManager = CoreDataManager.shared
    var showAddButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = recipe?.recipeName
        configureTableView()
        addButtonHidden()
    }
    
    private func addButtonHidden(){
        if showAddButton{
            addButton.layer.isHidden = false
        }else{
            addButton.layer.isHidden = true
        }
        
    }
    
    private func configureTableView(){
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
        let myPicksFromCore = coreManager.getToDoListFromCoreData()
        guard let recipe else { return }
        if myPicksFromCore.contains(where:{ $0.recipeID == Int64(recipe.recipeID) }){
            let alert = UIAlertController(title: "이미 있어요!", message: "동일한 레시피가 이미 저장 되어 있습니다.", preferredStyle: .alert)
            
            let confirm = UIAlertAction(title: "확인", style: .default)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(cancel)
            alert.addAction(confirm)
            
            present(alert, animated: true)
        }else{
                coreManager.saveToDoData(pickRecipeData: recipe) {
                    print("코어 데이터에 저장")
                }
            navigationController?.popViewController(animated: true)
        }
        
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
            if showAddButton{ //저장된 레시피 일 경우
                return 60
            }else{
                return 0
            }
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


