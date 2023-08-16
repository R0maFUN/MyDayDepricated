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
    }
    
    func createUnderGraph() {
        let h = 100.0
        let w = 180.0
        
        let innerAngle = CGFloat.pi / 2
        let outerAngle = CGFloat.pi / 2

        
        let centerAngle = 3 * CGFloat.pi / 2
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: w / 4 + UIConstants.lineWidth / 2, y: h / 2), radius: w / 4 - UIConstants.lineWidth, startAngle: centerAngle - innerAngle, endAngle: centerAngle + innerAngle, clockwise: true)
        path.addArc(withCenter: CGPoint(x: w / 4 + UIConstants.lineWidth / 2, y: h / 2), radius: w / 4, startAngle: centerAngle + innerAngle, endAngle: centerAngle - outerAngle, clockwise: false)
        path.close()
        
        let centerAngle2 = CGFloat.pi / 2
        let path2 = UIBezierPath()
        path2.addArc(withCenter: CGPoint(x: 3 * w / 4 - UIConstants.lineWidth / 2, y: h / 2), radius: w / 4 - UIConstants.lineWidth, startAngle: centerAngle2 - innerAngle, endAngle: centerAngle2 + innerAngle, clockwise: true)
        path2.addArc(withCenter: CGPoint(x: 3 * w / 4 - UIConstants.lineWidth / 2, y: h / 2), radius: w / 4, startAngle: centerAngle2 + innerAngle, endAngle: centerAngle2 - outerAngle, clockwise: false)
        path2.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.colors = [UIColor.systemRed.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 180, height: 100)
        gradientLayer.mask = shapeLayer
        gradientLayer.opacity = 0.4
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = path2.cgPath
        
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer2.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer2.colors = [UIColor.systemPurple.cgColor, UIColor.systemRed.cgColor]
        gradientLayer2.frame = CGRect(x: 0, y: 0, width: 180, height: 100)
        gradientLayer2.mask = shapeLayer2
        gradientLayer2.opacity = 0.4
     
        self.layer.addSublayer(gradientLayer)
        self.layer.addSublayer(gradientLayer2)
    }
    
    func createUpperGraph() {
        let h = 100.0
        let w = 180.0
        
        let innerAngle = CGFloat.pi / 2
        let outerAngle = CGFloat.pi / 2
        
        
        let centerAngle = 3 * CGFloat.pi / 2
        let convertedValue = (self.currentValue - self.minValue) / (self.goalValue - self.minValue) * 100
        var radiansOffset: CGFloat = convertedValue / 50 * CGFloat.pi
        var radiansOffset2: CGFloat = 0
        if convertedValue > 50 {
            radiansOffset = CGFloat.pi
            radiansOffset2 = (convertedValue - 50) / 50 * CGFloat.pi
        }
        
        let reversedRadiansOffset: CGFloat = CGFloat.pi - radiansOffset
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: w / 4 + UIConstants.lineWidth / 2, y: h / 2), radius: w / 4 - UIConstants.lineWidth, startAngle: centerAngle - innerAngle, endAngle: centerAngle + innerAngle - reversedRadiansOffset, clockwise: true)
        path.addArc(withCenter: CGPoint(x: w / 4 + UIConstants.lineWidth / 2, y: h / 2), radius: w / 4, startAngle: centerAngle + innerAngle - reversedRadiansOffset, endAngle: centerAngle - outerAngle, clockwise: false)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 0.8)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 0.3)
        gradientLayer.colors = [UIColor.systemRed.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 180, height: 100)
        gradientLayer.mask = shapeLayer
        
        let reversedRadiansOffset2: CGFloat = CGFloat.pi - radiansOffset2
        let centerAngle2 = CGFloat.pi / 2
        let path2 = UIBezierPath()
        path2.addArc(withCenter: CGPoint(x: 3 * w / 4 - UIConstants.lineWidth / 2, y: h / 2), radius: w / 4 - UIConstants.lineWidth, startAngle: centerAngle2 - innerAngle + reversedRadiansOffset2, endAngle: centerAngle2 + innerAngle, clockwise: true)
        path2.addArc(withCenter: CGPoint(x: 3 * w / 4 - UIConstants.lineWidth / 2, y: h / 2), radius: w / 4, startAngle: centerAngle2 + innerAngle, endAngle: centerAngle2 - outerAngle + reversedRadiansOffset2, clockwise: false)
        path2.close()
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = path2.cgPath
        
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.startPoint = CGPoint(x: 0.2, y: 0.8)
        gradientLayer2.endPoint = CGPoint(x: 0.8, y: 0.3)
        gradientLayer2.colors = [UIColor.systemPurple.cgColor, UIColor.systemRed.cgColor]
        gradientLayer2.frame = CGRect(x: 0, y: 0, width: 180, height: 100)
        gradientLayer2.mask = shapeLayer2
        
        self.layer.addSublayer(gradientLayer)
        self.layer.addSublayer(gradientLayer2)
    }
    
    init() {
        super.init(frame: .zero)
        
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func update() {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        if self.currentValue > self.goalValue {
            self.currentValue = self.goalValue
            return
        }
        
        createUnderGraph()
        createUpperGraph()
    }
    
    public var minValue = 0.0
    public var goalValue = 100.0
    public var currentValue = 0.0 {
        didSet {
            self.update()
        }
    }
}
