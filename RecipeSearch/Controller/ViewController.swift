//
//  ViewController.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/23/24.
//

import UIKit
import Kingfisher

final class ViewController: UIViewController{

    
    //컬렉션뷰
    @IBOutlet var myPicksCollectionView: UICollectionView!
    @IBOutlet var recentCollectionView: UICollectionView!
    private let flowLayout = UICollectionViewFlowLayout()
    private let flowLayout2 = UICollectionViewFlowLayout()

    
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SearchResultViewController.identifier) as! SearchResultViewController)
    
    @IBOutlet var section01TitleLabel: UILabel!
    @IBOutlet var section02TitleLabel: UILabel!

    let dataManager = NetworkManager.shared
    let coreManager = CoreDataManager.shared
    
    var recipeArray:[Recipes] = []
    
    lazy var myPicks:[Recipe] = coreManager.getToDoListFromCoreData()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        myPicks = coreManager.getToDoListFromCoreData()
        myPicksCollectionView.reloadData()
    }

    private func configure(){
        section01TitleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        section02TitleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        
        setupCollectionView()
        recentCollectionView.dataSource = self
        recentCollectionView.delegate = self
        myPicksCollectionView.dataSource = self
        myPicksCollectionView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
    }
    
    private func setData(){
        dataManager.fetchRecipe(searchTerm: nil){ result in
            print(#function)
            switch result {
            case .success(let recipeDatas):
                // 데이터(배열)을 받아오고 난 후
                self.recipeArray = recipeDatas
                DispatchQueue.main.async {
                    self.recentCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
    private func setupCollectionView(){

        flowLayout.scrollDirection = .horizontal

        let collectionCellWidth = UIScreen.main.bounds.width - CVCell.spacingWitdh - 20

        flowLayout.itemSize = CGSize(width: collectionCellWidth , height: collectionCellWidth )
        flowLayout.minimumLineSpacing = CVCell.spacingWitdh

        flowLayout2.scrollDirection = .horizontal
        flowLayout2.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.6 , height: UIScreen.main.bounds.width * 0.6 )
        flowLayout2.minimumLineSpacing = 20
        
        recentCollectionView.collectionViewLayout = flowLayout
        myPicksCollectionView.collectionViewLayout = flowLayout2
        
    }

}



// MARK: - UICollectionView
extension ViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    
    //셀 클릭시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: DetailRecipeViewController.identifier) as! DetailRecipeViewController
        switch collectionView {
        case myPicksCollectionView:
            let recipe = myPicks[indexPath.row]
            detailVC.recipe = Recipes(recipeID: Int(recipe.recipeID), recipeName: recipe.recipeName!, recipeWay: recipe.recipeWay!, recipeType: recipe.recipeType!, ingredient:recipe.ingredient!, recipeCal: recipe.recipeCal!, infoCar: recipe.infoCar!, infoPro: recipe.infoPro!, infoFat: recipe.infoFat!, infoNa: recipe.infoNa!, imageUrl: recipe.imageUrl!, manualSet: recipe.manualSet, manualImgSet: recipe.manualImgSet)
            detailVC.showAddButton = false
        case recentCollectionView:
            let recipe = recipeArray[indexPath.row]
            detailVC.recipe = recipe
            detailVC.showAddButton = true
        default:
            let recipe = recipeArray[indexPath.row]
            detailVC.recipe = recipe
        }
        
        navigationController?.pushViewController(detailVC, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {

        case myPicksCollectionView:
            if myPicks.count == 0{
                return 1
            }else{
                return myPicks.count
            }

        case recentCollectionView:
            return recipeArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Recipe collectionView
        if collectionView == recentCollectionView{
            let cell = recentCollectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
                cell.imageUrl = recipeArray[indexPath.row].imageUrl
                return cell
  
        //myPick collectionView
        }else if collectionView == myPicksCollectionView{
            let cell = myPicksCollectionView.dequeueReusableCell(withReuseIdentifier: MyPicksCell.identifier, for: indexPath) as! MyPicksCell
            if myPicks.count == 0{
                cell.mainImageView.image = UIImage(systemName: "questionmark.app.dashed")
            }else{
                let url = URL(string: myPicks[indexPath.row].imageUrl!)
                cell.mainImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "questionmark.app.dashed"))
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
        
   
    }
    
}

// MARK: - Search
extension ViewController:UISearchResultsUpdating, CategoryDelegate{
    func saveCategory(_ categoryName: String) {
        searchController.searchBar.text = categoryName
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("서치바에 입력되는 단어", searchController.searchBar.text ?? "")
        // 글자를 치는 순간에 다른 화면을 보여주고 싶다면 (컬렉션뷰를 보여줌)
        let vc = searchController.searchResultsController as! SearchResultViewController
        // 컬렉션뷰에 찾으려는 단어 전달
        vc.delegate = self
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}
