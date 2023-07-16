//
//  DatesCollectionView.swift
//  MyDay
//
//  Created by Рома Балаян on 12.07.2023.
//

import UIKit

class DatesCollectionView: UIView {
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        self.dates = getDates()
        self.selectedDate = self.dates[0] // anyways - no matters 0 shit
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectDateAt(10) // index of today - fucking important string
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let collectionViewSpacing: CGFloat = 30.0
        static let dateItemWidth: CGFloat = 30.0
        static let dateItemHeight: CGFloat = 64.0
        static let selectedDateItemHeight: CGFloat = 64.0
        static let theMostMagicNumber: CGFloat = 165.0 // Idk how to describe TODO: mb think about fix
    }
    
    // MARK: - Private Properties
    private var dates: [DateModel] = [] // TODO: Get list from ViewModel
    private var selectedDate: DateModel? { // TODO: Watch this from ViewModel
        didSet {
            self.scroll(collectionView, to: selectedDate!)
        }
    }
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: UIConstants.theMostMagicNumber, bottom: 0, right: UIConstants.theMostMagicNumber)
        return collectionView
    }()
    
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = UIConstants.collectionViewSpacing
        layout.scrollDirection = .horizontal
        return layout
    }()

}

// MARK: - Initialize
private extension DatesCollectionView {
    func initialize() {
        collectionView.backgroundColor = .systemGroupedBackground
        
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = collectionViewLayout
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func getDates() -> [DateModel] {
        let calendar = Calendar.current
        let currentDate = Date()

        let startDateComponents = calendar.dateComponents([.year, .month], from: currentDate)
        let endDateComponents = DateComponents(year: startDateComponents.year, month: startDateComponents.month! + 1, day: 0)

        let startDate = calendar.date(from: startDateComponents)!
        let endDate = calendar.date(from: endDateComponents)!

        var dateArray: [DateModel] = []

        calendar.enumerateDates(startingAfter: startDate, matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) { (date, _, stop) in
            guard let date = date else { return }
            
            if date <= endDate {
                dateArray.append(DateModel(date: date))
            } else {
                stop = true
            }
        }

        return dateArray
    }
}

// MARK: - UICollectionViewDataSource
extension DatesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
        let model = self.dates[indexPath.item]
        cell.configure(with: model)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DatesCollectionView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateSelectedDate(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateSelectedDate(scrollView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDateAt(indexPath.item)
    }

    func calculateNewContentOffset(_ currentOffset: CGFloat) -> CGFloat {
        let offset = Int(currentOffset) % Int(UIConstants.dateItemWidth + UIConstants.collectionViewSpacing)

        if offset == 0 {
            return currentOffset
        }
        
        return CGFloat(Int(currentOffset) + Int(UIConstants.dateItemWidth + UIConstants.collectionViewSpacing) - offset)
    }
    
    func updateSelectedDate(_ scrollView: UIScrollView) {
        let currentOffset = calculateNewContentOffset(scrollView.contentOffset.x + collectionView.contentInset.left)
        let newIndex = Int(currentOffset / (UIConstants.dateItemWidth + UIConstants.collectionViewSpacing))
        
        selectDateAt(newIndex)
    }
    
    func selectDateAt(_ index: Int) {
        if index >= 0 && index < dates.count {
            let newSelectedDate = self.dates[index]
            
            if newSelectedDate.day != selectedDate!.day {
                selectedDate!.selected = false
                selectedDate = newSelectedDate
                newSelectedDate.selected = true
            } else {
                scroll(self.collectionView, to: newSelectedDate)
            }
        }
    }
    
    func scroll(_ scrollView: UIScrollView, to index: Int) {
        let newOffset = CGFloat(index * Int(UIConstants.dateItemWidth + UIConstants.collectionViewSpacing)) - collectionView.contentInset.left
        
        UIView.animate(withDuration: 0.2) {
             scrollView.contentOffset.x = CGFloat(newOffset)
        }
    }
    
    func scroll(_ scrollView: UIScrollView, to model: DateModel) {
        guard let index = self.dates.firstIndex(where: { $0.date == model.date }) else { return }
        scroll(scrollView, to: index)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DatesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIConstants.dateItemWidth, height: UIConstants.dateItemHeight)
    }
}

// MARK: - TODO move away from view file
protocol DateModelDelegate: AnyObject {
    func onSelectedChanged(_ selected: Bool)
}

class DateModel {
    public var month: String {
        get {
            dateFormatter.dateFormat = "MMM"
            // "MAY"
            return dateFormatter.string(from: date).uppercased()
        }
    }
    
    public var day: Int {
        get {
            dateFormatter.dateFormat = "d"
            // 17
            return Int(dateFormatter.string(from: date)) ?? 0
        }
    }
    
    public var dayOfWeek: String {
        get {
            dateFormatter.dateFormat = "E"
            // mon
            return dateFormatter.string(from: date).lowercased()
        }
    }
    
    public var delegate: DateModelDelegate?
    
    public var selected: Bool = false {
        didSet {
            delegate?.onSelectedChanged(selected)
        }
    }
    
    init(date: Date) {
        self.date = date
    }
    
    public private(set) var date: Date = Date()
    private let dateFormatter = DateFormatter()
}

// MARK: - DateCollectionViewCell
class DateCollectionViewCell: UICollectionViewCell {
    static let identifier = "DateCollectionViewCell"
    
    public func configure(with model: DateModel) {
        monthLabel.text = model.month
        dayLabel.text = "\(model.day)"
        dayWeekLabel.text = model.dayOfWeek

        selectedDate = model.selected
        
        model.delegate = self
    }
    
    public func selectDate() {
        selectedDate = true
    }
    
    public func deselectDate() {
        selectedDate = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    override func prepareForReuse() {
        let scale = 1.0
        monthLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        dayLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        dayWeekLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        monthLabel.textColor = .secondaryLabel
        dayLabel.textColor = .secondaryLabel
        dayWeekLabel.textColor = .secondaryLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateView() {
        UIView.animate(withDuration: 0.3) { [self] in
            let scale = selectedDate ? 1.3 : 1
            monthLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
            dayLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
            dayWeekLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            monthLabel.textColor = selectedDate ? .label : .secondaryLabel
            dayLabel.textColor = selectedDate ? .label : .secondaryLabel
            dayWeekLabel.textColor = selectedDate ? .label : .secondaryLabel
        }
    }
    
    private var selectedDate: Bool = false {
        didSet {
            updateView()
        }
    }
    
    private var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "MAY"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "17"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var dayWeekLabel: UILabel = {
        let label = UILabel()
        label.text = "mon"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
}

private extension DateCollectionViewCell {
    func initialize() {
        contentView.addSubview(monthLabel)
        contentView.addSubview(dayLabel)
        contentView.addSubview(dayWeekLabel)
        
        monthLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(dayLabel.snp.top)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        dayWeekLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dayLabel.snp.bottom)
        }
    }
}

extension DateCollectionViewCell: DateModelDelegate {
    func onSelectedChanged(_ selected: Bool) {
        if selected {
            self.selectDate()
        } else {
            self.deselectDate()
        }
    }
}
