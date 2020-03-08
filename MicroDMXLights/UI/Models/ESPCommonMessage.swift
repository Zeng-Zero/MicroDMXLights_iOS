//
//  ESPCommonMessage.swift
//  MicroDMXLights
//
//  Created by adrian.szymanowski on 08/03/2020.
//  Copyright © 2020 adrian.szymanowski. All rights reserved.
//

import UIKit

struct ESPCommonMessage: Codable {

    let params: DMXParams
 
    func composeToJSON() -> String {
        let encoder = JSONEncoder.init()
        encoder.outputFormatting = .prettyPrinted
        
        if let result = try? encoder.encode(self) {
            return String.init(decoding: result, as: UTF8.self)
        }
        
        return ""
    }
    
}
