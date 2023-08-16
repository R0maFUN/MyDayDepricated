//
//  GoalsCollectionViewCell+Table.swift
//  MyDay
//
//  Created by Рома Балаян on 15.08.2023.
//

import Foundation
import UIKit

extension GoalsCollectionViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let section = self.sections[indexPath.section]
        
//        if indexPath.row >= self.sections[indexPath.section].items.count && section.type == .ButtonPlaceholder {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonPlaceholderTableViewCell.reuseIdentifier, for: indexPath) as? ButtonPlaceholderTableViewCell else { return UITableViewCell() }
//            cell.text = "Add Note"
//
//            return cell
//        }
        
        let viewModel = self.sections[indexPath.section]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ModernGoalsItemCounterTableViewCell.reuseIdentifier, for: indexPath) as? ModernGoalsItemCounterTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel)
        cell.backgroundColor = .tertiarySystemBackground
        return cell
    }
}

extension GoalsCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.impactVibrate(for: .soft)
        
//        if self.sections[indexPath.section].type == .ButtonPlaceholder {
//            self.onAddNoteRequestedHandlers.forEach { $0() }
//            return
//        }
        
        let viewModel = self.sections[indexPath.section]
        
        self.onEditGoalRequestedHandlers.forEach { handler in
            handler(viewModel)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.sections[indexPath.section]
        
        return 140
    }
}
