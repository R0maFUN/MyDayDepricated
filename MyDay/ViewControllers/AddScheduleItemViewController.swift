//
//  AddScheduleItemViewController.swift
//  MyDay
//
//  Created by Рома Балаян on 21.07.2023.
//

import UIKit

enum AddScheduleItemSection {
    case title(viewModel: ScheduleItemViewModel)
    case date(viewModel: ScheduleItemViewModel)
    case startTime(viewModel: ScheduleItemViewModel)
    case endTime(viewModel: ScheduleItemViewModel)
    case notifications(viewModel: NotificationsViewModel)
}

class AddScheduleItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    init(_ notificationsViewModel: NotificationsViewModel, _ sectionsViewModel: SectionsViewModel) {
        self.notificationsViewModel = notificationsViewModel
        self.sectionsViewModel = sectionsViewModel
        self.itemViewModel = ScheduleItemViewModel()
        
        super.init(nibName: .none, bundle: .none)
        
        self.sections.append(.title(viewModel: self.itemViewModel))
        self.sections.append(.date(viewModel: self.itemViewModel))
        self.sections.append(.startTime(viewModel: self.itemViewModel))
        self.sections.append(.endTime(viewModel: self.itemViewModel))
        self.sections.append(.notifications(viewModel: self.notificationsViewModel))
        
        self.notificationsViewModel.isEnabled.onChanged {
            self.notificationsTurnedOn = self.notificationsViewModel.isEnabled.value!
//            UIView.animate(withDuration: 1, animations: {
//                self.tableView.reloadData()
//            })
            //let range = NSMakeRange(0, self.tableView.numberOfSections)
            //let sections = NSIndexSet(indexesIn: range)
            //self.tableView.insertSections(<#T##sections: IndexSet##IndexSet#>, with: <#T##UITableView.RowAnimation#>)
            //self.tableView.reloadSections(sections as IndexSet, with: .automatic)
            self.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(ScheduleItemTitleTableViewCell.self, forCellReuseIdentifier: ScheduleItemTitleTableViewCell.reuseIdentifier)
        table.register(ScheduleItemDateTableViewCell.self, forCellReuseIdentifier: ScheduleItemDateTableViewCell.reuseIdentifier)
        table.register(ScheduleItemStartTimeTableViewCell.self, forCellReuseIdentifier: ScheduleItemStartTimeTableViewCell.reuseIdentifier)
        table.register(ScheduleItemEndTimeTableViewCell.self, forCellReuseIdentifier: ScheduleItemEndTimeTableViewCell.reuseIdentifier)
        table.register(ScheduleItemNotificationsTableViewCell.self, forCellReuseIdentifier: ScheduleItemNotificationsTableViewCell.reuseIdentifier)
        table.register(ScheduleItemNotificationTableViewCell.self, forCellReuseIdentifier: ScheduleItemNotificationTableViewCell.reuseIdentifier)
        return table
    }()
    
    private let doneButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Done"
        let button = UIButton(configuration: config)
        return button
    }()

    private var sections: [AddScheduleItemSection] = []
    
    private var notificationsTurnedOn: Bool = false
    
    private var notificationsViewModel: NotificationsViewModel
    private var sectionsViewModel: SectionsViewModel
    private var itemViewModel: ScheduleItemViewModel
}

private extension AddScheduleItemViewController {
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
    
    @objc func onDoneButtonPressed() {
        // TODO: DATE is wrong
        guard let scheduleSectionManager = self.sectionsViewModel.currentSectionManager.value! as? ScheduleSectionsManager else { return }
        if let scheduleSection = scheduleSectionManager.getSection(by: DateModel(date: self.itemViewModel.date)) as? ScheduleSectionViewModel {
            scheduleSection.add(self.itemViewModel)
            dismiss(animated: true)
        } else {
            let scheduleSection = ScheduleSectionViewModel(date: DateModel(date: self.itemViewModel.date))
            scheduleSectionManager.add(section: scheduleSection)
            scheduleSection.add(self.itemViewModel)
            dismiss(animated: true)
        }
        //scheduleSectionManager.addScheduleItem(date: Date, title: <#T##String#>, startTime: <#T##Date#>, endTime: <#T##Date#>)
    }
}

extension AddScheduleItemViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count + notificationsViewModel.notificationsCount()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section >= self.sections.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleItemNotificationTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleItemNotificationTableViewCell else { return UITableViewCell() }
            let notification = notificationsViewModel.notifications[indexPath.section - self.sections.count]
            cell.configure(with: notification)
            return cell
        }
        
        let model = self.sections[indexPath.section]
        
        switch model.self {
        case .title(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleItemTitleTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleItemTitleTableViewCell else { return UITableViewCell() }
            cell.configure(with: model)
            return cell
        case .date(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleItemDateTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleItemDateTableViewCell else { return UITableViewCell() }
            cell.configure(with: viewModel)
            return cell
        case .startTime(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleItemStartTimeTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleItemStartTimeTableViewCell else { return UITableViewCell() }
            cell.configure(with: viewModel)
            return cell
        case .endTime(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleItemEndTimeTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleItemEndTimeTableViewCell else { return UITableViewCell() }
            cell.configure(with: viewModel)
            return cell
        case .notifications(_):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleItemNotificationsTableViewCell.reuseIdentifier, for: indexPath) as? ScheduleItemNotificationsTableViewCell else { return UITableViewCell() }
            cell.configure(with: self.notificationsViewModel)
            cell.onSwitched(handler: { value in
                if value {
                    self.notificationsViewModel.enable()
                } else {
                    self.notificationsViewModel.disable()
                }
            })
            return cell
        }
    }
    
}

extension AddScheduleItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 356
        } else if indexPath.section >= sections.count {
            return 40
        }
        
        return 68
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
