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

class ScheduleItemTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleItemTableViewCell"
    
    public func configure(with viewModel: ScheduleItemViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        timeLabel.text = convertToString(viewModel.startDate, viewModel.endDate)
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func convertToString(_ start: Date, _ end: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        // 17
        return "\(dateFormatter.string(from: start)) - \(dateFormatter.string(from: end))"
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let horizontalInset: CGFloat = 20
        static let verticalInset: CGFloat = 8
    }
    
    // MARK: - Private Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
}

private extension ScheduleItemTableViewCell {
    func initialize() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(timeLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.horizontalInset)
            make.top.equalToSuperview().inset(UIConstants.verticalInset)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.horizontalInset)
            make.bottom.equalToSuperview().inset(UIConstants.verticalInset)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.horizontalInset)
            make.bottom.equalToSuperview().inset(UIConstants.verticalInset)
        }
    }
}

class ScheduleCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ScheduleCollectionViewCell"
    
    public func configure(with viewModel: ScheduleSectionsManager) {
        self.viewModel = viewModel
        
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
    }
    
    // MARK: - Private Properties
    private var viewModel: ScheduleSectionsManager?
    internal private(set) var sections: [ScheduleSection] = []
    
    internal private(set) var onDragBeginHandlers: [() -> Void] = []
    internal private(set) var onDragEndHandlers: [() -> Void] = []
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(ScheduleItemTableViewCell.self, forCellReuseIdentifier: ScheduleItemTableViewCell.reuseIdentifier)
        return table
    }()
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
        if scheduleSectionViewModel.items.count > 0 {
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleItemTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleItemTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel)
        cell.backgroundColor = .tertiarySystemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("pizdec")
    }
}

extension ScheduleCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.rowHeight
    }
    
}
