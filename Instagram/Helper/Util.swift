//
//  Util.swift
//  Instagram
//
//  Created by Zhou Ti on 19/9/18.
//  Copyright © 2018 com.team48. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices
import Alamofire

@available(iOS 10.0, *)
class Util: NSObject {
    static func hapticFeedback(){
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.warning)
    }

    static func hapticEngine(){
        let peek = SystemSoundID(1519)
        AudioServicesPlaySystemSound(peek)
    }

    static func selectionFeedback(){
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()
    }

    static func animationButton(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(
            withDuration: 2.0,
            delay: 0,
            usingSpringWithDamping: CGFloat(0.20),
            initialSpringVelocity: CGFloat(6.0),
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                sender.transform = CGAffineTransform.identity
            },
            completion: { Void in () }
        )
    }

    static func readURL() -> String {
        return String(describing: ProcessInfo.processInfo.environment["URL"]!)
    }

    static func triggerNotification(name: String, withData: [String: Any]){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil, userInfo: withData)
    }

}
