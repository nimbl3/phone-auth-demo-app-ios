//
//  AdvancedUIManager.swift
//  Phone auth demo
//
//  Created by Pirush Prechathavanich on 1/19/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

import AccountKit

class DemoUIManager: NSObject, AKFUIManager {
    
    func theme() -> AKFTheme? {
        let theme = AKFTheme.default()
        theme.backgroundColor = .midnightBlue
        theme.headerBackgroundColor = .midnightBlue
        theme.inputBorderColor = .midnightBlue
        
        theme.headerTextColor = .white
        theme.inputBackgroundColor = .white
        theme.buttonTextColor = .white
        
        theme.buttonBackgroundColor = .peterRiver
        theme.buttonBorderColor = .peterRiver
        theme.iconColor = .peterRiver
        
        theme.inputTextColor = .wetAsphalt
        theme.titleColor = .wetAsphalt
        theme.textColor = .clouds
        theme.statusBarStyle = .lightContent
        
        return theme
    }
    
}
