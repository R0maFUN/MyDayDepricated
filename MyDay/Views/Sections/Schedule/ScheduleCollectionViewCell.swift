//
//  ScheduleView.swift
//  MyDay
//
//  Created by Рома Балаян on 13.07.2023.
//

import UIKit

struct ScheduleSection {
    let title: String
    let items: [SectionItemViewModel]
}

class ScheduleCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ScheduleCollectionViewCell"
    
    public func configure(with viewModel: ScheduleSectionsManager) {
        self.viewModel = viewModel
        
        // can be called million times
        if let scheduleSectionViewModel = self.viewModel?.currentSection.value as? ScheduleSectionViewModel {
            scheduleSectionViewModel.onItemsChanged {
                self.updateSections()
            }
        }
        
        self.viewModel?.onDataChanged {
            self.updateSections()
        }
        
        updateSections()
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
    }
    
    // MARK: - Private Properties
    private var viewModel: ScheduleSectionsManager?
    internal private(set) var sections: [ScheduleSection] = []
    
    internal private(set) var onDragBeginHandlers: [() -> Void] = []
    internal private(set) var onDragEndHandlers: [() -> Void] = []
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(ScheduleItemTableViewCell.self, forCellReuseIdentifier: ScheduleItemTableViewCell.reuseIdentifier)
        table.register(ModernScheduleItemTableViewCell.self, forCellReuseIdentifier: ModernScheduleItemTableViewCell.reuseIdentifier)
        return table
    }()
    
    public var isModern: Bool = true {
        didSet {
            self.updateSections()
        }
    }
}

private extension ScheduleCollectionViewCell {
    func initialize() {
        //self.backgroundColor
        
        updateSections()
        
        setupTableView()
    }
    
    func updateSections() {
        guard let scheduleSectionViewModel = self.viewModel?.currentSection.value as? ScheduleSectionViewModel else { return }
        self.sections = []
        
        if isModern && scheduleSectionViewModel.items.count > 0 {
         
            scheduleSectionViewModel.items.forEach { item in
                self.sections.append(ScheduleSection(title: "", items: [item]))
            }
            
//            self.sections.sort(by: { first, second in
//                guard let leftItem = first.items.first as? ScheduleItemViewModel else { return true }
//                guard let rightItem = second.items.first as? ScheduleItemViewModel else { return true }
//                return leftItem.startDate > rightItem.startDate
//            })
            
        } else if scheduleSectionViewModel.items.count > 0 {
            self.sections.append(ScheduleSection(title: "", items: scheduleSectionViewModel.items))
            
            if scheduleSectionViewModel.inProgressItems.count > 0 {
                self.sections.append(ScheduleSection(title: "In Progress", items: scheduleSectionViewModel.inProgressItems))
            }
            
            if scheduleSectionViewModel.nextItems.count > 0 {
                self.sections.append(ScheduleSection(title: "Next Task", items: scheduleSectionViewModel.nextItems))
            }
        }
        
        self.tableView.reloadData()
    }
}

// MARK: - Setup TableView
private extension ScheduleCollectionViewCell {
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

extension ScheduleCollectionViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.sections[indexPath.section].items[indexPath.row] as? ScheduleItemViewModel else { return UITableViewCell() }
        
        if self.isModern {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ModernScheduleItemTableViewCell.reuseIdentifier, for: indexPath) as? ModernScheduleItemTableViewCell else { return UITableViewCell() }
            cell.configure(with: viewModel)
            cell.backgroundColor = .tertiarySystemBackground
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleItemTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleItemTableViewCell else { return UITableViewCell() }
            cell.configure(with: viewModel)
            cell.backgroundColor = .tertiarySystemBackground
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        print("pizdec")
//    }
}

extension ScheduleCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.impactVibrate(for: .soft)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.isModern ? UIConstants.modernRowHeight : UIConstants.rowHeight
    }
    
}
