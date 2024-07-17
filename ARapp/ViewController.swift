//
//  ViewController.swift
//  ARapp
//
//  Created by Shane Roach on 7/9/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var toy_carNode: SCNNode?
    var tv_retroNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        let toy_carScene = SCNScene(named:"art.scnassets/toy_car.scn")
        let tv_retroScene = SCNScene(named:"art.scnassets/tv_retro.scn")
        
        toy_carNode = toy_carScene?.rootNode
        tv_retroNode = tv_retroScene?.rootNode
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Playing cards", bundle: Bundle.main) {
            
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 2
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor{
            let size = imageAnchor.referenceImage.physicalSize
            
            let plane = SCNPlane(width: size.width, height: size.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            
            plane.cornerRadius = 0.005
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(planeNode)
            
            var shapeNode: SCNNode?
            
            if imageAnchor.referenceImage.name == "Figure01" {
                shapeNode = toy_carNode?.clone()
            }else if imageAnchor.referenceImage.name == "Figure02" {
                shapeNode = tv_retroNode?.clone()
            }else{
                shapeNode = tv_retroNode
            }
            if let shape = shapeNode {
                shape.position = SCNVector3Zero
                node.addChildNode(shape)
                
            }
           
            }
            
            
        
        return node
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
