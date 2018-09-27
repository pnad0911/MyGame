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
        alert.addAction(UIAlertAction(title: "Launch the Missile Again", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in }))
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        
//        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
//        let margin:CGFloat = 10.0
//        let rect = CGRect(x: margin, y: margin, width: alertController.view.bounds.size.width - margin * 4.0, height: 120)
//        let customView = UIView(frame: rect)
//
//        customView.backgroundColor = .green
//        alertController.view.addSubview(customView)
        
        let lauchAgain = UIAlertAction(title: "Launch the Missile Again", style: .default, handler: {(alert: UIAlertAction!) in print("Launch the Missile Again")})
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(lauchAgain)
        alertController.addAction(cancelAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion:{})
    }
}
