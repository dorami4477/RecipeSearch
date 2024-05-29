//
//  ViewController.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/23/24.
//

import UIKit
import Kingfisher

final class ViewController: UIViewController, addToPicksDelegate {

    
    //컬렉션뷰
    @IBOutlet var myPicksCollectionView: UICollectionView!
    @IBOutlet var recentCollectionView: UICollectionView!
    let flowLayout = UICollectionViewFlowLayout()
    let flowLayout2 = UICollectionViewFlowLayout()

    
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)
    
    @IBOutlet var section01TitleLabel: UILabel!
    @IBOutlet var section02TitleLabel: UILabel!
    

    let dataManager = NetworkManager.shared
    
    var recipeArray:[Recipes] = []
    
    var myPicks:[Recipes] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setData()
        
        myPicksCollectionView.tag = 3
        recentCollectionView.tag = 4
    }

    override func viewWillAppear(_ animated: Bool) {
        myPicksCollectionView.reloadData()
    }

    func configure(){
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
    
    func setData(){
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

    
    func setupCollectionView(){
        // 컬렉션뷰의 스코롤 방향 설정
        flowLayout.scrollDirection = .horizontal
        
        // 아이템의 가로 구하기
       // let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWitdh * (CVCell.cellColumns - 1)) / CVCell.cellColumns
        
        let collectionCellWidth = UIScreen.main.bounds.width - CVCell.spacingWitdh - 20

        flowLayout.itemSize = CGSize(width: collectionCellWidth , height: collectionCellWidth )
        flowLayout.minimumLineSpacing = CVCell.spacingWitdh


        
        flowLayout2.scrollDirection = .horizontal
        flowLayout2.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.6 , height: UIScreen.main.bounds.width * 0.6 )
        flowLayout2.minimumLineSpacing = 20
        
        //컬렉션뷰의 속성에 할당
        recentCollectionView.collectionViewLayout = flowLayout
        myPicksCollectionView.collectionViewLayout = flowLayout2
        
    }
    
    //MyPick 저장
    func saveRecipe(_ index: Int) {
        let number  = recipeArray.firstIndex(where: { $0.recipeID == index })!
        myPicks.append(recipeArray[number])
    }
}

extension ViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            let recipe = recipeArray[indexPath.row]
            detailVC.recipe = recipe
            detailVC.index = indexPath.row
            detailVC.delegate = self
            navigationController?.pushViewController(detailVC, animated: true)

        }*/
        
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailRecipeViewController") as? DetailRecipeViewController{
            let recipe = recipeArray[indexPath.row]
            detailVC.recipe = recipe
            detailVC.index = recipe.recipeID
            detailVC.delegate = self
            navigationController?.pushViewController(detailVC, animated: true)

        }
    }
    
    
}


extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch collectionView.tag {
        case 4:
            return recipeArray.count
        case 3:
            if myPicks.count == 0{
                return 1
            }else{
                return myPicks.count
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        
        if collectionView.tag == 4{
            let cell = recentCollectionView.dequeueReusableCell(withReuseIdentifier: Cell.recipeCellIdentifier, for: indexPath) as! RecipeCell
                cell.imageUrl = recipeArray[indexPath.row].imageUrl
                return cell
  
        }else if collectionView.tag == 3{
            let cell = myPicksCollectionView.dequeueReusableCell(withReuseIdentifier: Cell.myPickCellIdentifier, for: indexPath) as! MyPicksCell
            if myPicks.count == 0{
                cell.mainImageView.image = UIImage(systemName: "questionmark.app.dashed")
            }else{
                    let url = URL(string: myPicks[indexPath.row].imageUrl)
                    cell.mainImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "questionmark.app.dashed"))
                    cell.mainImageView.layer.cornerRadius = 10
                    cell.mainImageView.clipsToBounds = true
            }
            

            return cell
        }else{
            return UICollectionViewCell()
        }
        
        
        
        
    }
    
}


extension ViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print("서치바에 입력되는 단어", searchController.searchBar.text ?? "")
        // 글자를 치는 순간에 다른 화면을 보여주고 싶다면 (컬렉션뷰를 보여줌)
        let vc = searchController.searchResultsController as! SearchResultViewController
        // 컬렉션뷰에 찾으려는 단어 전달
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
    
    
}
