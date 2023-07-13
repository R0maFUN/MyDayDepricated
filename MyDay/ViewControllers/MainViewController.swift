//
//  MainViewController.swift
//  MyDay
//
//  Created by Рома Балаян on 12.07.2023.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(datesCollectionView)
        
        datesCollectionView.backgroundColor = .red
        
        datesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIConstants.contentInset)
            make.height.equalTo(70)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        setupSectionsStackView()
    }
    
    // MARK: - Private Contants
    private enum UIConstants {
        static let contentInset: CGFloat = 16.0
        static let sectionsToDatesOffset: CGFloat = 22.0
    }
    
    // MARK: - Private Properties
    
    private let datesCollectionView: DatesCollectionView = {
        let view = DatesCollectionView()
        return view
    }()
    
    private let sectionsStackView: UIStackView = {
        let xStack = UIStackView()
        xStack.axis = .horizontal
        xStack.distribution = .equalSpacing
        xStack.alignment = .bottom
        return xStack
    }()

}

private extension MainViewController {
    func setupSectionsStackView() {
        let buttons = getSectionButtons()
        
        for button in buttons {
            sectionsStackView.addArrangedSubview(button)
        }
        
        view.addSubview(sectionsStackView)
        
        sectionsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIConstants.contentInset)
            make.height.equalTo(24)
            make.top.equalTo(datesCollectionView.snp.bottom).offset(UIConstants.sectionsToDatesOffset)
        }
        
    }
    
    // TODO: Refactor, get Sections from viewModel
    func getSectionButtons() -> [SectionButton] {
        let buttons = [
            SectionButton(),
            SectionButton(),
            SectionButton(),
            SectionButton()
        ]
        
        buttons[0].setTitle("Schedule", for: .normal) // TODO: Translate
        buttons[0].activate()
        buttons[0].onTapped {
            buttons[0].activate()
            buttons[1].deactivate()
            buttons[2].deactivate()
            buttons[3].deactivate()
        }
        
        buttons[1].setTitle("Notes", for: .normal) // TODO: Translate
        buttons[1].onTapped {
            buttons[0].deactivate()
            buttons[1].activate()
            buttons[2].deactivate()
            buttons[3].deactivate()
        }
        
        buttons[2].setTitle("Reminders", for: .normal) // TODO: Translate
        buttons[2].onTapped {
            buttons[0].deactivate()
            buttons[1].deactivate()
            buttons[2].activate()
            buttons[3].deactivate()
        }
        
        buttons[3].setTitle("Goals", for: .normal) // TODO: Translate
        buttons[3].onTapped {
            buttons[0].deactivate()
            buttons[1].deactivate()
            buttons[2].deactivate()
            buttons[3].activate()
        }
        
        return buttons
    }
}
