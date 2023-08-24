//
//  ModernGoalsItemTableViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 15.08.2023.
//

import Foundation
import UIKit
import SnapKit

class ModernGoalsItemCounterTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ModernGoalsItemCounterTableViewCell"
    
    public func configure(with viewModel: GoalsItemViewModel) {
        descriptionLeftLabel.text = viewModel.descriptions.0
        descriptionRightLabel.text = viewModel.descriptions.1
        descriptionMiddleLabel.text = String(format: "%.0f", viewModel.goalValue)
        
        currentValueLabel.text = String(format: "%.0f", viewModel.currentValue)
        stepValueLabel.text = String(format: "%.0f", viewModel.stepValue)
        
        self.graph.goalValue = viewModel.goalValue
        self.graph.currentValue = viewModel.currentValue
        
//        viewModel.onCurrentValueChanged {
//            self.graph.currentValue = viewModel.currentValue
//            self.currentValueLabel.text = String(format: "%.0f", viewModel.currentValue)
//        }
        
        self.viewModel = viewModel
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
        descriptionLeftLabel.text = ""
        descriptionRightLabel.text = ""
        descriptionMiddleLabel.text = ""
        
        currentValueLabel.text = ""
        stepValueLabel.text = ""
        
        self.viewModel = nil
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let contentInset: CGFloat = 18
        static let horizontalInset: CGFloat = 24
        static let verticalInset: CGFloat = 18//12
        static let descriptionTextSize = 16.0
        static let counterButtonsImageSize = 18.0
    }
    
    public var descriptionLeftX: CGFloat {
        get {
            return descriptionLeftLabel.layer.position.x + descriptionStack.frame.minX
        }
    }
    
    public var descriptionMiddleX: CGFloat {
        get {
            return descriptionMiddleLabel.frame.minX
        }
    }
    
    public var descriptionRightX: CGFloat {
        get {
            return descriptionRightLabel.frame.minX
        }
    }
    
    public var stepValueX: CGFloat {
        get {
            return stepValueLabel.frame.minX
        }
    }
    
    // MARK: - Private Properties
    private var viewModel: GoalsItemViewModel?
    
    private let graph: SnakeGraphView = {
        let graph = SnakeGraphView()
        return graph
    }()
    
    private let descriptionLeftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.descriptionTextSize, weight: .semibold)
        //label.font = UIFont(name: "Bradley Hand", size: 18)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionMiddleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.descriptionTextSize, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionRightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.descriptionTextSize, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionStack = UIStackView()
    
    private let currentValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let decreaseButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .secondaryLabel
        button.tintColor = .white
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(UIConstants.counterButtonsImageSize)
        }
        return button
    }()
    
    private let stepValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let increaseButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .darkGray
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(UIConstants.counterButtonsImageSize)
        }
        return button
    }()
    
    private let tagView: TagView = {
        let tag = TagView()
        tag.text = "Optional"
        return tag
    }()
}

private extension ModernGoalsItemCounterTableViewCell {
    func initialize() {
        
        contentView.addSubview(graph)
        
        graph.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(18)
            make.width.equalTo(180)
        }
        
        descriptionStack.axis = .horizontal
        descriptionStack.spacing = 4
        
        descriptionStack.addArrangedSubview(descriptionLeftLabel)
        descriptionStack.addArrangedSubview(descriptionMiddleLabel)
        descriptionStack.addArrangedSubview(descriptionRightLabel)
        
        let counterStack = UIStackView()
        counterStack.axis = .horizontal
        counterStack.spacing = 12
        counterStack.distribution = .equalSpacing
        
        decreaseButton.layer.cornerRadius = 15
        decreaseButton.addTarget(self, action: #selector(decreaseButtonPressed), for: .touchUpInside)
        
        decreaseButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
        
        increaseButton.layer.cornerRadius = 15
        increaseButton.addTarget(self, action: #selector(increaseButtonPressed), for: .touchUpInside)
        
        increaseButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
        
        counterStack.addArrangedSubview(decreaseButton)
        counterStack.addArrangedSubview(stepValueLabel)
        counterStack.addArrangedSubview(increaseButton)
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.alignment = .lastBaseline
        
        contentStack.addArrangedSubview(descriptionStack)
        contentStack.addArrangedSubview(currentValueLabel)
        contentStack.addArrangedSubview(counterStack)
        
        contentView.addSubview(contentStack)
        
        contentStack.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.contentInset)
            make.leading.equalTo(graph.snp.trailing).offset(-70)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func decreaseButtonPressed() {
        viewModel?.decrease()
    }
    
    @objc func increaseButtonPressed() {
        viewModel?.increase()
    }
}
