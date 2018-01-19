//
//  Colors.swift
//  Phone auth demo
//
//  Created by Pirush Prechathavanich on 1/19/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red)/255.0,
                  green: CGFloat(green)/255.0,
                  blue: CGFloat(blue)/255.0,
                  alpha: 1.0)
    }
    
    static let clouds = UIColor(236, 240, 241)
    static let midnightBlue = UIColor(44, 62, 80)
    static let wetAsphalt = UIColor(52, 73, 94)
    
    static let peterRiver = UIColor(52, 152, 219)
    static let alizarin = UIColor(231, 76, 60)
    static let carrot = UIColor(230, 126, 34)
    
}
