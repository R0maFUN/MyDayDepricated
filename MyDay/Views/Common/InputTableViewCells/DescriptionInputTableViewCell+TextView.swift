//
//  DescriptionInputTableViewCell+TextView.swift
//  MyDay
//
//  Created by Рома Балаян on 30.07.2023.
//

import Foundation
import UIKit

extension DescriptionInputTableViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.value!.isPlaceholderVisible() {
            self.value!.setText("")
            textView.textColor = .label
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        if text.isEmpty {
            textView.textColor = .lightGray
            self.value!.setText(DescriptionModel.placeholder)
        } else {
            self.value!.setText(text)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }

        if text.isEmpty {
            textView.textColor = .lightGray
            self.value!.setText(DescriptionModel.placeholder)
        } else {
            self.value!.setText(text)
        }
    }
    
}
