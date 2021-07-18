//
//  UISearchBarExtension.swift
//  TheFepiTest
//
//  Created by stefano.salim on 18/07/21.
//

import UIKit

extension UISearchBar {
    func getTextField() -> UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
    
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        
        switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
                
            @unknown default: break
        }
    }
}
