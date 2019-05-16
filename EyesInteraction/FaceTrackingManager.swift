//
//  FaceTrackingManager.swift
//  EyesInteraction
//
//  Created by hb on 2019/4/14.
//  Copyright © 2019 ky. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SceneKit

class FaceTrackingManager: NSObject {
    
    static let shared = FaceTrackingManager()
    fileprivate var didHover: Bool = false
    fileprivate var didOut: Bool = false
    fileprivate var lookAtPoints: [CGPoint] = []
    
    var faceNode: SCNNode = SCNNode()
    
    var eyeLNode: SCNNode = {
        let geometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.2)
        geometry.radialSegmentCount = 3
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        let node = SCNNode()
        node.geometry = geometry
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()
    
    var eyeRNode: SCNNode = {
        let geometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.2)
        geometry.radialSegmentCount = 3
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        let node = SCNNode()
        node.geometry = geometry
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()

    var lookAtTargetEyeLNode: SCNNode = SCNNode()
    var lookAtTargetEyeRNode: SCNNode = SCNNode()
    
    let phoneScreenPointSize = UIScreen.main.bounds.size
    let phoneScreenSize = CGSize(width: 0.0623908297, height: 0.135096943231532)
    
    var virtualPhoneNode: SCNNode = SCNNode()
    
    var virtualScreenNode: SCNNode = {
        
        let screenGeometry = SCNPlane(width: 1, height: 1)
        screenGeometry.firstMaterial?.isDoubleSided = true
        screenGeometry.firstMaterial?.diffuse.contents = UIColor.green
        
        return SCNNode(geometry: screenGeometry)
    }()
    
    var eyeLookAtPositionXs: [CGFloat] = []
    var eyeLookAtPositionYs: [CGFloat] = []
    
    lazy var sceneView: ARSCNView = {
        let view = ARSCNView()
        view.delegate = self
        view.session.delegate = self
        view.automaticallyUpdatesLighting = true
        return view
    }()
    
    func startTracking() {
        guard ARFaceTrackingConfiguration.isSupported
            else { return }
        
        let config = ARFaceTrackingConfiguration()
        config.isLightEstimationEnabled = true
        sceneView.session.run(config, options: [.removeExistingAnchors, .resetTracking])
        
        sceneView.scene.rootNode.addChildNode(faceNode)
        sceneView.scene.rootNode.addChildNode(virtualPhoneNode)
        virtualPhoneNode.addChildNode(virtualScreenNode)
        faceNode.addChildNode(eyeLNode)
        faceNode.addChildNode(eyeRNode)
        eyeLNode.addChildNode(lookAtTargetEyeLNode)
        eyeRNode.addChildNode(lookAtTargetEyeRNode)
        
        lookAtTargetEyeLNode.position.z = 2
        lookAtTargetEyeRNode.position.z = 2
        
        let timer = Timer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(triggerTimer(_:)),
            userInfo: nil,
            repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
    }
    
    @objc fileprivate func triggerTimer(_ sender: Timer) {
        
        self.lookAtPoints = Array(self.lookAtPoints.suffix(50))
        guard lookAtPoints.count == 50 else { return }
        
        guard let first = lookAtPoints.first, let last = lookAtPoints.last
            else { return }
        
        let diff = max(abs(first.x-last.x), abs(first.y-last.y))
        if diff < 20 {
            print("悬停触发...")
            if !self.didHover {
                self.didHover = true
                
                HandleManager.shared.triggerAt(last)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.didHover = false
                })
            }
        }
    }
    
    func pauseTracking() {
        sceneView.session.pause()
    }
    
    fileprivate func update(with anchor: ARFaceAnchor) {
        
        eyeRNode.simdTransform = anchor.rightEyeTransform
        eyeLNode.simdTransform = anchor.leftEyeTransform
        
        var eyeLLookAt = CGPoint.zero
        var eyeRLookAt = CGPoint.zero
        
        let heightCompensation: CGFloat = 312
        
        DispatchQueue.main.async {
            
            let rightResult = self.virtualPhoneNode.hitTestWithSegment(
                from: self.lookAtTargetEyeRNode.worldPosition,
                to: self.eyeRNode.worldPosition)
            
            let leftResult = self.virtualPhoneNode.hitTestWithSegment(
                from: self.lookAtTargetEyeLNode.worldPosition,
                to: self.eyeLNode.worldPosition)
            
            for result in rightResult {
                eyeRLookAt.x = CGFloat(result.localCoordinates.x) / (self.phoneScreenSize.width / 2) * self.phoneScreenPointSize.width
                
                eyeRLookAt.y = CGFloat(result.localCoordinates.y) / (self.phoneScreenSize.height / 2) * self.phoneScreenPointSize.height + heightCompensation
            }
            
            for result in leftResult {
                eyeLLookAt.x = CGFloat(result.localCoordinates.x) / (self.phoneScreenSize.width / 2) * self.phoneScreenPointSize.width
                
                eyeLLookAt.y = CGFloat(result.localCoordinates.y) / (self.phoneScreenSize.height / 2) * self.phoneScreenPointSize.height + heightCompensation
            }
            
            self.eyeLookAtPositionXs.append((eyeRLookAt.x + eyeLLookAt.x) / 2)
            self.eyeLookAtPositionYs.append(-(eyeRLookAt.y + eyeLLookAt.y) / 2)
            self.eyeLookAtPositionXs = Array(self.eyeLookAtPositionXs.suffix(8))
            self.eyeLookAtPositionYs = Array(self.eyeLookAtPositionYs.suffix(8))
            
            let smoothEyeLookAtPositionX = self.eyeLookAtPositionXs.average!
            let smoothEyeLookAtPositionY = self.eyeLookAtPositionYs.average!
            
            let x = Int(round(smoothEyeLookAtPositionX + self.phoneScreenPointSize.width / 2))
            let y = Int(round(smoothEyeLookAtPositionY + self.phoneScreenPointSize.height / 2))
            
            let point = CGPoint(x: x, y: y)
            if let last = self.lookAtPoints.last {
                let diff = point.diff(last)
                if diff < 5.0 {
                    return
                }
            }
            
            self.lookAtPoints.append(point)
            FocusManager.shared.update(point)
            
            let shapes = anchor.blendShapes
            
            if let tongueOut = shapes[.tongueOut] {
                let out = min(CGFloat(truncating: tongueOut)/0.7, 1.0)
                if out == 1 {
                    if !self.didOut {
                        self.didOut = true
                        
                        HandleManager.shared.triggerPop()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                            self.didOut = false
                        })
                    }
                }
            }
            
//            if let left = shapes[.mouthSmileLeft], let right = shapes[.mouthSmileRight] {
//                let smile = min(max(CGFloat(truncating: left), CGFloat(truncating: right))/0.7, 1.0)
//                if smile == 1 {
//
//                    if !self.didSmile {
//                        self.didSmile = true
//                        HandleManager.shared.triggerAt(CGPoint(x: 180, y: 180))
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
//                            self.didSmile = false
//                        })
//                    }
//                }
//            }
        }
    }
}

extension FaceTrackingManager: ARSessionDelegate {
    
}

extension FaceTrackingManager: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        faceNode.transform = node.transform
        update(with: faceAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        faceNode.transform = node.transform
        update(with: faceAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let node = sceneView.pointOfView {
            virtualPhoneNode.transform = node.transform
        }
    }
}
