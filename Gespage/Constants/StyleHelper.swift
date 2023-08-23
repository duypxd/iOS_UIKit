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
    
    static func selectorLayer(layer: CALayer) {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "greyG400")?.cgColor
        layer.shadowColor = UIColor.black.cgColor
    }
    
    static func applyCornerRadius(layer: CALayer, corners: UIRectCorner = .allCorners, radius: CGFloat) {
        var cornerMask: CACornerMask = []

        if corners.contains(.topLeft) {
            cornerMask.insert(.layerMinXMinYCorner)
        }

        if corners.contains(.topRight) {
            cornerMask.insert(.layerMaxXMinYCorner)
        }

        if corners.contains(.bottomLeft) {
            cornerMask.insert(.layerMinXMaxYCorner)
        }

        if corners.contains(.bottomRight) {
            cornerMask.insert(.layerMaxXMaxYCorner)
        }

        if cornerMask.isEmpty {
            layer.cornerRadius = 0
        } else {
            layer.maskedCorners = cornerMask
            layer.cornerRadius = radius
            layer.masksToBounds = true
        }
    }

}
