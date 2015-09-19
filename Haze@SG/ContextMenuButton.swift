//
//  ContextMenuButton.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 20/9/15.
//  Copyright © 2015 Gisonrg. All rights reserved.
//

import Cocoa

class ContextMenuButton: NSButton {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.highlight(true)
        self.state = NSOnState
        if let menu = self.menu {
            NSMenu.popUpContextMenu(menu, withEvent: theEvent, forView: self)
        }
        self.state = NSOffState
        self.highlight(false)
    }
    
}
