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
        service.configure(topic: "esp8266")
    }
    
    @IBAction func onSwitchButtonTapped(_ sender: UIButton) {
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
    
    // MARK: Helper methods
    
}

extension ViewController: MQTTDelegate {
    
    func mqtt(_ mqtt: MQTT, didConnect: Bool) {
        UIView.animate(withDuration: 0.5) {
            let color = UIColor.green.withAlphaComponent(0.2)
            self.connectButton.backgroundColor = color
        }
        connectButton.setTitle("Disconnect", for: .normal)
    }
    
    func mqtt(_ mqtt: MQTT, didDisconnect: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.connectButton.backgroundColor = .white
        }
        connectButton.setTitle("Connect", for: .normal)
    }
    
}

