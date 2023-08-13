//
//  ModernNotesItemTableViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 12.08.2023.
//

import Foundation
import UIKit

class ModernNotesItemTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ModernNotesItemTableViewCell"
    
    public func configure(with viewModel: NotesItemViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.descriptions.first?.text.isEmpty ?? true ? "No Description" : viewModel.descriptions.first?.text
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let horizontalInset: CGFloat = 24
        static let verticalInset: CGFloat = 18//12
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
        label.numberOfLines = 2
        return label
    }()
    
    private let tagView: TagView = {
        let tag = TagView()
        tag.text = "Optional"
        return tag
    }()
}

private extension ModernNotesItemTableViewCell {
    func initialize() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(tagView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.horizontalInset)
            make.top.equalToSuperview().inset(UIConstants.verticalInset)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.horizontalInset)
            make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.verticalInset)
        }
        
        tagView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.horizontalInset)
            make.top.equalToSuperview().inset(UIConstants.verticalInset)
        }
    }
}
