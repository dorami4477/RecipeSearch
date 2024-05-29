//
//  Recipe.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/23/24.
//

import Foundation

protocol addToPicksDelegate:AnyObject{
    func saveRecipe(_ index:Int)
}

struct Recipes {
    let recipeID: Int // 일련번호
    let recipeName: String // 메뉴명
    let recipeWay: String // 조리방법
    let recipeType: String // 요리종류
    let ingredient:String //재료
    let recipeCal: String // 열량
    let infoCar: String // 탄수화물
    let infoPro: String // 단백질
    let infoFat: String // 지방
    let infoNa: String // 나트륨
    let imageUrl: String // 이미지경로
    let manualSet:[String] //만드는 방법
    let manualImgSet:[String] //만드는 방법 이미지
}

// MARK: - 네트워크로부터 받아오는 데이터
struct apiData: Codable {
    let cookRecipes: cookRecipes

    enum CodingKeys: String, CodingKey {
        case cookRecipes = "COOKRCP01"
    }
}

// MARK: - cookRecipes
struct cookRecipes: Codable {
    let totalCount: String
    let info: [[String: String]]
    let results: Results

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case info = "row"
        case results = "RESULT"
    }
}

// MARK: - Result
struct Results: Codable {
    let msg, code: String

    enum CodingKeys: String, CodingKey {
        case msg = "MSG"
        case code = "CODE"
    }
}


