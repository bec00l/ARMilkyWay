//
//  ViewController.swift
//  ARMilkyWay
//
//  Created by David Hurd on 9/4/17.
//  Copyright © 2017 Imagitale Studios. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    
    
    @IBOutlet var sceneView: ARSCNView!
    var planets = [(name : "mercury", texture : "mercury.jpg", radius : 0.00383 * 1.2, distanceFromSun : 0.03871),
                    (name : "venus", texture : "venus_surface.jpg", radius : 0.009498 * 1.2, distanceFromSun : 0.07233) ,
                    (name : "earth", texture : "earth_daymap.jpg", radius : 0.01 * 1.2, distanceFromSun : 0.1) ,
                    (name : "mars", texture : "mars.jpg", radius : 0.005321 * 1.2, distanceFromSun : 0.1523) ,
                    (name : "jupiter", texture : "2k_jupiter.jpg", radius : 0.1097 * 1.2, distanceFromSun : 0.5205),
                    (name : "saturn", texture : "2k_saturn.jpg", radius : 0.091 * 1.2, distanceFromSun : 0.9579),
                    (name : "uranus", texture : "2k_uranus.jpg", radius : 0.03981 * 1.2, distanceFromSun : 1.923),
                    (name : "neptune", texture : "2k_neptune.jpg", radius : 0.03866 * 1.2, distanceFromSun : 3.010)]
    let ART_ASSETS_FOLDER = "art.scnassets/"
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        // Set the scene to the view
        sceneView.delegate = self
        
        loadPlanets()
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            let location = gesture.location(in: gesture.view)
            
            let hitTestResults = sceneView.hitTest(location, options: nil)
            
            if let hitTestResult = hitTestResults.first {
                hitTestResult.node.runAction(SCNAction.rotateBy(x: 0, y: 0.9, z: 0, duration: 0.5))
            }
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            let location = gesture.location(in: gesture.view)
            
            let hitTestResults = sceneView.hitTest(location, options: nil)
            
            if let hitTestResult = hitTestResults.first {
                hitTestResult.node.runAction(SCNAction.rotateBy(x: 0, y: -0.9, z: 0, duration: 0.5))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView)  {
            let hitTestResults = sceneView.hitTest(touchLocation, options: nil)
            
            if let hitTestResult = hitTestResults.first {
                addInfo(at: hitTestResult)
            }
            
        }
    }
    
    func addInfo(at location: SCNHitTestResult)  {
        updateText(text: location.node.name!, atPosition: location.node.position)
        
    }
    
    func updateText (text: String, atPosition position: SCNVector3) {
        textNode.removeFromParentNode()
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(position.x, position.y +  0.1, position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    func loadPlanets() {
        for i in 0 ... planets.count - 1 {
            let sphere = SCNSphere(radius: CGFloat(planets[i].radius))
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "\(ART_ASSETS_FOLDER)\(planets[i].texture)")
            sphere.materials = [material]
            
            let planetNode = SCNNode(geometry: sphere)
            
            planetNode.position = SCNVector3(planets[i].distanceFromSun, -0.01, -0.8)
            planetNode.name = planets[i].name
            sceneView.scene.rootNode.addChildNode(planetNode)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    // MARK: - ARSCNViewDelegate
    
/*
     Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
