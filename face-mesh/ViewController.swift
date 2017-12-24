//
//  ViewController.swift
//  face-mesh
//
//  Created by Ryan Poole on 24/12/2017.
//  Copyright © 2017 Ryan Poole. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

protocol CameraDelegate: class {
    var isCameraEnabled: Bool { get set }
    func exportFaceMap()
}

class ViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate, CameraDelegate {

    var utilities = Utilities()
    
    var isCameraEnabled: Bool = true {
        didSet {
            if isCameraEnabled {
                sceneView.scene.background.contents = cameraSource
            } else {
                cameraSource = sceneView.scene.background.contents
                sceneView.scene.background.contents = UIColor.black
            }
        }
    }
    @IBOutlet weak var settingsBtn: UIButton!
    
    @IBOutlet var sceneView: ARSCNView!
    
    var session: ARSession {
        return sceneView.session
    }
    
    var faceNode: Mask?
    
    var cameraSource: Any? // When setting the camera to black, we have to store the original source.
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let mask = ARSCNFaceGeometry(device: sceneView.device!)
        let maskNode = Mask(geometry: mask!)
        faceNode = maskNode
        DispatchQueue.main.async {
            for child in node.childNodes {
                child.removeFromParentNode()
            }
            node.addChildNode(maskNode)
            self.settingsBtn.isEnabled = true
        }
        
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        faceNode?.update(withFaceAnchor: faceAnchor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.session.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        cameraSource = sceneView.scene.background.contents
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetTracking()
    }
    
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        session.pause()
        
        let configuration = ARWorldTrackingConfiguration()

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

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            self.resetTracking()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "settingsPop" {
            let popoverController = segue.destination as! SettingsPopoverController
            popoverController.maskDelegate = faceNode
            popoverController.cameraDelegate = self
            
            guard let popController = segue.destination.popoverPresentationController, let button = sender as? UIButton else { return }
            
            popController.delegate = self
            popController.sourceRect = button.bounds
            
            popoverController.modalPresentationStyle = .popover
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func exportFaceMap() {
        guard let a = session.currentFrame?.anchors[0] as? ARFaceAnchor else { return }
        
        let toprint = utilities.exportToCollada(geometry: a.geometry)
        
        let file = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("face.dae")
        do {
            try toprint.write(to: file!, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            
        }
        let vc = UIActivityViewController(activityItems: [file as Any], applicationActivities: [])
        present(vc, animated: true, completion: nil)
        
    }
}
