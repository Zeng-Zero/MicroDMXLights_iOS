//
//  MQTT.swift
//  MIcroDMXLights
//
//  Created by adrian.szymanowski on 26/02/2020.
//  Copyright © 2020 adrian.szymanowski. All rights reserved.
//

import Foundation
import CocoaMQTT

protocol MQTTDelegate: class {
    // TODO: Refactor methods to simpler version
    func mqtt(_ mqtt: MQTT, didConnect: Bool)
    func mqtt(_ mqtt: MQTT, didDisconnect: Bool)
}

class MQTT {
    
    var instance: CocoaMQTT
    var isConnected: Bool = false
    
    weak var delegate: MQTTDelegate?
    
    
    init(id: String, host: String = "localhost", port: UInt16 = 1883) {
        instance = CocoaMQTT.init(clientID: id,
                                  host: host,
                                  port: port)
    }
    
    func configure(username: String? = nil, password: String? = nil, topic: String) {
        if let u = username {
            instance.username = u
        }
        
        if let p = password {
            instance.password = p
        }
        
        instance.willMessage = CocoaMQTTMessage.init(topic: topic, string: "dmx")
        instance.keepAlive = 60
        instance.delegate = self
    }
    
    func connect() {
        instance.connect()
    }
    
    func disconnect() {
        instance.disconnect()
    }
    
    func interfaceNames() -> [String] {
        let MAX_INTERFACES = 128;
        
        var interfaceNames = [String]()
        let interfaceNamePtr = UnsafeMutablePointer<Int8>.allocate(capacity: Int(Int(IF_NAMESIZE)))
        for interfaceIndex in 1...MAX_INTERFACES {
            if (if_indextoname(UInt32(interfaceIndex), interfaceNamePtr) != nil){
                let interfaceName = String(cString: interfaceNamePtr)
                interfaceNames.append(interfaceName)
            } else {
                break
            }
        }
        
        interfaceNamePtr.deallocate()
        return interfaceNames
    }
    
}

extension MQTT: CocoaMQTTDelegate {

    
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        isConnected = true
        delegate?.mqtt(self, didConnect: true)
        print("didConnectAck")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didReceiveMessage")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
            print("didSubscribeTopics")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
           print("didUnsubscribeTopics")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("mqttDidPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("mqttDidReceivePong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        isConnected = false
        delegate?.mqtt(self, didDisconnect: true)
        print("mqttDidDisconnect")
    }
    
}
