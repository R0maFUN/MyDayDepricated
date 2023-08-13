//
//  HapticsManager.swift
//  MyDay
//
//  Created by Рома Балаян on 13.08.2023.
//

import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    private init() {}
    
    public func selectionVibrate() {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()
    }
    
    public func impactVibrate(for type: UIImpactFeedbackGenerator.FeedbackStyle, with intensity: CGFloat = 1.0) {
        let impactGenerator = UIImpactFeedbackGenerator(style: type)
        impactGenerator.prepare()
        impactGenerator.impactOccurred(intensity: intensity)
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType = .success) {
        let notificationsGenerator = UINotificationFeedbackGenerator()
        notificationsGenerator.prepare()
        notificationsGenerator.notificationOccurred(type)
    }
}
