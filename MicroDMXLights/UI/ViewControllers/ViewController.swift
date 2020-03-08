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
    
    lazy var mqttService = MQTT.init(id: "iOS-" + String(ProcessInfo().processIdentifier))
    lazy var messageService = ESPMessageService.init()
    private var autosend: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mqttService.delegate = self
        mqttService.configure(topic: "esp/example/push")
    }
    
    @IBAction func onSwitchButtonTapped(_ sender: CustomButton) {
        if mqttService.isConnected {
            mqttService.disconnect()
            connectButton.backgroundColor = .white
        } else {
            mqttService.connect()
            connectButton.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        }
    }
    
    @IBAction func autoSendSwitched(_ sender: UISwitch) {
        autosend = sender.isOn
    }
    
    @IBAction func onSliderChange(_ sender: RGBSlider) {
        let oldValue = sender.value
        sender.setValue(sender.value.rounded(.toNearestOrEven), animated: true)
        
        if sender.value != oldValue {
            previewView.update(with: sender.color.color, value: sender.value)
            if autosend {
                composeAndSendMessage()
            }
        }
    }
    
    @IBAction func onSendButtonTapped(_ sender: CustomButton) {
        composeAndSendMessage()
    }
    
    private func composeAndSendMessage() {
        var red: Int = 0
        var green: Int = 0
        var blue: Int = 0
        let saturation: Int = 100
        let channel: Int = 1
        
        let sliders = slidersStackView.arrangedSubviews.compactMap{ $0 as? RGBSlider }
        for slider in sliders {
            switch slider.color {
            case .red:
                red = Int(slider.value)
            case .blue:
                blue = Int(slider.value)
            case .green:
                green = Int(slider.value)
            }
        }
        
        let params = DMXParams.init(b: blue,
                                    g: green,
                                    r: red,
                                    s: saturation,
                                    t: channel)
        messageService.commonMessage = ESPCommonMessage.init(params: params)
        if let jsonMessage = messageService.commonMessage?.composeToJSON() {
            mqttService.sendMessage(jsonMessage)
        }
    }
    
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

