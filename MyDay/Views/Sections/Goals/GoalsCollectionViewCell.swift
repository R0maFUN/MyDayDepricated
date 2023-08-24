//
//  GoalsCollectionViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 15.08.2023.
//

import UIKit

class GoalsCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "GoalsCollectionViewCell"
    
    public func configure(with sectionsManager: GoalsSectionsManager) {
        self.sectionsManager = sectionsManager
        
        self.sectionsManager?.onDataChanged {
            self.updateSections()
        }
        
        updateSections()
    }
    
    public func onEditGoalRequested(_ handler: @escaping (_: GoalsItemViewModel) -> Void) {
        self.onEditGoalRequestedHandlers.append(handler)
    }
    
    public func onAddGoalRequested(_ handler: @escaping () -> Void) {
        self.onAddGoalRequestedHandlers.append(handler)
    }
    
    public func onDragBegin(_ handler: @escaping () -> Void) {
        self.onDragBeginHandlers.append(handler)
    }
    
    public func onDragEnd(_ handler: @escaping () -> Void) {
        self.onDragEndHandlers.append(handler)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let rowHeight: CGFloat = 54
        static let modernRowHeight: CGFloat = 112
        static let quickNoteHeight: CGFloat = 80
        static let addNoteHeight: CGFloat = 50
    }
    
    // MARK: - Private Properties
    private var sectionsManager: GoalsSectionsManager?
    public private(set) var sections: [GoalsItemViewModel] = []
    
    internal var onEditGoalRequestedHandlers: [(_: GoalsItemViewModel) -> Void] = []
    internal var onAddGoalRequestedHandlers: [() -> Void] = []
    internal private(set) var onDragBeginHandlers: [() -> Void] = []
    internal private(set) var onDragEndHandlers: [() -> Void] = []
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(ModernGoalsItemCounterTableViewCell.self, forCellReuseIdentifier: ModernGoalsItemCounterTableViewCell.reuseIdentifier)
//        table.register(ButtonPlaceholderTableViewCell.self, forCellReuseIdentifier: ButtonPlaceholderTableViewCell.reuseIdentifier)
        return table
    }()
}

private extension GoalsCollectionViewCell {
    func initialize() {
        updateSections()
        
        setupTableView()
    }
    
    func updateSections() {
        guard let goalsSectionViewModel = self.sectionsManager?.currentSection.value as? GoalsSectionViewModel else { return }
        
        self.sections = goalsSectionViewModel.items.compactMap { $0 as? GoalsItemViewModel }
        
//        if self.sections.isEmpty {
//            self.sections.append(NotesSection(title: "", items: [], type: .ButtonPlaceholder))
//        }
        
        self.tableView.reloadData()
    }
}

// MARK: - Setup TableView
private extension GoalsCollectionViewCell {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
