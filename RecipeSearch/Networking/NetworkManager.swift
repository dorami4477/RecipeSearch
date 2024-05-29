//
//  NetworkManager.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/23/24.
//

import Foundation

//MARK: - 네트워크에서 발생할 수 있는 에러 정의

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

//MARK: - Networking (서버와 통신하는) 클래스 모델

final class NetworkManager {
    
    // 여러화면에서 통신을 한다면, 일반적으로 싱글톤으로 만듦
    static let shared = NetworkManager()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    //https://openapi.foodsafetykorea.go.kr/api/0354f80ae0364303900a/COOKRCP01/json/1/5/RCP_NM=누룽지
    //let musicURL = "http://openapi.foodsafetykorea.go.kr/api/keyId/serviceId/dataType/startIdx/endIdx"
    
    typealias NetworkCompletion = (Result<[Recipes], NetworkError>) -> Void

    // 네트워킹 요청하는 함수
    func fetchRecipe(searchTerm: String?, completion: @escaping NetworkCompletion) {
        var urlString = "\(RecipeApi.requestUrl)/\(RecipeApi.keyID)/\(RecipeApi.serviceName)/1/10"
        if searchTerm != nil && searchTerm != ""{
            urlString = urlString + searchTerm!
        }
        print(urlString)
        
        performRequest(with: urlString) { result in
            completion(result)
        }
        
    }
    
    // 실제 Request하는 함수 (비동기적 실행 ===> 클로저 방식으로 끝난 시점을 전달 받도록 설계)
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        //print(#function)
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 메서드 실행해서, 결과를 받음
            if let data = self.parseJSON(safeData) {
                print("Parse 실행")
                let recipeData = self.apiToRecipeModel(data: data)
                completion(.success(recipeData))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 받아본 데이터 분석하는 함수 (동기적 실행)
    private func parseJSON(_ recipeData: Data) -> [[String: String]]? {
    
        // 성공
        do {
            let cookRecipe = try JSONDecoder().decode(apiData.self, from: recipeData)
            return cookRecipe.cookRecipes.info
        // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    func apiToRecipeModel(data:[[String: String]]) -> [Recipes]{
        
        var recipes:[Recipes] = []
        
        data.forEach { data in
            let recipeID = Int(data["RCP_SEQ"]!)!
            let recipeName = data["RCP_NM"]!
            let recipeWay = data["RCP_WAY2"]!
            let recipeType = data["RCP_PAT2"]!
            let ingredient = data["RCP_PARTS_DTLS"]!
            let recipeCal = data["INFO_ENG"]!
            let infoCar = data["INFO_CAR"]!
            let infoPro = data["INFO_PRO"]!
            let infoFat = data["INFO_FAT"]!
            let infoNa = data["INFO_NA"]!
            let imageUrl = data["ATT_FILE_NO_MAIN"]!
            
            var manualSet:[String]{
                var manualArray:[String] = []
                for num in 1...20{
                    let str = String(format: "%02d", num)
                    if let manual = data["MANUAL\(str)"], manual != ""{
                        manualArray.append(manual)
                    }
                }
                return manualArray
            }
            var manualImgSet:[String]{
                var manualArray:[String] = []
                for num in 1...20{
                    let str = String(format: "%02d", num)
                    if let manual = data["MANUAL_IMG\(str)"], manual != ""{
                        manualArray.append(manual)
                    }
                }
                return manualArray
            }

            let recipe = Recipes(recipeID: recipeID, recipeName: recipeName, recipeWay: recipeWay, recipeType: recipeType, ingredient:ingredient, recipeCal: recipeCal, infoCar: infoCar, infoPro: infoPro, infoFat: infoFat, infoNa: infoNa, imageUrl: imageUrl, manualSet: manualSet, manualImgSet: manualImgSet)
            
            recipes.append(recipe)
            
        }
        return recipes
    }
    
    
    
}

