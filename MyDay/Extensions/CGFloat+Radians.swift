//
//  CGFloat+Radians.swift
//  MyDay
//
//  Created by Рома Балаян on 15.08.2023.
//

import Foundation

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(M_PI) / 180.0
    }
}
