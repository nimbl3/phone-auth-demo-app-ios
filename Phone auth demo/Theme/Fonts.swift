//
//  Font.swift
//  Phone auth demo
//
//  Created by Pirush Prechathavanich on 1/19/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import UIKit

enum FontWeight: String {
    
    case regular, demiBold, medium, bold
    
}

extension UIFont {
    
    static func avenirNext(_ fontWeight: FontWeight = .regular, size: CGFloat) -> UIFont {
        return UIFont(name: avenirNext(for: fontWeight), size: size)!
    }
    
    static private func avenirNext(for fontWeight: FontWeight) -> String {
        return "AvenirNext-\(fontWeight.rawValue.capitalized)"
    }
    
}
