//
//  UIColor+RGB.swift
//  MicroDMXLights
//
//  Created by adrian.szymanowski on 29/02/2020.
//  Copyright © 2020 adrian.szymanowski. All rights reserved.
//

import UIKit

extension UIColor {
    enum RGB: Int {
        case red = 0
        case green
        case blue
        
        var color: UIColor {
            switch self {
            case .red:
                return .red
            case .green:
                return .green
            case .blue:
                return .blue
            }
        }
    }
}
