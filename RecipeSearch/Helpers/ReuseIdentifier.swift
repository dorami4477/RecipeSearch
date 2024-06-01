//
//  ReuseIdentifier.swift
//  RecipeSearch
//
//  Created by 박다현 on 5/31/24.
//

import UIKit

protocol ReuseIdentifierProtocol{
    static var identifier:String { get }
}


extension UITableViewCell:ReuseIdentifierProtocol{
    static var identifier:String{
        return String(describing: self)
    }
}

extension UICollectionViewCell:ReuseIdentifierProtocol{
    static var identifier:String{
        return String(describing: self)
    }
}

extension UIViewController:ReuseIdentifierProtocol{
    static var identifier:String{
        return String(describing: self)
    }
}
