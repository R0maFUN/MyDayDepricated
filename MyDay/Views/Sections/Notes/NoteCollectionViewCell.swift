//
//  NoteCollectionViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 17.07.2023.
//

import UIKit
import MobileCoreServices

struct NotesSection {
    
    enum type_: Int {
        case Common = 0
        case QuickNote = 1
        case Timer = 2
        case ButtonPlaceholder = 3
    }
    
    let title: String
    let items: [SectionItemViewModel]
    let type: type_
}

class NoteCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "NoteCollectionViewCell"
    
    public func configure(with sectionsManager: NotesSectionsManager) {
        self.sectionsManager = sectionsManager
        
        self.sectionsManager?.onDataChanged {
            self.updateSections()
        }
        
        updateSections()
    }
    
    public func onEditNoteRequested(_ handler: @escaping (_: NotesItemViewModel) -> Void) {
        self.onEditNoteRequestedHandlers.append(handler)
    }
    
    public func onQuickNoteRequested(_ handler: @escaping (_: NotesItemViewModel?) -> Void) {
        self.onQuickNoteRequestedHandlers.append(handler)
    }
    
    public func onAddNoteRequested(_ handler: @escaping () -> Void) {
        self.onAddNoteRequestedHandlers.append(handler)
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
    private var sectionsManager: NotesSectionsManager?
    public private(set) var sections: [NotesSection] = []
    
    public var isModern: Bool = true {
        didSet {
            updateSections()
        }
    }
    
    private var onEditNoteRequestedHandlers: [(_: NotesItemViewModel) -> Void] = []
    private var onQuickNoteRequestedHandlers: [(_: NotesItemViewModel?) -> Void] = []
    private var onAddNoteRequestedHandlers: [() -> Void] = []
    internal private(set) var onDragBeginHandlers: [() -> Void] = []
    internal private(set) var onDragEndHandlers: [() -> Void] = []
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(NotesItemTableViewCell.self, forCellReuseIdentifier: NotesItemTableViewCell.reuseIdentifier)
        table.register(ModernNotesItemTableViewCell.self, forCellReuseIdentifier: ModernNotesItemTableViewCell.reuseIdentifier)
        table.register(QuickNoteTableViewCell.self, forCellReuseIdentifier: QuickNoteTableViewCell.reuseIdentifier)
        table.register(ButtonPlaceholderTableViewCell.self, forCellReuseIdentifier: ButtonPlaceholderTableViewCell.reuseIdentifier)
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
        
        if self.isModern {
            notesSectionViewModel.items.forEach { item in
                if let item = item as? NotesItemViewModel {
                    self.sections.append(NotesSection(title: "", items: [item], type: item.type))
                }
            }
        }
        else if notesSectionViewModel.items.count > 0 {
            self.sections.append(NotesSection(title: "", items: notesSectionViewModel.items, type: .Common))
        }
        
        if self.sections.isEmpty {
            self.sections.append(NotesSection(title: "", items: [], type: .ButtonPlaceholder))
        }
        
        self.sections.append(NotesSection(title: "", items: [], type: .QuickNote))
        
        self.tableView.reloadData()
    }
}

// MARK: - Setup TableView
private extension NoteCollectionViewCell {
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

extension NoteCollectionViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isModern ? 1 : self.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        
        if indexPath.row >= self.sections[indexPath.section].items.count && section.type == .QuickNote {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuickNoteTableViewCell.reuseIdentifier, for: indexPath) as? QuickNoteTableViewCell else { return UITableViewCell() }
            return cell
        } else if indexPath.row >= self.sections[indexPath.section].items.count && section.type == .ButtonPlaceholder {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonPlaceholderTableViewCell.reuseIdentifier, for: indexPath) as? ButtonPlaceholderTableViewCell else { return UITableViewCell() }
            cell.text = "Add Note"
            
            return cell
        }
        
        guard let viewModel = self.sections[indexPath.section].items[indexPath.row] as? NotesItemViewModel else { return UITableViewCell() }
        
        
        if self.isModern {
            if section.type == .QuickNote {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: QuickNoteTableViewCell.reuseIdentifier, for: indexPath) as? QuickNoteTableViewCell else { return UITableViewCell() }
                cell.configure(with: viewModel)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ModernNotesItemTableViewCell.reuseIdentifier, for: indexPath) as? ModernNotesItemTableViewCell else { return UITableViewCell() }
                cell.configure(with: viewModel)
                cell.backgroundColor = .tertiarySystemBackground
                return cell
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesItemTableViewCell.reuseIdentifier, for: indexPath) as? NotesItemTableViewCell else { return UITableViewCell() }
            cell.configure(with: viewModel)
            cell.backgroundColor = .tertiarySystemBackground
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        print("pizdec")
//    }
}

extension NoteCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.impactVibrate(for: .soft)
        
        if self.sections[indexPath.section].type == .QuickNote {
            self.onQuickNoteRequestedHandlers.forEach { handler in
                if indexPath.row >= self.sections[indexPath.section].items.count {
                    handler(nil)
                    return
                }
                
                let viewModel = self.sections[indexPath.section].items[indexPath.row] as? NotesItemViewModel
                handler(viewModel)
            }
            return
        } else if self.sections[indexPath.section].type == .ButtonPlaceholder {
            self.onAddNoteRequestedHandlers.forEach { $0() }
            return
        }
        
        guard let viewModel = self.sections[indexPath.section].items[indexPath.row] as? NotesItemViewModel else { return }
        
        self.onEditNoteRequestedHandlers.forEach { handler in
            handler(viewModel)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.sections[indexPath.section]
        
        if section.type == .QuickNote {
            return UIConstants.quickNoteHeight
        } else if section.type == .ButtonPlaceholder {
            return UIConstants.addNoteHeight
        }
        
        return self.isModern ? UIConstants.modernRowHeight : UIConstants.rowHeight
    }
}
