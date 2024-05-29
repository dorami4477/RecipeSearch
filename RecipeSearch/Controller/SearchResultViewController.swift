//
//  SearchResultViewController.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/27/24.
//

import UIKit
import Kingfisher

class SearchResultViewController: UIViewController {

    @IBOutlet var resultCollectionView: UICollectionView!
    
    @IBOutlet var categoryButtons: [UIButton]!
    // 컬렉션뷰의 레이아웃을 담당하는 객체
    let flowLayout = UICollectionViewFlowLayout()
    
    let networkManager = NetworkManager.shared
    
    var recipeArray:[Recipes] = []
    
    var categoryNames = ["후식", "반찬", "일품", "국&찌개", "밥"]
    
    
    // (서치바에서) 검색을 위한 단어를 담는 변수 (전화면에서 전달받음)
    var searchTerm: String? {
        didSet {
            setupDatas(term: "/RCP_NM=\(searchTerm!)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureButtons()
        
    }
    func configureButtons() {
        var i = 0
        categoryButtons.forEach {
            $0.setTitle(categoryNames[i], for: .normal)
            $0.setTitleColor(.orange, for: .normal)
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.orange.cgColor
            i += 1
        }
    }
    


    
    @IBAction func categoryButtonClicked(_ sender: UIButton) {
        let cateName = sender.titleLabel?.text

        setupDatas(term: "/RCP_PAT2=\(cateName!)")
        resultCollectionView.reloadData()
    }
    
    
    func setupCollectionView() {
        
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        // 컬렉션뷰의 스크롤 방향 설정
        flowLayout.scrollDirection = .vertical
        
        let collectionCellWidth = (UIScreen.main.bounds.width - 4 * (CVCell.cellColumns - 1)) / CVCell.cellColumns
        
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = 4
        // 아이템 위아래 사이 간격 설정
        flowLayout.minimumLineSpacing = 4
        
        // 컬렉션뷰의 속성에 할당
        resultCollectionView.collectionViewLayout = flowLayout
        
    }
    
    // 데이터 셋업
    func setupDatas(term:String?) {
        // 옵셔널 바인딩
        guard let term else { return }
        print("네트워킹 시작 단어 \(term)")
        
        // (네트워킹 시작전에) 다시 빈배열로 만들기
        self.recipeArray = []
        
        // 네트워킹 시작 (찾고자하는 단어를 가지고)
        //RCP_NM=값
        networkManager.fetchRecipe(searchTerm: term){ result in
            switch result {
            case .success(let Datas):
                // 결과를 배열에 담고
                self.recipeArray = Datas
                print(self.recipeArray.count)
                // 컬렉션뷰를 리로드 (메인쓰레드에서)
                DispatchQueue.main.async {
                    self.resultCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
}

extension SearchResultViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        
            let imgUrl = recipeArray[indexPath.row].imageUrl
            let url = URL(string: imgUrl)
            cell.mainImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "star"))
            cell.mainImageView.contentMode = .scaleAspectFill
        
        return cell
    }
    
    
}
