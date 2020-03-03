//
//  RGBSlider.swift
//  MicroDMXLights
//
//  Created by adrian.szymanowski on 29/02/2020.
//  Copyright © 2020 adrian.szymanowski. All rights reserved.
//

import UIKit

@IBDesignable
class RGBSlider: UISlider {

    var color: UIColor.RGB = .red
    
    @available(*, unavailable, message: "This property is only for IB")
    @IBInspectable
    var colorValue: Int {
        get {
            color.rawValue
        }
        set(index) {
            color = UIColor.RGB.init(rawValue: index) ?? .red
        }
    }
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = color.color
        minimumValue = 0
        maximumValue = 255
        value = maximumValue / 2
    }

}
