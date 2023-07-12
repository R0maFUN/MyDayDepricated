//
//  CustomTabBarController.swift
//  MyDay
//
//  Created by Рома Балаян on 11.07.2023.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - Public Properties
    public var actionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        tabBar.addSubview(leftButton)
        
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.top.equalToSuperview().inset(6)
        }
        
        leftButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        DispatchQueue.main.async {
            if let items = self.tabBar.items {
                items[0].isEnabled = false
            }
        }
    }
    
    // MARK: - Private Properties
    private let leftButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Item"
        config.image = UIImage(systemName: "plus.circle.fill")
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        
        return button
    }()
    
    @objc func buttonTapped() {
        actionHandler?()
    }

}
