//
//  SectionButton.swift
//  MyDay
//
//  Created by Рома Балаян on 12.07.2023.
//

import UIKit

class SectionButton: UIButton {
    
    public func onTapped(_ handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    init(section: SectionsManager) {
        self.sectionsManager = section
        
        super.init(frame: .zero)
        
        self.isActive = self.sectionsManager.isActive.value ?? false
        self.sectionsManager.isActive.onChanged {
            self.isActive = self.sectionsManager.isActive.value!
        }
        
        self.setTitle(section.title, for: .normal)
        
        updateView()
        
        self.addTarget(self, action: #selector(onTappedObjc), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func onIsActiveChanged() {
        updateView()
    }
    
    // TODO: Refactor (size of label should depend on scroll of bottom collectionView)
    private func updateView() {
        if isActive {
            guard let label = self.titleLabel else { return }
            //self.setTitleColor(.label, for: .normal)
            UIView.transition(with: label, duration: 0.15, options: .transitionCrossDissolve, animations: {
                label.font = .systemFont(ofSize: 20, weight: .bold)
            }) { isFinished in
                if isFinished {
                    self.setTitleColor(.label, for: .normal)
                }
            }
            
        } else {
            guard let label = self.titleLabel else { return }
            //self.setTitleColor(.secondaryLabel, for: .normal)
            UIView.transition(with: label, duration: 0.15, options: .transitionCrossDissolve, animations: {
                label.font = .systemFont(ofSize: 14, weight: .medium)
            }) { isFinished in
                if isFinished {
                    self.setTitleColor(.secondaryLabel, for: .normal)
                }
            }
        }
    }
    
    @objc private func onTappedObjc() {
        self.handler?()
    }
    
    private var isActive: Bool = false {
        didSet {
            onIsActiveChanged()
        }
    }
    
    private var handler: (() -> Void)?
    
    private var sectionsManager: SectionsManager
}

// MainViewModel - currentSection (mb SectionModel -> ScheduleModel | NotesModel | RemindersModel | GoalsModel)

