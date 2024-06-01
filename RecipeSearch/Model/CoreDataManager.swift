//
//  CoreDataManager.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/31/24.
//

import UIKit
import CoreData

//MARK: - To do 관리하는 매니저 (코어데이터 관리)

final class CoreDataManager {
    
    // 싱글톤으로 만들기
    static let shared = CoreDataManager()
    private init() {}
    
    var index:Int = UserDefaults.standard.integer(forKey: "recipeIndex")
    // 앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    // 엔터티 이름 (코어데이터에 저장된 객체)
    let modelName: String = "Recipe"
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getToDoListFromCoreData() -> [Recipe] {
        var recipes: [Recipe] = []
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 정렬순서를 정해서 요청서에 넘겨주기
            let dateOrder = NSSortDescriptor(key: "recipeIndex", ascending: true)
            request.sortDescriptors = [dateOrder]
            
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedToDoList = try context.fetch(request) as? [Recipe] {
                    recipes = fetchedToDoList
                }
            } catch {
                print("가져오는 것 실패")
            }
        }
        
        return recipes
    }
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveToDoData(pickRecipeData:Recipes, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                // 임시저장소에 올라가게 할 객체만들기 (NSManagedObject ===> ToDoData)
                if let toDoData = NSManagedObject(entity: entity, insertInto: context) as? Recipe {
                    
                    // MARK: - ToDoData에 실제 데이터 할당 ⭐️
                    toDoData.recipeIndex = Int16(index)
                    toDoData.recipeID = Int64(pickRecipeData.recipeID)
                    toDoData.recipeName = pickRecipeData.recipeName
                    toDoData.recipeWay = pickRecipeData.recipeWay
                    toDoData.recipeType = pickRecipeData.recipeType
                    toDoData.ingredient = pickRecipeData.ingredient
                    toDoData.recipeCal = pickRecipeData.recipeCal
                    toDoData.infoCar = pickRecipeData.infoCar
                    toDoData.infoPro = pickRecipeData.infoPro
                    toDoData.infoFat = pickRecipeData.infoFat
                    toDoData.infoNa = pickRecipeData.infoNa
                    toDoData.imageUrl = pickRecipeData.imageUrl
                    toDoData.manualSet = pickRecipeData.manualSet
                    toDoData.manualImgSet = pickRecipeData.manualImgSet
                    
                   
                    index += 1
                    UserDefaults.standard.setValue(index, forKey: "recipeIndex")
                    //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }
    
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteRcipe(data: Recipe, completion: @escaping () -> Void) {

        
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "recipeID == %d", data.recipeID)
            
            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedToDoList = try context.fetch(request) as? [Recipe] {
                    
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetToDo = fetchedToDoList.first {
                        context.delete(targetToDo)
                        
                        //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
    
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateToDo(updatedCell: [MyRecipeCell], completion: @escaping () -> Void) {

            // 임시저장소 있는지 확인
            if let context = context {
                updatedCell.forEach { cell in
                    guard let recipeID = cell.recipeID else {
                        completion()
                        return
                    }
                    // 요청서
                    let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
                    // 단서 / 찾기 위한 조건 설정
                    request.predicate = NSPredicate(format: "recipeID = %d", recipeID)
                    
                    do {
                        // 요청서를 통해서 데이터 가져오기
                        if let fetchedToDoList = try context.fetch(request) as? [Recipe] {
                            // 배열의 첫번째
                            if var targetToDo = fetchedToDoList.first {
                                // MARK: - ToDoData에 실제 데이터 재할당(바꾸기) ⭐️
                                targetToDo.recipeIndex = cell.index
                                
                            }
                        }
                        completion()
                    } catch {
                        print("지우는 것 실패")
                        completion()
                    }//: doCatch
                }//: forEach

                    do {
                        try context.save()
                        completion()
                    } catch {
                        print(error)
                        completion()
                    }
            }

    }//:updataFunc
}

