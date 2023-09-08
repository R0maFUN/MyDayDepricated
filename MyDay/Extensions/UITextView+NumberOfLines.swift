//
//  UITextView+NumberOfLines.swift
//  MyDay
//
//  Created by Рома Балаян on 08.09.2023.
//

import UIKit

extension UITextView{

    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }

}
