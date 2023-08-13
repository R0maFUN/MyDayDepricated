//
//  NoteCollectionView+Drag.swift
//  MyDay
//
//  Created by Рома Балаян on 29.07.2023.
//

import Foundation
import UIKit
import MobileCoreServices

extension NoteCollectionViewCell: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.row >= self.sections[indexPath.section].items.count {
            return []
        }
        
        guard let viewModel = self.sections[indexPath.section].items[indexPath.row] as? NotesItemViewModel else { return [] }
        
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
