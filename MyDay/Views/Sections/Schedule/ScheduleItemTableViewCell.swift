//
//  ScheduleItemTableViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 12.08.2023.
//

import Foundation
import UIKit

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
