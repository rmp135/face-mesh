//
//  SettingsPopoverController.swift
//  face-mesh
//
//  Created by Ryan Poole on 24/12/2017.
//  Copyright © 2017 Ryan Poole. All rights reserved.
//

import UIKit

class SettingsPopoverController: UITableViewController {
    
    weak var maskDelegate: MaskDelegate?
    weak var cameraDelegate: CameraDelegate?
    
    @IBOutlet weak var lightingSwitch: UISwitch!
    @IBOutlet weak var backgroundSwitch: UISwitch!
    @IBOutlet weak var wireframeSwitch: UISwitch!
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: super.preferredContentSize.width, height: 135)
        }
        set { super.preferredContentSize = newValue }
    }
    
    @IBAction func onBackgroundSwitchChange(_ sender: UISwitch) {
        cameraDelegate?.isCameraEnabled = sender.isOn
    }
    
    @IBAction func onWireframeSwitchChange(_ sender: UISwitch) {
        maskDelegate?.isWireframe = sender.isOn
    }
    
    @IBAction func onLightingSwitchChange(_ sender: UISwitch) {
        maskDelegate?.isPhysicalLighting = sender.isOn
    }
    
    override func viewDidLoad() {
        wireframeSwitch.isOn = maskDelegate!.isWireframe
        backgroundSwitch.isOn = cameraDelegate!.isCameraEnabled
        lightingSwitch.isOn = maskDelegate!.isPhysicalLighting
    }
}
