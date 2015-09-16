//
//  AppDelegate.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 14/9/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let popover = NSPopover()
    let indexController = IndexViewController(nibName: "IndexViewController", bundle: nil)!
    
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(notification: NSNotification) {
        if let button = statusItem.button {
            button.action = Selector("togglePopover:")
        }

        popover.contentViewController = indexController
        indexController.statusBarItem = statusItem.button
        
        eventMonitor = EventMonitor(mask: .LeftMouseDownMask | .RightMouseDownMask) { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
        initStatusBarItemApperance()
    }
    
    func initStatusBarItemApperance() {
        ApiManager.getData { (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if let psiData = data {
                    self.indexController.currentPsiData = data
                    let displayValue = psiData.getNationalReading()
                    if let button = self.statusItem.button {
                        let attributes = AppConstant.statusBarItemAttributeForValue(displayValue)
                        button.attributedTitle = NSMutableAttributedString(string: displayValue, attributes: attributes)
                    }
                }
            }
        }
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSMinYEdge)
            eventMonitor?.start()
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

}

