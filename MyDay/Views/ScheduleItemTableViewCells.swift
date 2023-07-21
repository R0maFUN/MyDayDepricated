//
//  ScheduleItemTableViewCells.swift
//  MyDay
//
//  Created by Рома Балаян on 21.07.2023.
//

import UIKit

class ScheduleItemTitleTableViewCell: UITableViewCell, UITextFieldDelegate {
    public static let reuseIdentifier = "ScheduleItemTitleTableViewCell"
    public private(set) var height: CGFloat = 68
    
    public func configure(with model: AddScheduleItemTitleModel) {
        self.textField.text = model.title
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    private func initialize() {
        textField.delegate = self
        
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        textField.placeholder = "Title"
        textField.tintColor = .label
        
        contentView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        //textField.becomeFirstResponder()
    }
    
    private var textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
}

class ScheduleItemDateTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleItemDateTableViewCell"
    public private(set) var height: CGFloat = 356
    
    public func configure(with model: AddScheduleItemDateModel) {
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        contentView.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        return picker
    }()
}

class ScheduleItemStartTimeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleItemStartTimeTableViewCell"
    public private(set) var height: CGFloat = 68
    
    public func configure(with model: AddScheduleItemStartTimeModel) {
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        contentView.addSubview(label)
        contentView.addSubview(timePicker)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        timePicker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Start at"
        return label
    }()
    
    private var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .time
        return picker
    }()
}

class ScheduleItemEndTimeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleItemEndTimeTableViewCell"
    public private(set) var height: CGFloat = 68
    
    public func configure(with model: AddScheduleItemEndTimeModel) {
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        contentView.addSubview(label)
        contentView.addSubview(timePicker)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        timePicker.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "End at"
        return label
    }()
    
    private var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .time
        return picker
    }()
}

class ScheduleItemNotificationsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleItemNotificationsTableViewCell"
    public private(set) var height: CGFloat = 68
    
    public func configure(with viewModel: NotificationsViewModel) {
        
    }
    
    public func onSwitched(handler: @escaping (Bool) -> Void) {
        self.switcherHandler = handler
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        contentView.addSubview(label)
        contentView.addSubview(switcher)
        
        self.switcher.addTarget(self, action: #selector(onSwitcherEvent), for: .allEvents)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        switcher.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc func onSwitcherEvent() {
        self.switcherHandler?(self.switcher.isOn)
    }
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Notifications"
        return label
    }()
    
    private var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .link
        return switcher
    }()
    
    private var switcherHandler: ((Bool) -> Void)?
}

class ScheduleItemNotificationTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleItemNotificationTableViewCell"
    
    public func configure(with viewModel: NotificationViewModel) {
        label.text = viewModel.title
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.opacity = 0.8
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
        }
    }
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bell.fill")
        return imageView
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "End at"
        return label
    }()
}
