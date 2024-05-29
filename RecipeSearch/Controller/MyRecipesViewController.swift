//
//  MyRecipesViewController.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/28/24.
//

import UIKit

class MyRecipesViewController: UIViewController {
    
    @IBOutlet var myRecipesCollectionView: UICollectionView!
    
    let flowLayout = UICollectionViewFlowLayout()
    
    let networkManager = NetworkManager.shared
    
    var recipeArray:[[String:String]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
    }
    

    func setupCollectionView() {
    
        myRecipesCollectionView.delegate = self
        myRecipesCollectionView.dataSource = self

        flowLayout.scrollDirection = .vertical
        
        let collectionCellWidth = (UIScreen.main.bounds.width - 4 * (CVCell.cellColumns - 1)) / CVCell.cellColumns
        
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 4

        myRecipesCollectionView.collectionViewLayout = flowLayout
        
    }

}


extension MyRecipesViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myRecipesCollectionView.dequeueReusableCell(withReuseIdentifier: "MyRecipeCell", for: indexPath) as! MyRecipeCell
        
        if let imgUrl = recipeArray[indexPath.row]["ATT_FILE_NO_MK"]{
            let url = URL(string: imgUrl)
            cell.mainImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "star"))
            cell.mainImageView.contentMode = .scaleAspectFill
        }
        return cell
    }
    
    
}
