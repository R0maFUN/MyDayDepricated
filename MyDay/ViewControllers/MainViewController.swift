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
        
        initialize()
    }
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        self.sectionsViewModel = self.mainViewModel.sectionsViewModel
        
        self.datesCollectionView = DatesCollectionView(mainViewModel: self.mainViewModel)
        self.deleteAreaView = DeleteAreaView()
        
        super.init(nibName: nil, bundle: nil)
        
        connectToSectionsViewModel()
        
        self.deleteAreaView.onDeleteRequested { data in
            let currentSection = self.sectionsViewModel.getCurrentSectionVM()
            for uuid in data {
                currentSection.removeBy(id: uuid)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Contants
    private enum UIConstants {
        static let contentInset: CGFloat = 16.0
        static let sectionsToDatesOffset: CGFloat = 22.0
        
        static let deleteAreaBottomInset = 30.0
        static let deleteAreaHeight = 120.0
    }
    
    // MARK: - Private Properties
    private let mainViewModel: MainViewModel
    private let sectionsViewModel: SectionsViewModel
    
    private let datesCollectionView: DatesCollectionView
    private let deleteAreaView: DeleteAreaView
    
    private let sectionsStackView: UIStackView = {
        let xStack = UIStackView()
        xStack.axis = .horizontal
        xStack.distribution = .equalSpacing
        xStack.alignment = .bottom
        return xStack
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
}

private extension MainViewController {
    func initialize() {

        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(datesCollectionView)
        
        datesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIConstants.contentInset)
            make.height.equalTo(70)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        setupSectionsStackView()
        setupCollectionView()
        
        view.addSubview(deleteAreaView)
        
        deleteAreaView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIConstants.contentInset)
            make.height.equalTo(UIConstants.deleteAreaHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(UIConstants.deleteAreaBottomInset)
        }
    }
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
    
    func getSectionButtons() -> [SectionButton] {
        var buttons: [SectionButton] = []
        
        sectionsViewModel.sectionManagers.forEach { section in
            let button = SectionButton(section: section)
            button.onTapped {
                self.sectionsViewModel.select(section: section)
            }
            buttons.append(button)
        }
        
        return buttons
    }
}

private extension MainViewController {
    func setupCollectionView() {
        collectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: ScheduleCollectionViewCell.reuseIdentifier)
        collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: NoteCollectionViewCell.reuseIdentifier)
        collectionView.register(GoalsCollectionViewCell.self, forCellWithReuseIdentifier: GoalsCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = collectionViewLayout
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
        
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(sectionsStackView.snp.bottom)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionsViewModel.sectionManagers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let section = self.sectionsViewModel.sectionManagers[indexPath.item] as? ScheduleSectionsManager {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCollectionViewCell.reuseIdentifier, for: indexPath) as? ScheduleCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: section)
            
            cell.onDragBegin {
                self.deleteAreaView.show()
            }
            
            cell.onDragEnd {
                self.deleteAreaView.hide()
            }
            
            return cell
        } else if let section = self.sectionsViewModel.sectionManagers[indexPath.item] as? NotesSectionsManager {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.reuseIdentifier, for: indexPath) as? NoteCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: section)
            cell.onEditNoteRequested { note in
                guard let notesSectionsManager = self.mainViewModel.sectionsViewModel.currentSectionManager.value else { return }
                let vc = EditNotesItemViewController(notesSectionsManager, note: note)
                self.present(vc, animated: true)
            }
            
            cell.onQuickNoteRequested { note in
                guard let notesSectionsManager = self.mainViewModel.sectionsViewModel.currentSectionManager.value else { return }
                let quickNoteVc = QuickNoteViewController(notesSectionsManager, note: note)
                self.present(quickNoteVc, animated: true)
            }
            
            cell.onAddNoteRequested {
                guard let notesSectionsManager = self.mainViewModel.sectionsViewModel.currentSectionManager.value else { return }
                let vc = EditNotesItemViewController(notesSectionsManager)
                self.present(vc, animated: true)
            }
            
            cell.onDragBegin {
                self.deleteAreaView.show()
            }
            
            cell.onDragEnd {
                self.deleteAreaView.hide()
            }
            
            return cell
        } else if let section = self.sectionsViewModel.sectionManagers[indexPath.item] as? RemindersSectionsManager {
            
        } else if let section = self.sectionsViewModel.sectionManagers[indexPath.item] as? GoalsSectionsManager {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalsCollectionViewCell.reuseIdentifier, for: indexPath) as? GoalsCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: section)
//            cell.onEditNoteRequested { note in
//                guard let notesSectionsManager = self.mainViewModel.sectionsViewModel.currentSectionManager.value else { return }
//                let vc = EditNotesItemViewController(notesSectionsManager, note: note)
//                self.present(vc, animated: true)
//            }
//
//            cell.onAddNoteRequested {
//                guard let notesSectionsManager = self.mainViewModel.sectionsViewModel.currentSectionManager.value else { return }
//                let vc = EditNotesItemViewController(notesSectionsManager)
//                self.present(vc, animated: true)
//            }
            
            cell.onDragBegin {
                self.deleteAreaView.show()
            }
            
            cell.onDragEnd {
                self.deleteAreaView.hide()
            }
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCollectionViewCell.reuseIdentifier, for: indexPath) as? ScheduleCollectionViewCell else { return UICollectionViewCell() }
        //cell.configure(with: section)
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
    func connectToSectionsViewModel() {
        self.sectionsViewModel.currentSectionManagerIndex.onChanged {
            self.selectSectionAt(self.sectionsViewModel.currentSectionManagerIndex.value!)
        }
    }
    
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
        
        return CGFloat(index) * (collectionView.bounds.width)
    }
    
    func updateCurrentSection() {
        let currentOffset = calculateNewContentOffset(collectionView.contentOffset.x)
        let newIndex = Int(currentOffset / (collectionView.bounds.width))
        
        self.sectionsViewModel.selectSectionAt(newIndex)
    }
    
    func selectSectionAt(_ index: Int) {
        if index >= 0 && index < self.sectionsViewModel.sectionManagers.count {
            scroll(to: index)
        }
    }
    
    func scroll(to index: Int) {
        let newOffset = collectionView.bounds.width * CGFloat(index) - CGFloat(index) * 2 - 1
        
        UIView.animate(withDuration: 0.1) {
            self.collectionView.contentOffset.x = CGFloat(newOffset)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 2, height: collectionView.bounds.height)
    }
}
