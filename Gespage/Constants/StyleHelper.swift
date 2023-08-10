//
//  StyleHelper.swift
//  Gespage
//
//  Created by Duy Pham on 10/08/2023.
//

import UIKit

class StyleHelper {
    static func commonLayer(layer: CALayer) {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.1
    }
}
