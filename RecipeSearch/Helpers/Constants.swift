//
//  Constants.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/23/24.
//

import Foundation

    //http://openapi.foodsafetykorea.go.kr/api/0354f80ae0364303900a/COOKRCP01/json/1/5
public struct RecipeApi{
    static let requestUrl = "https://openapi.foodsafetykorea.go.kr/api"
    static let keyID = "0354f80ae0364303900a"
    static let serviceName = "COOKRCP01/json"
}


// 컬렉션뷰 구성을 위한 설정
public struct CVCell {
    static let spacingWitdh: CGFloat = 20
    static let cellColumns: CGFloat = 3
    private init() {}
}
