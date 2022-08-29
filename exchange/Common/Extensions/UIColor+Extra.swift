//
//  UIColor+Extra.swift
//  exchange
//
//  Created by Sergey Kim on 29.08.2022.
//

import UIKit

public extension UIColor {

    @nonobjc class var mintGreen: UIColor {
        return UIColor(rgb: 0x7FB77E)
    }

    @nonobjc class var cream: UIColor {
        return UIColor(rgb: 0xF7F6DC)
    }

    @nonobjc class var summerRed: UIColor {
        return UIColor(rgb: 0xFFC090)
    }

    @nonobjc class var beidge: UIColor {
        return UIColor(rgb: 0xFDEEDC)
    }

    @nonobjc class var fall: UIColor {
        return UIColor(rgb: 0xE38B29)
    }

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }

    convenience init(rgb: Int, alpha: CGFloat = 1) {
        self.init(
            r: CGFloat((rgb >> 16) & 0xFF),
            g: CGFloat((rgb >> 8) & 0xFF),
            b: CGFloat(rgb & 0xFF),
            alpha: alpha
        )
    }

    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
