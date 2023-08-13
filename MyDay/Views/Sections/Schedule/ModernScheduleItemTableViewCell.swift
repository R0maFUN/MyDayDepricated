//
//  ModernScheduleItemTableViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 12.08.2023.
//

import Foundation
import UIKit

class ModernScheduleItemTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ModernScheduleItemTableViewCell"
    
    public func configure(with viewModel: ScheduleItemViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        timeStartLabel.text = dateFormatter.string(from: viewModel.startDate)
        if viewModel.endDate > viewModel.startDate {
            timeEndLabel.text = dateFormatter.string(from: viewModel.endDate)
        }
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
        static let horizontalInset: CGFloat = 24
        static let verticalInset: CGFloat = 12
        static let titleToTagOffset: CGFloat = 8
        
    }
    
    // MARK: - Private Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let timeStartLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let timeEndLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let tagView: TagView = {
        let tag = TagView()
        tag.text = "Optional"
        return tag
    }()
}

private extension ModernScheduleItemTableViewCell {
    func initialize() {
        contentView.addSubview(tagView)
        contentView.addSubview(timeEndLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(timeStartLabel)
        contentView.addSubview(timeEndLabel)
        
        tagView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.horizontalInset)
            make.top.equalToSuperview().inset(UIConstants.verticalInset)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.horizontalInset)
            make.top.equalTo(tagView.snp.bottom).offset(UIConstants.titleToTagOffset)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.horizontalInset)
            make.bottom.equalToSuperview().inset(UIConstants.verticalInset)
        }
        
        timeStartLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.horizontalInset)
            make.top.equalTo(tagView.snp.bottom).offset(UIConstants.titleToTagOffset)
        }
        
        timeEndLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.horizontalInset)
            make.bottom.equalToSuperview().inset(UIConstants.verticalInset)
        }
    }
}
