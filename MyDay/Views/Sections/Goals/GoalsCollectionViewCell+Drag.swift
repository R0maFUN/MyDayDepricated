//
//  GoalsCollectionViewCell+Drag.swift
//  MyDay
//
//  Created by Рома Балаян on 19.08.2023.
//

import Foundation
import UIKit
import MobileCoreServices

extension GoalsCollectionViewCell: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.section >= self.sections.count {
            return []
        }
        
        guard let viewModel = self.sections[indexPath.section] as? GoalsItemViewModel else { return [] }
        
        let uuid = viewModel.id
        let data = uuid.data(using: .utf8)
        
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .ownProcess) { completion in
            completion(data, nil)
            return nil
        }
        
        HapticsManager.shared.selectionVibrate()
        
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
    
    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
        self.onDragBeginHandlers.forEach { $0() }
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        self.onDragEndHandlers.forEach { $0() }
    }
}
