//
//  RecipeCell.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/24/24.
//

import UIKit

final class RecipeCell: UICollectionViewCell {
    
    @IBOutlet var mainImageView: UIImageView!
 
    // 이미지 URL을 전달받는 속성
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    

    // URL ===> 이미지를 셋팅하는 메서드
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else { return }
        
        // 오래걸리는 작업을 동시성 처리 (다른 쓰레드에서 일시킴)
        DispatchQueue.global().async {

            guard let data = try? Data(contentsOf: url) else { return }
            guard self.imageUrl! == url.absoluteString else { return }
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
    }
    
    
    private func configureUI(){
        mainImageView.image = UIImage(systemName: "questionmark.app.dashed")
        mainImageView.contentMode = .scaleAspectFill

    }
    
}


