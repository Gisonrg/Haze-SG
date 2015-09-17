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
    
    var timer: NSTimer?
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(notification: NSNotification) {
        if let button = statusItem.button {
            button.action = Selector("togglePopover:")
        }

        popover.contentViewController = indexController
        indexController.statusBarItem = statusItem.button
       
        eventMonitor = EventMonitor(mask:  NSEventMask.LeftMouseDownMask.union(NSEventMask.RightMouseDownMask) ) { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
        
        // run the timed task to get data
        startScheduledWork()
    }
    
    func startScheduledWork() {
        getDataAndChangeApperance()

        let interval = AppConstant.timedTaskFrequency
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "getData:", userInfo: nil, repeats: true)
    }
    
    func getData(timer: NSTimer) {
        getDataAndChangeApperance()
    }
    
    func getDataAndChangeApperance() {
        ApiManager.getData { (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if let psiData = data {
                    self.indexController.currentPsiData = data
                    let displayValue = psiData.getNationalReading()
                    if let button = self.statusItem.button {
                        let attributes = AppConstant.statusBarItemAttributeForValue(displayValue)
                        button.attributedTitle = NSMutableAttributedString(string: displayValue, attributes: attributes)
                    }
                } else {
                    print("No data received")
                    // no data received, display icon.
                    if let button = self.statusItem.button {
                        button.image = NSImage(named: "haze")
                    }
                }
            }
        }
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        timer?.invalidate()
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
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

