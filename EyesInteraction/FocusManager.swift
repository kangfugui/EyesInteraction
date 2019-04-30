//
//  FocusManager.swift
//  EyesInteraction
//
//  Created by hb on 2019/4/14.
//  Copyright © 2019 ky. All rights reserved.
//

import Foundation
import UIKit

class FocusManager: NSObject {
    
    static let shared = FocusManager()
    
    fileprivate lazy var focus: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        view.backgroundColor = .red
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        
        return view
    }()
    
    func update(_ at: CGPoint) {
        focus.center = at
    }
    
    func initFocusToWindow() {
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(focus)
        focus.center = CGPoint(x: window.bounds.width / 2, y: window.bounds.height / 2)
    }
}
