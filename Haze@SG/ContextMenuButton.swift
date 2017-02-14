//
//  ContextMenuButton.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 20/9/15.
//  Copyright © 2015 Gisonrg. All rights reserved.
//

import Cocoa

class ContextMenuButton: NSButton {
    
    override func mouseDown(with theEvent: NSEvent) {
        self.highlight(true)
        self.state = NSOnState
        if let menu = self.menu {
            NSMenu.popUpContextMenu(menu, with: theEvent, for: self)
        }
        self.state = NSOffState
        self.highlight(false)
    }
    
}
