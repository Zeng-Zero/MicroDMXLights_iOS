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
    
    @IBOutlet weak var connectButton: CustomButton!
    
    var service = MQTT.init(id: "iOS-" + String(ProcessInfo().processIdentifier))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.delegate = self
        service.configure(topic: "esp8266")
    }

    @IBAction func onConnectTapped(_ sender: UIButton) {
        if service.isConnected {
            service.disconnect()
            UIView.animate(withDuration: 0.5) {
                self.connectButton.backgroundColor = .white
            }
            
        } else {
            service.connect()
            UIView.animate(withDuration: 0.5) {
                let color = UIColor.red.withAlphaComponent(0.2)
                self.connectButton.backgroundColor = color
            }
        }
    }
    
}

extension ViewController: MQTTDelegate {
    
    func mqtt(_ mqtt: MQTT, didConnect: Bool) {
//        connectionIndicatorImageView.image = UIImage.init(systemName: "sun.min.fill")
        UIView.animate(withDuration: 0.5) {
            let color = UIColor.green.withAlphaComponent(0.2)
            self.connectButton.backgroundColor = color
        }
        connectButton.setTitle("Disconnect", for: .normal)
    }
    
    func mqtt(_ mqtt: MQTT, didDisconnect: Bool) {
//        connectionIndicatorImageView.image = UIImage(systemName: "sun.min")
        UIView.animate(withDuration: 0.5) {
            self.connectButton.backgroundColor = .white
        }
        connectButton.setTitle("Connect", for: .normal)
    }
    
}

