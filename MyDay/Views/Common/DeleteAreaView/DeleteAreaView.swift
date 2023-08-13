//
//  DeleteAreaView.swift
//  MyDay
//
//  Created by Рома Балаян on 29.07.2023.
//

import UIKit

class DeleteAreaView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init() {
        super.init(frame: .zero)
        
        initialize()
    }
    
    public func show() {
        UIView.animate(withDuration: UIConstants.animationDuration, animations: {
            self.layer.opacity = 0.9
        })
    }
    
    public func hide() {
        UIView.animate(withDuration: UIConstants.animationDuration, animations: {
            self.layer.opacity = 0
        })
    }
    
    public func onDeleteRequested(_ handler: @escaping (_ data: [String]) -> Void) {
        self.onDeleteRequestedHandlers.append(handler)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal enum UIConstants {
        static let backgroundColor = UIColor.darkGray
        static let activeBackgroundColor = UIColor.black.withAlphaComponent(0.8)
        static let cornerRadius = 16.0
        static let animationDuration = 0.3
        
        static let icon = UIImage(systemName: "trash")!
        static let iconSize = 30.0
    }
    
    
    private let iconImageView: UIImageView = {
        let image = UIImageView(image: UIConstants.icon)
        image.tintColor = .systemRed
        return image
    }()
    
    internal private(set) var onDeleteRequestedHandlers: [(_ data: [String]) -> Void] = []
}

private extension DeleteAreaView {
    func initialize() {
        self.backgroundColor = UIConstants.backgroundColor
        self.layer.cornerRadius = UIConstants.cornerRadius
        self.layer.opacity = 0
        
        let dropInteraction = UIDropInteraction(delegate: self)
        self.addInteraction(dropInteraction)
        
        addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(UIConstants.iconSize)
        }
    }
}
