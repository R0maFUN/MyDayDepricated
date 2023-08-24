//
//  SnakeGraphView.swift
//  MyDay
//
//  Created by Рома Балаян on 15.08.2023.
//

import UIKit

class SnakeGraphView: UIView {
    
    private enum UIConstants {
        static let lineWidth = 12.0
        static let hegiht = 100.0
        static let width = 180.0
    }
    
    init() {
        super.init(frame: .zero)
        
        createUnderGraph()
        createUpperGraph()
        
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func update() {
        if self.currentValue > self.goalValue {
            self.currentValue = self.goalValue
            return
        }
        
        updateUpperGraph()
    }
    
    public var minValue = 0.0
    public var goalValue = 100.0
    public var currentValue = 0.0 {
        didSet {
            self.update()
        }
    }
    
    private var upperLeftShape: CAShapeLayer = {
        let shape = CAShapeLayer()
        return shape
    }()
    
    private var upperRightShape: CAShapeLayer = {
        let shape = CAShapeLayer()
        return shape
    }()
}

private extension SnakeGraphView {
    func createUnderGraph() {
        let h = UIConstants.hegiht
        let w = UIConstants.width

        let pathLeft = UIBezierPath(arcCenter: CGPoint(x: w / 4 + UIConstants.lineWidth / 2, y: h / 2), radius: w / 4 - UIConstants.lineWidth / 2, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        
        
        let pathRight = UIBezierPath(arcCenter: CGPoint(x: 3 * w / 4 - UIConstants.lineWidth / 2, y: h / 2), radius: w / 4 - UIConstants.lineWidth / 2, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: false)
        
        let shapeLayerLeft = CAShapeLayer()
        shapeLayerLeft.path = pathLeft.cgPath
        shapeLayerLeft.lineCap = CAShapeLayerLineCap.round
        shapeLayerLeft.lineWidth = UIConstants.lineWidth
        shapeLayerLeft.fillColor = UIColor.clear.cgColor
        shapeLayerLeft.strokeColor = UIColor.black.cgColor
        
        let gradientLayerLeft = CAGradientLayer()
        gradientLayerLeft.startPoint = CGPoint(x: 0, y: 0)
        gradientLayerLeft.endPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayerLeft.colors = [UIColor.systemRed.withAlphaComponent(0.4).cgColor, UIColor.systemPurple.withAlphaComponent(0.4).cgColor]
        gradientLayerLeft.frame = CGRect(x: 0, y: 0, width: w, height: h)
        gradientLayerLeft.mask = shapeLayerLeft
        gradientLayerLeft.opacity = 1
        
        let shapeLayerRight = CAShapeLayer()
        shapeLayerRight.path = pathRight.cgPath
        shapeLayerRight.lineCap = CAShapeLayerLineCap.round
        shapeLayerRight.lineWidth = UIConstants.lineWidth
        shapeLayerRight.fillColor = UIColor.clear.cgColor
        shapeLayerRight.strokeColor = UIColor.black.cgColor
        
        let gradientLayerRight = CAGradientLayer()
        gradientLayerRight.startPoint = CGPoint(x: 0, y: 0)
        gradientLayerRight.endPoint = CGPoint(x: 1, y: 1)
        gradientLayerRight.colors = [UIColor.systemPurple.withAlphaComponent(0.4).cgColor, UIColor.systemRed.withAlphaComponent(0.4).cgColor]
        gradientLayerRight.frame = CGRect(x: 0, y: 0, width: w, height: h)
        gradientLayerRight.mask = shapeLayerRight
        gradientLayerRight.opacity = 1
        gradientLayerRight.backgroundColor = UIColor.tertiarySystemBackground.cgColor
     
        self.layer.addSublayer(gradientLayerLeft)
        self.layer.addSublayer(gradientLayerRight)
    }
    
    func createUpperGraph() {
        let h = UIConstants.hegiht
        let w = UIConstants.width
        
        upperLeftShape.path = UIBezierPath().cgPath
        upperLeftShape.lineCap = CAShapeLayerLineCap.round
        upperLeftShape.lineWidth = UIConstants.lineWidth
        upperLeftShape.fillColor = UIColor.clear.cgColor
        upperLeftShape.strokeColor = UIColor.black.cgColor
        
        let gradientLayerLeft = CAGradientLayer()
        gradientLayerLeft.startPoint = CGPoint(x: 0, y: 0)
        gradientLayerLeft.endPoint = CGPoint(x: 1, y: 0)
        gradientLayerLeft.colors = [UIColor.systemRed.cgColor, UIColor.systemPurple.cgColor]
        gradientLayerLeft.frame = CGRect(x: 0, y: 0, width: w, height: h)
        gradientLayerLeft.mask = upperLeftShape
        gradientLayerLeft.opacity = 1
        
        upperRightShape.path = UIBezierPath().cgPath
        upperRightShape.lineCap = CAShapeLayerLineCap.round
        upperRightShape.lineWidth = UIConstants.lineWidth
        upperRightShape.fillColor = UIColor.clear.cgColor
        upperRightShape.strokeColor = UIColor.black.cgColor
        
        let gradientLayerRight = CAGradientLayer()
        gradientLayerRight.startPoint = CGPoint(x: 0, y: 0)
        gradientLayerRight.endPoint = CGPoint(x: 1, y: 0)
        gradientLayerRight.colors = [UIColor.systemPurple.cgColor, UIColor.systemRed.cgColor]
        gradientLayerRight.frame = CGRect(x: 0, y: 0, width: w, height: h)
        gradientLayerRight.mask = upperRightShape
        gradientLayerRight.opacity = 1
     
        self.layer.addSublayer(gradientLayerLeft)
        self.layer.addSublayer(gradientLayerRight)
    }
    
    func updateUpperGraph() {
        let h = UIConstants.hegiht
        let w = UIConstants.width
        
        let convertedValue = (self.currentValue - self.minValue) / (self.goalValue - self.minValue) * 100
        var radiansOffsetLeft: CGFloat = convertedValue / 50 * CGFloat.pi
        var radiansOffsetRight: CGFloat = 0
        if convertedValue >= 50 {
            radiansOffsetLeft = CGFloat.pi
            radiansOffsetRight = (convertedValue - 50) / 50 * CGFloat.pi
        }

        let pathLeft = UIBezierPath(arcCenter: CGPoint(x: w / 4 + UIConstants.lineWidth / 2, y: h / 2), radius: w / 4 - UIConstants.lineWidth / 2, startAngle: CGFloat.pi, endAngle: CGFloat.pi + radiansOffsetLeft, clockwise: true)
        
        let pathRight = UIBezierPath(arcCenter: CGPoint(x: 3 * w / 4 - UIConstants.lineWidth / 2, y: h / 2), radius: w / 4 - UIConstants.lineWidth / 2, startAngle: CGFloat.pi, endAngle: CGFloat.pi - radiansOffsetRight, clockwise: false)

        let animationLeft = CABasicAnimation(keyPath: "path")
        animationLeft.duration = 0.3

        animationLeft.toValue = pathLeft.cgPath
        animationLeft.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        animationLeft.fillMode = CAMediaTimingFillMode.forwards
        animationLeft.isRemovedOnCompletion = false

        upperLeftShape.add(animationLeft, forKey: nil)
        
        let animationRight = CABasicAnimation(keyPath: "path")
        animationRight.duration = 0.3

        animationRight.toValue = pathRight.cgPath
        animationRight.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        animationRight.fillMode = CAMediaTimingFillMode.forwards
        animationRight.isRemovedOnCompletion = false

        upperRightShape.add(animationRight, forKey: nil)
    }
}
