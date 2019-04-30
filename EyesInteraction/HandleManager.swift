//
//  HandleManager.swift
//  EyesInteraction
//
//  Created by hb on 2019/4/17.
//  Copyright © 2019 ky. All rights reserved.
//

import UIKit

class HandleManager: NSObject {
    
    static let shared = HandleManager()
    
    func triggerAt(_ point: CGPoint) {
        
        let window = UIApplication.shared.keyWindow
        let targetView = window?.hitTest(point, with: nil)
        if let control = targetView as? UIControl {
            let event = control.allControlEvents
            control.sendActions(for: event)
        }
    }
    
    func triggerPop() {
        let window = UIApplication.shared.keyWindow
        if let navigation = window?.rootViewController as? UINavigationController {
            if navigation.viewControllers.count > 1 {
                navigation.popViewController(animated: true)
            }
        }
    }
}
