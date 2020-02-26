//
//  CustomButton.swift
//  MIcroDMXLights
//
//  Created by adrian.szymanowski on 26/02/2020.
//  Copyright © 2020 adrian.szymanowski. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 16.0
        setTitleColor(.darkGray, for: .normal)
        backgroundColor = .white
        contentEdgeInsets = .init(top: 0, left: 44, bottom: 0, right: 44)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
