//
//  ScheduleCollectionViewCell+Drag.swift
//  MyDay
//
//  Created by Рома Балаян on 03.08.2023.
//

import Foundation
import UIKit
import MobileCoreServices

extension ScheduleCollectionViewCell: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let viewModel = self.sections[indexPath.section].items[indexPath.row] as? ScheduleItemViewModel else { return [] }
        
        let uuid = viewModel.id
        let data = uuid.data(using: .utf8)
        
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .ownProcess) { completion in
            completion(data, nil)
            return nil
        }
        
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
