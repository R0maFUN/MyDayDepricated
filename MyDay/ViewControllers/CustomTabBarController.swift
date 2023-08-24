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
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.actionHandler = {
            let vc = AddScheduleItemViewController(self.mainViewModel.notificationsViewModel, self.mainViewModel.sectionsViewModel)
            HapticsManager.shared.impactVibrate(for: .medium, with: 0.7)
            self.present(vc, animated: true)
        }
        
        self.leftButton.setTitle(self.mainViewModel.sectionsViewModel.currentSectionManager.value?.addActionTitle, for: .normal)
        self.leftButton.tintColor = self.mainViewModel.sectionsViewModel.currentSectionManager.value?.addActionColor
        mainViewModel.sectionsViewModel.currentSectionManager.onChanged {
            self.leftButton.setTitle(self.mainViewModel.sectionsViewModel.currentSectionManager.value?.addActionTitle, for: .normal)
            self.leftButton.tintColor = self.mainViewModel.sectionsViewModel.currentSectionManager.value?.addActionColor
            
            if self.mainViewModel.sectionsViewModel.currentSectionManager.value is ScheduleSectionsManager {
                self.actionHandler = {
                    let vc = AddScheduleItemViewController(self.mainViewModel.notificationsViewModel, self.mainViewModel.sectionsViewModel)
                    HapticsManager.shared.impactVibrate(for: .medium, with: 0.7)
                    self.present(vc, animated: true)
                }
            } else if self.mainViewModel.sectionsViewModel.currentSectionManager.value is NotesSectionsManager {
                self.actionHandler = {
                    guard let notesSectionsManager = self.mainViewModel.sectionsViewModel.currentSectionManager.value else { return }
                    let vc = EditNotesItemViewController(notesSectionsManager)
                    HapticsManager.shared.impactVibrate(for: .medium, with: 0.7)
                    self.show(vc, sender: self)
                }
            } else if self.mainViewModel.sectionsViewModel.currentSectionManager.value is GoalsSectionsManager {
                self.actionHandler = {
                    guard let goalsSectionsManager = self.mainViewModel.sectionsViewModel.currentSectionManager.value else { return }
                    let vc = UINavigationController(rootViewController: EditGoalsItemViewController(goalsSectionsManager))
                    HapticsManager.shared.impactVibrate(for: .medium, with: 0.7)
                    self.present(vc, animated: true)
                }
            }
            
            
            // self.actionHandler = customAction
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    private var mainViewModel: MainViewModel
    
}
