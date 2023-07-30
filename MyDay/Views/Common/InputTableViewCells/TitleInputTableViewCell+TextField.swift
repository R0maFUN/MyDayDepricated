//
//  TitleInputTableViewCell+TextField.swift
//  MyDay
//
//  Created by Рома Балаян on 30.07.2023.
//

import Foundation
import UIKit

extension TitleInputTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            self.value = text
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        self.value = text
    }
    
}
