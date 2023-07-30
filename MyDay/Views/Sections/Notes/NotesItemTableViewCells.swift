//
//  NotesItemTableViewCells.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation
import UIKit

class NotesItemDescriptionTableViewCell: UITableViewCell, UITextViewDelegate {
    static let reuseIdentifier = "NotesItemDescriptionTableViewCell"
    
    public func configure(with viewModel: NotesItemViewModel, model: NoteDescriptionModel) {
        self.itemViewModel = viewModel
        self.descriptionModel = model
        
        self.textView.text = model.text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        self.descriptionModel?.setText(text)
        self.itemViewModel?.update(self.descriptionModel!)
    }
    
    private func initialize() {
        textView.delegate = self
        
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.tintColor = .label
        textView.backgroundColor = .clear
        
        contentView.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    private var itemViewModel: NotesItemViewModel?
    private var descriptionModel: NoteDescriptionModel?
    
    private var textView: UITextView = {
        let textView = UITextView()
        return textView
    }()
}

class NotesItemImageTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NotesItemImageTableViewCell"
    
    public func configure(with viewModel: NotesItemViewModel) {
        
    }
}

class NotesItemButtonCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "NotesItemButtonCollectionViewCell"
    
    public func configure(with model: EditNotesButton) {
        self.button?.configuration?.image = UIImage(systemName: model.type == .text ? "character.cursor.ibeam" : "photo")!
        self.button?.addAction(UIAction() { action in
            print("button #\(model) tapped")
            model.handler()
        }, for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .tertiarySystemBackground
        config.baseForegroundColor = .link
        self.button = UIButton(configuration: config)

        contentView.addSubview(button!)
        
        button!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private var button: UIButton?
    
}

class NotesItemButtonsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NotesItemButtonsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with buttons: [EditNotesButton]) {
        self.buttons = buttons
        updateCollectionView()
    }
    
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collection
    }()
    
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private var buttons: [EditNotesButton] = []
}

private extension NotesItemButtonsTableViewCell {
    func setupCollectionView() {
        collectionView.register(NotesItemButtonCollectionViewCell.self, forCellWithReuseIdentifier: NotesItemButtonCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = collectionViewLayout
        
        let buttonsBodies: CGFloat = 32 * CGFloat(self.buttons.count)
        let spacings: CGFloat = 20 * (CGFloat(self.buttons.count) - 1.5)
        let leftInset = UIScreen.main.bounds.width / 2 - 16 - buttonsBodies - spacings
        collectionView.contentInset = UIEdgeInsets(top: 0, left: leftInset , bottom: 0, right: 0)
        
        collectionView.backgroundColor = .systemGroupedBackground
        
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
        
        let buttonsBodies: CGFloat = 32 * CGFloat(self.buttons.count)
        let spacings: CGFloat = 20 * (CGFloat(self.buttons.count) - 1.5)
        let leftInset = UIScreen.main.bounds.width / 2 - 16 - buttonsBodies - spacings
        collectionView.contentInset = UIEdgeInsets(top: 0, left: leftInset , bottom: 0, right: 0)
    }
    
    @objc func onButtonTapped() {
        
    }
}

extension NotesItemButtonsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let button = self.buttons[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotesItemButtonCollectionViewCell.reuseIdentifier, for: indexPath) as? NotesItemButtonCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: button)
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension NotesItemButtonsTableViewCell: UICollectionViewDelegate {
    
}

extension NotesItemButtonsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64, height: 64)
    }
}
