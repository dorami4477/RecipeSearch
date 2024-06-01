//
//  MyRecipesViewController.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/28/24.
//

import UIKit

class MyRecipesViewController: UIViewController {
    

    @IBOutlet var myRcipeTableView: UITableView!
    let coreManager = CoreDataManager.shared
    var myPicks:[Recipe] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipes"
        myRcipeTableView.delegate = self
        myRcipeTableView.dataSource = self
        myRcipeTableView.rowHeight = 120
        myPicks = coreManager.getToDoListFromCoreData()
        let edit = UIBarButtonItem(title: "edit", style: .plain, target:self, action: #selector(editButtonClicked))
        navigationItem.rightBarButtonItem = edit
    }

    override func viewWillAppear(_ animated: Bool) {
        myPicks = coreManager.getToDoListFromCoreData()
        myRcipeTableView.reloadData()
        print(myPicks.count)
    }
    
    //edit barButton 액션
    @objc func editButtonClicked(){
        if navigationItem.rightBarButtonItem?.title == "edit"{
            myRcipeTableView.isEditing = true
            navigationItem.rightBarButtonItem?.title = "done"
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
        }else{
            myRcipeTableView.isEditing = false
            navigationItem.rightBarButtonItem?.title = "edit"
            self.navigationItem.rightBarButtonItem?.tintColor = .blue
        }
    }
    
}

// MARK: - tableView
extension MyRecipesViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPicks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myRcipeTableView.dequeueReusableCell(withIdentifier: MyRecipeCell.identifier, for: indexPath) as! MyRecipeCell
        cell.configureData(myPicks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let removed = myPicks.remove(at: sourceIndexPath.row)
        myPicks.insert(removed, at: destinationIndexPath.row)
        
        /**인덱스 순서 변경을 해줘야함...!**/
        
        print("startN :\(sourceIndexPath)")
        print("destiN :\(destinationIndexPath)")
        var needToChangeIndex:[Int16] = []
        var updateCell:[MyRecipeCell] = []
        
        let start = tableView.cellForRow(at: [0, sourceIndexPath.row]) as! MyRecipeCell
        let desti = tableView.cellForRow(at: [0, destinationIndexPath.row]) as! MyRecipeCell
        
        if sourceIndexPath.row < destinationIndexPath.row{
            for i in sourceIndexPath.row...destinationIndexPath.row{
                let cell = tableView.cellForRow(at: [0, i]) as! MyRecipeCell
                needToChangeIndex.append(cell.index)
            }
            
            start.index = desti.index
            desti.index = desti.index - 1
            updateCell.append(contentsOf: [start, desti])
            
            if needToChangeIndex.count > 2{
                for i in 1...needToChangeIndex.count - 2{
                    let center = tableView.cellForRow(at: [0, destinationIndexPath.row - i]) as! MyRecipeCell
                    center.index = Int16(center.index - 1)
                    updateCell.append(center)
                }
            }
            
            coreManager.updateToDo(updatedCell: updateCell) {
                print("순서바꾸기")
            }
            
        }else{
                for i in destinationIndexPath.row...sourceIndexPath.row{
                    let cell = tableView.cellForRow(at: [0, i]) as! MyRecipeCell
                    needToChangeIndex.append(cell.index)
                }
            start.index = desti.index
            desti.index = desti.index + 1
            updateCell.append(contentsOf: [start, desti])
            
            if needToChangeIndex.count > 2{
                for i in 1...needToChangeIndex.count - 2{
                    let center = tableView.cellForRow(at: [0, destinationIndexPath.row + i]) as! MyRecipeCell
                    center.index = center.index + 1
                    print("중간값 :\(destinationIndexPath.row + i)=>\(center.index)")
                    updateCell.append(center)
                }
            }
            
            coreManager.updateToDo(updatedCell: updateCell) {
                print("순서바꾸기")
            }
        }
       
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in

            
            let alert = UIAlertController(title: "정말로 삭제 하시겠습니까?", message: nil, preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "삭제", style: .destructive){ _ in
                let removed = self.myPicks.remove(at: indexPath.row)
                self.coreManager.deleteRcipe(data: removed) {
                    print("삭제완료")
                }
                tableView.isEditing = false
                self.navigationItem.rightBarButtonItem?.title = "edit"
                self.navigationItem.rightBarButtonItem?.tintColor = .blue
                tableView.deleteRows(at: [indexPath], with: .fade)
                success(true)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel){ _ in
                tableView.isEditing = false
                self.navigationItem.rightBarButtonItem?.title = "edit"
                self.navigationItem.rightBarButtonItem?.tintColor = .blue
            }
            
            alert.addAction(cancel)
            alert.addAction(delete)
            
            self.present(alert, animated: true)

        }
        
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")

        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        tableView.isEditing = false
        self.navigationItem.rightBarButtonItem?.title = "done"
        self.navigationItem.rightBarButtonItem?.tintColor = .gray
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableView.isEditing = false
        self.navigationItem.rightBarButtonItem?.title = "edit"
        self.navigationItem.rightBarButtonItem?.tintColor = .blue
    }
}
