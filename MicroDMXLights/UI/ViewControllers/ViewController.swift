//
//  ViewController.swift
//  MIcroDMXLights
//
//  Created by adrian.szymanowski on 13/01/2020.
//  Copyright © 2020 adrian.szymanowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var slidersStackView: UIStackView!

    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var connectButton: CustomButton!
    
    lazy var service = MQTT.init(id: "iOS-" + String(ProcessInfo().processIdentifier))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.delegate = self
        service.configure(topic: "esp/example/push")
    }
    
    @IBAction func onSwitchButtonTapped(_ sender: CustomButton) {
        if service.isConnected {
            service.disconnect()
            connectButton.backgroundColor = .white
        } else {
            service.connect()
            connectButton.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        }
    }
    
    @IBAction func onSliderChange(_ sender: RGBSlider) {
        let oldValue = sender.value
        sender.setValue(sender.value.rounded(.toNearestOrEven), animated: true)
        
        if sender.value != oldValue {
            previewView.update(with: sender.color.color, value: sender.value)
        }
    }
    
    @IBAction func onSendButtonTapped(_ sender: CustomButton) {
        service.sendMessage(
        """
            {
              "params": {
                "r": 255,
                "g": 2,
                "b": 0,
                "s": 10,
                "t": 1
              }
            }
            """)
    }
    // MARK: Helper methods
    
}

extension ViewController: MQTTDelegate {
    
    func mqtt(_ mqtt: MQTT, didConnect: Bool) {
        connectButton.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        connectButton.setTitle("Disconnect", for: .normal)
    }
    
    func mqtt(_ mqtt: MQTT, didDisconnect: Bool) {
        connectButton.backgroundColor = .white
        connectButton.setTitle("Connect", for: .normal)
    }
    
}

