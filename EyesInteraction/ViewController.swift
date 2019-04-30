//
//  ViewController.swift
//  EyesInteraction
//
//  Created by hb on 2019/4/3.
//  Copyright © 2019年 ky. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    fileprivate lazy var focusView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.providesAudioData = false
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let btn = UIButton()
//        btn.frame = CGRect(x: 0, y: 50, width: 100, height: 30)
//        btn.backgroundColor = .red
//        btn.addTarget(self, action: #selector(btnDidTap(_:)), for: .touchUpInside)
//        view.addSubview(btn)
//
        let window = UIApplication.shared.keyWindow
        window?.addSubview(focusView)
//        let targetView = window?.hitTest(CGPoint(x: 10, y: 55), with: nil)
//
//        if let control = targetView as? UIControl {
//            let event = control.allControlEvents
//            control.sendActions(for: event)
//        }
    }
    
    @objc private func btnDidTap(_ sender: Any) {
        print("hello   world !!!!!")
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        print(faceAnchor.lookAtPoint)
//        faceAnchor.leftEyeTransform
//        faceAnchor.rightEyeTransform
        
        
        
//        guard let lookInLeft = faceAnchor.blendShapes[.eyeLookInLeft] as? Float,
//            let lookInRight = faceAnchor.blendShapes[.eyeLookInRight] as? Float,
//            let lookOutLeft = faceAnchor.blendShapes[.eyeLookOutLeft] as? Float,
//            let lookOutRight = faceAnchor.blendShapes[.eyeLookOutRight] as? Float,
//            let lookUpLeft = faceAnchor.blendShapes[.eyeLookUpLeft] as? Float,
//            let lookUpRight = faceAnchor.blendShapes[.eyeLookUpRight] as? Float,
//            let lookDownLeft = faceAnchor.blendShapes[.eyeLookDownLeft] as? Float,
//            let lookDownRight = faceAnchor.blendShapes[.eyeLookDownRight] as? Float
//            else { return }
        
//        let mid = (left.floatValue + right.floatValue) / 2
//        print(mid)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
}
