//
//  EditNotesItemViewController.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import UIKit

struct EditNotesButton {
    enum _type {
        case text
        case image
    }
    
    public var handler: () -> Void
    public var type: _type
}

enum EditNotesItemSection {
    case title(viewModel: NotesItemViewModel)
    case description(viewModel: NotesItemViewModel, model: DescriptionModel)
    case image(viewModel: NotesItemViewModel)
    case buttons(buttons: [EditNotesButton])
}

class EditNotesItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let section = self.sectionsManager.getSection(by: DateModel(date: self.itemViewModel.date)) {
            section.update(self.itemViewModel)
            dismiss(animated: true)
        } else {
            let section = NotesSectionViewModel(date: DateModel(date: self.itemViewModel.date))
            self.sectionsManager.add(section: section)
            section.add(self.itemViewModel)
            dismiss(animated: true)
        }
    }
    
    init(_ sectionsManager: ISectionsManager, note: NotesItemViewModel? = nil) {
        self.sectionsManager = sectionsManager
        self.itemViewModel = note ?? NotesItemViewModel(title: "", editDate: Date(), date: sectionsManager.currentSection.value!.date.date)
        
        super.init(nibName: .none, bundle: .none)
        
        self.updateSections()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private Properties
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(TitleInputTableViewCell.self, forCellReuseIdentifier: TitleInputTableViewCell.reuseIdentifier)
        table.register(DescriptionInputTableViewCell.self, forCellReuseIdentifier: DescriptionInputTableViewCell.reuseIdentifier)
        table.register(NotesItemImageTableViewCell.self, forCellReuseIdentifier: NotesItemImageTableViewCell.reuseIdentifier)
        table.register(NotesItemButtonsTableViewCell.self, forCellReuseIdentifier: NotesItemButtonsTableViewCell.reuseIdentifier)
        
        table.keyboardDismissMode = .onDrag
        return table
    }()
    
    private let doneButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Done"
        let button = UIButton(configuration: config)
        return button
    }()

    private var sections: [EditNotesItemSection] = []
    
    private var sectionsManager: ISectionsManager
    private var itemViewModel: NotesItemViewModel
}

private extension EditNotesItemViewController {
    func initialize() {
        self.view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 50
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(onDoneButtonPressed), for: .touchUpInside)
        
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
    }
    
    func updateSections() {
        self.sections = []
        
        self.sections.append(.title(viewModel: self.itemViewModel))
        
        if self.itemViewModel.descriptions.count == 0 {
            self.itemViewModel.addEmptyDescription()
        }
        
        for description in self.itemViewModel.descriptions {
            self.sections.append(.description(viewModel: self.itemViewModel, model: description))
        }

        self.sections.append(.buttons(buttons: [EditNotesButton(handler: {
                                                                    print("Button 1")
                                                                    self.itemViewModel.addEmptyDescription()
                                                                    self.updateSections()
                                                                    self.tableView.reloadData()
                                                                },
                                                                type: .text),
                                                EditNotesButton(handler: { print("Button 2") }, type: .image)]))
    }
    
    @objc func onDoneButtonPressed() {
        // TODO: DATE is wrong
        if let section = self.sectionsManager.getSection(by: DateModel(date: self.itemViewModel.date)) {
            section.update(self.itemViewModel)
            dismiss(animated: true)
        } else {
            let section = NotesSectionViewModel(date: DateModel(date: self.itemViewModel.date))
            self.sectionsManager.add(section: section)
            section.add(self.itemViewModel)
            dismiss(animated: true)
        }
    }
}

extension EditNotesItemViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.sections[indexPath.section]
        
        switch model.self {
        case .title(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleInputTableViewCell.reuseIdentifier, for: indexPath) as? TitleInputTableViewCell else { return UITableViewCell() }
            cell.configure(with: model.title)
            
            cell.onValueChanged { value in
                model.setTitle(title: value)
            }
            
            return cell
        case .description(let viewModel, let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionInputTableViewCell.reuseIdentifier, for: indexPath) as? DescriptionInputTableViewCell else { return UITableViewCell() }
            cell.configure(with: model)
            
            cell.onValueChanged { value in
                viewModel.update(value)
            }
            
            return cell
        case .image(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesItemImageTableViewCell.reuseIdentifier, for: indexPath) as? NotesItemImageTableViewCell else { return UITableViewCell() }
            cell.configure(with: viewModel)
            return cell
        case .buttons(buttons: let buttons):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesItemButtonsTableViewCell.reuseIdentifier, for: indexPath) as? NotesItemButtonsTableViewCell else { return UITableViewCell() }
            cell.configure(with: buttons)
            return cell
        }
    }
    
}

extension EditNotesItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = self.sections[indexPath.section]
        
        switch model.self {
        case .title(_):
            return 68
        case .description(_, _):
            return 400 // SomeHow return based on text inside it
        case .image(_):
            return 160
        case .buttons(_):
            return 64
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