/*
// 레시피 세부 정보 모델
struct Recipe: Codable {
    let rcpName : String?
    let rcpIngredientsInfo : String?
    let repWay : String?
    let repType : String?
    let repSEQ : String?
    
    let rcpMainImageURL : String?
    
    enum CodingKeys: String, CodingKey {
        case rcpName = "RCP_NM" //메뉴명
        case rcpIngredientsInfo = "RCP_PARTS_DTLS" //재료정보
        case repWay = "RCP_WAY2" // 조리방법
        case repType = "RCP_PAT2" //요리종류
        case repSEQ = "RCP_SEQ" // 일련번호
        
        case rcpMainImageURL = "ATT_FILE_NO_MK" //이미지경로(대)
    }
}

struct CookRecipe : Codable {
    let totalCount : String?
    let recipes : [Recipe]?

    enum CodingKeys: String, CodingKey {

        case totalCount = "total_count"
        case recipes = "row"
    }
}


struct Recipe : Codable {
    
    let rcpName : String?
    let rcpIngredientsInfo : String?
    let repWay : String?
    let repType : String?
    let repSEQ : String?
    
    let rcpMainImageURL : String?
    
    let mANUAL_IMG20 : String?
    let mANUAL20 : String?
    let iNFO_NA : String?
    let iNFO_WGT : String?
    let iNFO_PRO : String?
    let mANUAL_IMG13 : String?
    let mANUAL_IMG14 : String?
    let mANUAL_IMG15 : String?
    let mANUAL_IMG16 : String?
    let mANUAL_IMG10 : String?
    let mANUAL_IMG11 : String?
    let mANUAL_IMG12 : String?
    let mANUAL_IMG17 : String?
    let mANUAL_IMG18 : String?
    let mANUAL_IMG19 : String?
    let iNFO_FAT : String?
    let hASH_TAG : String?
    let mANUAL_IMG02 : String?
    let mANUAL_IMG03 : String?
    
    let mANUAL_IMG04 : String?
    let mANUAL_IMG05 : String?
    let mANUAL_IMG01 : String?
    let mANUAL01 : String?
    let mANUAL_IMG06 : String?
    let mANUAL_IMG07 : String?
    let mANUAL_IMG08 : String?
    let mANUAL_IMG09 : String?
    let mANUAL08 : String?
    let mANUAL09 : String?
    let mANUAL06 : String?
    let mANUAL07 : String?
    let mANUAL04 : String?
    let mANUAL05 : String?
    let mANUAL02 : String?
    let mANUAL03 : String?
    let aTT_FILE_NO_MAIN : String?
    let mANUAL11 : String?
    let mANUAL12 : String?
    let mANUAL10 : String?
    let iNFO_CAR : String?
    let mANUAL19 : String?
    let rCP_NA_TIP : String?
    let iNFO_ENG : String?
    let mANUAL17 : String?
    let mANUAL18 : String?
    
    let mANUAL15 : String?
    let mANUAL16 : String?
    let mANUAL13 : String?
    let mANUAL14 : String?

    enum CodingKeys: String, CodingKey {

        case rcpName = "RCP_NM" //메뉴명
        case rcpIngredientsInfo = "RCP_PARTS_DTLS" //재료정보
        case repWay = "RCP_WAY2" // 조리방법
        case repType = "RCP_PAT2" //요리종류
        case repSEQ = "RCP_SEQ" // 일련번호
        
        case rcpMainImageURL = "ATT_FILE_NO_MK" //이미지경로(대)
        case aTT_FILE_NO_MAIN = "ATT_FILE_NO_MAIN" //이미지경로(소)
        
        
        case iNFO_NA = "INFO_NA" // 나트륨
        case iNFO_WGT = "INFO_WGT" // 중량(1인분)
        case iNFO_PRO = "INFO_PRO" //단백질
        case iNFO_FAT = "INFO_FAT" //지방
        case hASH_TAG = "HASH_TAG" //해쉬태그
        case mANUAL_IMG02 = "MANUAL_IMG02" //만드는법_이미지_02
        case mANUAL_IMG03 = "MANUAL_IMG03" //만드는법_이미지_03
        case mANUAL_IMG13 = "MANUAL_IMG13"
        case mANUAL_IMG14 = "MANUAL_IMG14"
        case mANUAL_IMG15 = "MANUAL_IMG15"
        case mANUAL_IMG16 = "MANUAL_IMG16"
        case mANUAL_IMG10 = "MANUAL_IMG10"
        case mANUAL_IMG11 = "MANUAL_IMG11"
        case mANUAL_IMG12 = "MANUAL_IMG12"
        case mANUAL_IMG17 = "MANUAL_IMG17"
        case mANUAL_IMG18 = "MANUAL_IMG18"
        case mANUAL_IMG19 = "MANUAL_IMG19"
        case mANUAL_IMG04 = "MANUAL_IMG04"
        case mANUAL_IMG05 = "MANUAL_IMG05"
        case mANUAL_IMG01 = "MANUAL_IMG01"
        case mANUAL01 = "MANUAL01"
        case mANUAL_IMG06 = "MANUAL_IMG06"
        case mANUAL_IMG07 = "MANUAL_IMG07"
        case mANUAL_IMG08 = "MANUAL_IMG08"
        case mANUAL_IMG09 = "MANUAL_IMG09"
        case mANUAL08 = "MANUAL08"
        case mANUAL09 = "MANUAL09"
        case mANUAL06 = "MANUAL06"
        case mANUAL07 = "MANUAL07"
        case mANUAL04 = "MANUAL04"
        case mANUAL05 = "MANUAL05"
        case mANUAL02 = "MANUAL02"
        case mANUAL03 = "MANUAL03"
        case mANUAL11 = "MANUAL11"
        case mANUAL12 = "MANUAL12"
        case mANUAL10 = "MANUAL10"
        case iNFO_CAR = "INFO_CAR" //탄수화물
        case mANUAL19 = "MANUAL19"
        case rCP_NA_TIP = "RCP_NA_TIP" //저감 조리법 TIP
        case iNFO_ENG = "INFO_ENG" //열량
        case mANUAL17 = "MANUAL17"
        case mANUAL18 = "MANUAL18"
        case mANUAL15 = "MANUAL15"
        case mANUAL16 = "MANUAL16"
        case mANUAL13 = "MANUAL13"
        case mANUAL14 = "MANUAL14"
        case mANUAL_IMG20 = "MANUAL_IMG20" //만드는법_이미지_20
        case mANUAL20 = "MANUAL20" //만드는법_20
    }

}
*/
