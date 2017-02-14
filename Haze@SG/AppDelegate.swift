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
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()
    let indexController = IndexViewController(nibName: "IndexViewController", bundle: nil)!
    
    var reach: Reachability?
    var timer: Timer?
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ notification: Notification) {
        if let button = statusItem.button {
            button.action = #selector(AppDelegate.togglePopover(_:))
        }

        popover.contentViewController = indexController
        indexController.statusBarItem = statusItem.button
       
        eventMonitor = EventMonitor(mask:  NSEventMask.leftMouseDown.union(NSEventMask.rightMouseDown) ) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
        
//        // Reachability setup
//        self.reach = Reachability.forInternetConnection()
//        
//        // Set the blocks
//        self.reach!.reachableBlock = {
//            (reach: Reachability!) -> Void in
//            
//            self.getDataAndChangeApperance()
//        }
//        self.reach!.unreachableBlock = {
//            (reach: Reachability!) -> Void in
//            self.clearButtonApperance()
//        }
//        self.reach!.startNotifier()
        
        // check for default display reading type: 24hrs/3hrs
        // if the default is not set, set and use 24hrs.
        if AppConstant.getDefaultReadingType() == nil {
            UserDefaults.standard.setValue(ReadingType.Psi24hrs.rawValue, forKey: AppConstant.keyForReadingType)
        }
        
        // run the timed task to get data
        startScheduledWork()
    }
    
    func startScheduledWork() {
        getDataAndChangeApperance()

        let interval = AppConstant.timedTaskFrequency
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: "getData:", userInfo: nil, repeats: true)
    }
    
    func getData(_ timer: Timer) {
        getDataAndChangeApperance()
    }
    
    func getDataAndChangeApperance() {
        ApiManager.getData { (data, error) -> Void in
            DispatchQueue.main.async {
                if let psiData = data {
                    self.indexController.currentPsiData = data
                    let displayValue = psiData.getNationalReading()
                    if let button = self.statusItem.button {
                        button.image = nil
                        let attributes = AppConstant.statusBarItemAttributeForValue(displayValue)
                        button.attributedTitle = NSMutableAttributedString(string: displayValue, attributes: attributes)
                    }
                } else {
                    // no data received, display icon.
                    self.clearButtonApperance()
                }
            }
        }
    }
    
    func clearButtonApperance() {
        if let button = self.statusItem.button {
            button.image = NSImage(named: "haze")
            button.attributedTitle = NSAttributedString(string: "")
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        timer?.invalidate()
    }
    
    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

}

