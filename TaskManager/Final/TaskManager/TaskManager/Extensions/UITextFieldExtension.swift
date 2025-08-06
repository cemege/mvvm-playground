//
//  UITextFieldExtension.swift
//  TaskManager
//
//  Created by Cem Ege on 6.08.2025.
//

import UIKit

extension UITextField {
    func doneInputAccessory() {
        let toolbar = UIToolbar()
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        toolbar.items = [.flexibleSpace(), doneBarButton]
        toolbar.sizeToFit()
        
        inputAccessoryView = toolbar
    }
    
    @objc
    private func doneTapped() {
        endEditing(true)
    }
}
