//
//  AddGoalInstructionView.swift
//  MyDay
//
//  Created by Рома Балаян on 18.08.2023.
//

import UIKit

class ArrowModel {
    public let shape: CAShapeLayer
    public let destination: Destination
    public var isActive: Bool = false
    public private(set) var label: UILabel
    
    public private(set) var xOffset: CGFloat? = nil
    
    init(shape: CAShapeLayer, destination: Destination, isActive: Bool = false, label: UILabel = UILabel()) {
        self.shape = shape
        self.destination = destination
        self.isActive = isActive
        self.label = label
        
        self.label.text = labelText
    }
    
    private var labelText: String {
        get {
            switch self.destination {
            case .descriptionLeft:
                return "First Title"
            case .descriptionMiddle:
                return "Goal Value"
            case .descriptionRight:
                return "Second Title"
            case .stepLabel:
                return "Step"
            }
        }
    }
    
    enum Destination {
        case descriptionLeft
        case descriptionMiddle
        case descriptionRight
        case stepLabel
    }
    
    func createPath(goal: ModernGoalsItemCounterView) -> UIBezierPath {
        let path = UIBezierPath()
        
        self.xOffset = 0.0
        let yOffset = 16.0
        
        switch self.destination {
        case .descriptionLeft:
            xOffset = goal.descriptionLeftX
            break
        case .descriptionMiddle:
            xOffset = goal.descriptionMiddleX
            break
        case .descriptionRight:
            xOffset = goal.descriptionRightX
            break
        case .stepLabel:
            xOffset = goal.stepValueX
            break
        }

        path.move(to: CGPoint(x: 20 + xOffset! - 15, y: 10 + yOffset))
        path.addLine(to: CGPoint(x: 20 + xOffset! - 5, y: 50 + yOffset))
        path.addLine(to: CGPoint(x: 30 + xOffset! - 8, y: 40 + yOffset))
        path.addLine(to: CGPoint(x: 20 + xOffset! - 5, y: 50 + yOffset))
        path.addLine(to: CGPoint(x: 10 + xOffset! - 5, y: 40 + yOffset))
        
        return path
    }
}

class AddGoalInstructionView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public func configureArrows() {
        self.updateArrows()
    }
    
    public func nextStep() {
        self.arrows[self.currentIndex].isActive = false
        if self.currentIndex < self.arrows.count - 1 {
            self.currentIndex += 1
            self.arrows[self.currentIndex].isActive = true
        }
        updateArrows()
    }
    
    public func prevStep() {
        self.arrows[self.currentIndex].isActive = false
        if self.currentIndex <= 0 {
            return
        }
        
        self.currentIndex -= 1
        self.arrows[self.currentIndex].isActive = true
        updateArrows()
    }
    
    init(with goalTemplate: GoalsItemViewModel) {
        self.goalTemplate = goalTemplate
        
        super.init(frame: .zero)
        
        self.goalItemView.configure(with: self.goalTemplate)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum UIConstants {
        static let arrowLineWidth = 1.2
        static let inactiveOpacity: Float = 0.0
    }
    
    public private(set) var currentIndex: Int = 0
    
    private var goalTemplate: GoalsItemViewModel
    
    private var goalItemView: ModernGoalsItemCounterView = {
        let view = ModernGoalsItemCounterView()
        return view
    }()
    
    private let firstTitleArrow: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    private let goalAmountArrow: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    private let measureArrow: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    private let secondTitleArrow: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    private let stepArrow: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    private var arrows: [ArrowModel] = []
}

private extension AddGoalInstructionView {
    func initialize() {
        //self.backgroundColor = .red
        
        self.arrows = [
            ArrowModel(shape: firstTitleArrow, destination: .descriptionLeft, isActive: true, label: UILabel()),
            ArrowModel(shape: goalAmountArrow, destination: .descriptionMiddle, label: UILabel()),
            //ArrowModel(shape: measureArrow, label: UILabel(), destination: <#T##ArrowModel.Destination#>),
            ArrowModel(shape: secondTitleArrow, destination: .descriptionRight, label: UILabel()),
            //ArrowModel(shape: stepArrow, destination: .stepLabel, label: UILabel())
        ]
        
        self.arrows.forEach { arrow in
            arrow.label.font = UIFont(name: "Bradley Hand", size: 20)
            arrow.label.textColor = .label
            arrow.label.layer.opacity = UIConstants.inactiveOpacity
        }
        
        self.addSubview(goalItemView)
        
        goalItemView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
            make.bottom.equalToSuperview()
        }
        
        self.addArrows()
    }
    
    func addArrows() {
        self.arrows.forEach { arrow in
            
            arrow.shape.path = UIBezierPath().cgPath
            arrow.shape.lineCap = CAShapeLayerLineCap.round
            arrow.shape.lineWidth = UIConstants.arrowLineWidth
            arrow.shape.fillColor = UIColor.clear.cgColor
            arrow.shape.strokeColor = UIColor.label.cgColor
            arrow.shape.opacity = UIConstants.inactiveOpacity
            
            self.layer.addSublayer(arrow.shape)
            self.addSubview(arrow.label)
            
            arrow.label.snp.makeConstraints { make in
                make.centerX.equalTo(arrow.xOffset ?? 0.0)
                make.top.equalToSuperview()
            }
        }
    }
    
    func updateArrows() {
        self.arrows.forEach { arrow in
            let path = arrow.createPath(goal: goalItemView)
            
            let animationPath = CABasicAnimation(keyPath: "path")
            animationPath.duration = 0.3

            animationPath.toValue = path.cgPath
            animationPath.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

            animationPath.fillMode = CAMediaTimingFillMode.forwards
            animationPath.isRemovedOnCompletion = false
            
            let animationOpacite = CABasicAnimation(keyPath: "opacity")
            animationOpacite.duration = 0.3

            animationOpacite.toValue = arrow.isActive ? 1.0 : UIConstants.inactiveOpacity
            animationOpacite.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

            animationOpacite.fillMode = CAMediaTimingFillMode.forwards
            animationOpacite.isRemovedOnCompletion = false

            arrow.shape.add(animationOpacite, forKey: nil)
            arrow.label.layer.add(animationOpacite, forKey: nil)
            arrow.shape.add(animationPath, forKey: nil)
            
            arrow.label.snp.updateConstraints { make in
                make.centerX.equalTo(arrow.xOffset!)
            }
        }
    }
}
