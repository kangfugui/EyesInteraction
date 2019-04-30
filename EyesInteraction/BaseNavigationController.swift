//
//  BaseNavigationController.swift
//  EyesInteraction
//
//  Created by hb on 2019/4/17.
//  Copyright © 2019 ky. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    let sceneView = FaceTrackingManager.shared.sceneView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(sceneView)
        FaceTrackingManager.shared.startTracking()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        sceneView.frame = CGRect(
            x: 0, y: self.view.safeAreaInsets.top,
            width: self.view.bounds.width / 4, height: self.view.bounds.height / 5)
    }
}
