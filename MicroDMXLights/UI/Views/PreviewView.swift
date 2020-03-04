//
//  PreviewView.swift
//  MicroDMXLights
//
//  Created by adrian.szymanowski on 29/02/2020.
//  Copyright © 2020 adrian.szymanowski. All rights reserved.
//

import UIKit

class PreviewView: UIView {
    
    // MARK: Parameters
    private(set) var RGBColors: [CGFloat] = [0, 0, 0]
    
    // MARK: Methods
    func update(with color: UIColor, value: Float) {
        let cgValue = CGFloat(value) / 255
        switch color {
        case .red:
            RGBColors[0] = cgValue
        case .green:
            RGBColors[1] = cgValue
        case .blue:
            RGBColors[2] = cgValue
        default:
            break
        }
        
        backgroundColor = .init(red: RGBColors[0], green: RGBColors[1], blue: RGBColors[2], alpha: 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = bounds.width / 2
    }
    
}
