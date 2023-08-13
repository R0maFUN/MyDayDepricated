//
//  DeleteAreaView+Drop.swift
//  MyDay
//
//  Created by Рома Балаян on 29.07.2023.
//

import Foundation
import UIKit

extension DeleteAreaView: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        HapticsManager.shared.impactVibrate(for: .soft, with: 1.5)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIConstants.activeBackgroundColor
        })
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIConstants.backgroundColor
        })
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSString.self) { items in
            let uuids = items as! [String]

            print("uuids droped = \(uuids)")
            
            HapticsManager.shared.vibrate(for: .error)
            
            self.onDeleteRequestedHandlers.forEach { $0(uuids) }
        }
    }
    
}
