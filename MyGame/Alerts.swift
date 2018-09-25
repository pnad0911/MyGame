//
//  Alerts.swift
//  MyGame
//
//  Created by Duy Pham on 9/24/18.
//  Copyright © 2018 Duy Pham. All rights reserved.
//

import Foundation
import SpriteKit

protocol Alerts { }
extension Alerts where Self: SKScene {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Launch the Missile Again", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in }))
//        alert.addAction(UIAlertAction(title: "Launch the Missile", style: UIAlertAction.Style.destructive, handler: nil))
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
