//
//  NoteCollectionViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 17.07.2023.
//

import UIKit

struct NotesSection {
    let title: String
    let items: [SectionItemViewModel]
}

class NotesItemTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NotesItemTableViewCell"
    
    public func configure(with viewModel: NotesItemViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.descriptions.first?.text ?? "No description"
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

private extension NotesItemTableViewCell {
    func initialize() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.horizontalInset)
            make.top.equalToSuperview().inset(UIConstants.verticalInset)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.horizontalInset)
            make.bottom.equalToSuperview().inset(UIConstants.verticalInset)
        }
    }
}

class NoteCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "NoteCollectionViewCell"
    
    public func configure(with sectionsManager: NotesSectionsManager) {
        self.sectionsManager = sectionsManager
        
        if let notesSectionViewModel = self.sectionsManager?.currentSection.value as? NotesSectionViewModel {
            notesSectionViewModel.onItemsChanged {
                self.updateSections()
            }
        }
        
        self.sectionsManager?.currentSection.onChanged {
            self.updateSections()
        }
        
        updateSections()
    }
    
    public func onEditNoteRequested(_ handler: @escaping (_: NotesItemViewModel) -> Void) {
        self.onEditNoteRequestedHandlers.append(handler)
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
    private var sectionsManager: NotesSectionsManager?
    private var sections: [NotesSection] = []
    
    private var onEditNoteRequestedHandlers: [(_: NotesItemViewModel) -> Void] = []
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(NotesItemTableViewCell.self, forCellReuseIdentifier: NotesItemTableViewCell.reuseIdentifier)
        return table
    }()
}

private extension NoteCollectionViewCell {
    func initialize() {
        updateSections()
        
        setupTableView()
    }
    
    func updateSections() {
        guard let notesSectionViewModel = self.sectionsManager?.currentSection.value as? NotesSectionViewModel else { return }
        self.sections = []
        if notesSectionViewModel.items.count > 0 {
            self.sections.append(NotesSection(title: "", items: notesSectionViewModel.items))
        }
        
        self.tableView.reloadData()
    }
}

// MARK: - Setup TableView
private extension NoteCollectionViewCell {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension NoteCollectionViewCell: UITableViewDataSource {
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
        guard let viewModel = self.sections[indexPath.section].items[indexPath.row] as? NotesItemViewModel else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesItemTableViewCell.reuseIdentifier, for: indexPath) as? NotesItemTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel)
        cell.backgroundColor = .tertiarySystemBackground
        return cell
    }
}

extension NoteCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewModel = self.sections[indexPath.section].items[indexPath.row] as? NotesItemViewModel else { return }
        
        self.onEditNoteRequestedHandlers.forEach { handler in
            handler(viewModel)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.rowHeight
    }
    
}
