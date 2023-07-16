//
//  MainViewController.swift
//  MyDay
//
//  Created by Рома Балаян on 12.07.2023.
//

import UIKit

class SectionModel {
    var title: String = ""
    
    init(title: String) {
        self.title = title
    }
}

class ScheduleSectionModel: SectionModel {
    
}

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(datesCollectionView)
        
        datesCollectionView.backgroundColor = .red
        
        datesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIConstants.contentInset)
            make.height.equalTo(70)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        setupSectionsStackView()
        setupCollectionView()
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
    
    private let sections: [SectionModel] = [ScheduleSectionModel(title: "Schedule"),
                                            SectionModel(title: "Notes"),
                                            SectionModel(title: "Reminders"),
                                            SectionModel(title: "Goals")]
    
    private let sectionsStackView: UIStackView = {
        let xStack = UIStackView()
        xStack.axis = .horizontal
        xStack.distribution = .equalSpacing
        xStack.alignment = .bottom
        return xStack
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        //collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0//UIConstants.collectionViewSpacing
        layout.scrollDirection = .horizontal
        return layout
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
        var buttons: [SectionButton] = []
        
        for section in sections {
            let button = SectionButton()
            button.setTitle(section.title, for: .normal)
            buttons.append(button)
        }
        
        buttons[0].activate()
        buttons[0].onTapped {
            buttons[0].activate()
            buttons[1].deactivate()
            buttons[2].deactivate()
            buttons[3].deactivate()
        }
        
        buttons[1].onTapped {
            buttons[0].deactivate()
            buttons[1].activate()
            buttons[2].deactivate()
            buttons[3].deactivate()
        }
        
        buttons[2].onTapped {
            buttons[0].deactivate()
            buttons[1].deactivate()
            buttons[2].activate()
            buttons[3].deactivate()
        }
        
        buttons[3].onTapped {
            buttons[0].deactivate()
            buttons[1].deactivate()
            buttons[2].deactivate()
            buttons[3].activate()
        }
        
        return buttons
    }
}

private extension MainViewController {
    func setupCollectionView() {
        collectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: ScheduleCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = collectionViewLayout
        
        collectionView.backgroundColor = .systemGroupedBackground
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()//.inset(UIConstants.contentInset)
            make.bottom.equalToSuperview()
            make.top.equalTo(sectionsStackView.snp.bottom)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let section = sections[indexPath.item] as? ScheduleSectionModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCollectionViewCell.reuseIdentifier, for: indexPath) as? ScheduleCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: section)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCollectionViewCell.reuseIdentifier, for: indexPath) as? ScheduleCollectionViewCell else { return UICollectionViewCell() }
        //cell.configure(with: section)
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentSection()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateCurrentSection()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectSectionAt(indexPath.item)
    }

    func calculateNewContentOffset(_ currentOffset: CGFloat) -> CGFloat {
        let index = (Int(currentOffset) + (Int(collectionView.bounds.width) / 2)) / (Int(collectionView.bounds.width))

        if index == 0 {
            return currentOffset
        }
        
        return CGFloat(index) * collectionView.bounds.width
    }
    
    func updateCurrentSection() {
        let currentOffset = calculateNewContentOffset(collectionView.contentOffset.x)
        let newIndex = Int(currentOffset / (collectionView.bounds.width))
        
        selectSectionAt(newIndex)
    }
    
    func selectSectionAt(_ index: Int) {
        if index >= 0 && index < sections.count {
            scroll(to: index)
        }
    }
    
    func scroll(to index: Int) {
        let newOffset = collectionView.bounds.width * CGFloat(index)
        
        UIView.animate(withDuration: 0.2) {
            self.collectionView.contentOffset.x = CGFloat(newOffset)
        }
    }
    
    func scroll(_ scrollView: UIScrollView, to model: DateModel) {
        //guard let index = self.dates.firstIndex(where: { $0.date == model.date }) else { return }
        //scroll(scrollView, to: index)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
