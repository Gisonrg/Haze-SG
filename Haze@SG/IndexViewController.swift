//
//  IndexViewController.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 14/9/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Cocoa
import ServiceManagement

class IndexViewController: NSViewController {
    
    @IBOutlet weak var psiTypeLabel: NSTextField!
    @IBOutlet weak var nationalReadingLabel: NSTextField!
    @IBOutlet weak var healthLevelView: NSView!
    @IBOutlet weak var northLabel: NSTextField!
    @IBOutlet weak var westLabel: NSTextField!
    @IBOutlet weak var centralLabel: NSTextField!
    @IBOutlet weak var southLabel: NSTextField!
    @IBOutlet weak var eastLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var healthLevelLabel: NSTextField!
    @IBOutlet weak var refreshButton: NSButton!
    @IBOutlet weak var settingButton: NSButton!
    
    @IBOutlet weak var northTitle: NSTextField!
    @IBOutlet weak var westTitle: NSTextField!
    @IBOutlet weak var centralLTitle: NSTextField!
    @IBOutlet weak var eastTitle: NSTextField!
    @IBOutlet weak var southTitle: NSTextField!

    
    private let spinner = NSProgressIndicator()
    
    var currentPsiData: PsiData?
    var statusBarItem: NSStatusBarButton?
    
    override func viewDidLoad() {
        self.view.wantsLayer = true
        self.healthLevelView.wantsLayer = true
        
        // load fonts
        setUpFont()
        
        // configure spinner
        spinner.style = .SpinningStyle
        spinner.frame = self.view.frame
        
        // add a line separator
        let lineView = NSView(frame: CGRect(x: 0, y: 220, width: self.view.frame.width, height: 2))
        lineView.wantsLayer = true
        lineView.layer?.backgroundColor = NSColor.whiteColor().CGColor
        self.view.addSubview(lineView)
        
        // configure button
        refreshButton.target = self
        refreshButton.action = "refreshDataHandler:"
        
        // configure context menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Start when login", action: "showSettingMenu:", keyEquivalent: ""))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit", action: Selector("terminate:"), keyEquivalent: "q"))
        settingButton.menu = menu
        
        let gestureRecognizer = NSClickGestureRecognizer(target: self, action: "togglePsiType:")
        gestureRecognizer.numberOfClicksRequired = 1
        nationalReadingLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear() {
        if let data = currentPsiData {
            spinner.stopAnimation(self)
            changeBackgroundColor(AppColor.colorForPsi(data.getNationalReading().toDouble()))
            updateDisplay(data)
        } else {
            // No cached data, initializtion data receiving
            // Display the spinner
            self.view.addSubview(spinner)
            spinner.startAnimation(self)
            
            getPsiData()
            changeBackgroundColor(AppColor.backgroundColor)
        }
        
        let currentType = AppConstant.getDefaultReadingType()!
        psiTypeLabel.stringValue = currentType.title()
        
        if (applicationIsInStartUpItems()) {
            settingButton.menu?.itemAtIndex(0)?.state = NSOnState
        } else {
            settingButton.menu?.itemAtIndex(0)?.state = NSOffState
        }
    }
    
    func setUpFont() {
        // Add fonts to all labels (limitation to the os x)
        healthLevelLabel.font = NSFont(name: "OpenSans-Light", size: 30)
        psiTypeLabel.font = NSFont(name: "OpenSans-Light", size: 25)
        nationalReadingLabel.font = NSFont(name: "OpenSans-Light", size: 130)
        
        northTitle.font = NSFont(name: "OpenSans-Light", size: 17)
        westTitle.font = NSFont(name: "OpenSans-Light", size: 17)
        centralLTitle.font = NSFont(name: "OpenSans-Light", size: 17)
        southTitle.font = NSFont(name: "OpenSans-Light", size: 17)
        eastTitle.font = NSFont(name: "OpenSans-Light", size: 17)
        
        northLabel.font = NSFont(name: "OpenSans", size: 28)
        westLabel.font = NSFont(name: "OpenSans", size: 28)
        centralLabel.font = NSFont(name: "OpenSans", size: 28)
        southLabel.font = NSFont(name: "OpenSans", size: 28)
        eastLabel.font = NSFont(name: "OpenSans", size: 28)
        
        timeLabel.font = NSFont(name: "OpenSans-Light", size: 11)
    }
    
    func togglePsiType(sender: AnyObject?) {
        // update the reading type.
        var currentType = AppConstant.getDefaultReadingType()!
        currentType.toggle() // toggle type value
        NSUserDefaults.standardUserDefaults().setValue(currentType.rawValue, forKey: AppConstant.keyForReadingType)
        psiTypeLabel.stringValue = currentType.title()
        if let data = currentPsiData {
            spinner.stopAnimation(self)
            changeBackgroundColor(AppColor.colorForPsi(data.getNationalReading().toDouble()))
            updateDisplay(data)
        }
    }
    
    func refreshDataHandler(sender: AnyObject?) {
        getPsiData()
    }
    
    func showSettingMenu(sender: AnyObject?) {
        let menuItem = sender as! NSMenuItem
        toggleLaunchAtStartup()
        if (applicationIsInStartUpItems()) {
            menuItem.state = NSOnState
        } else {
            menuItem.state = NSOffState
        }
    }
    
    private func getPsiData() {
        ApiManager.getData { (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                guard error == nil else {
                    self.displayAlert("Oops...", details: AppConstant.error_message_network)
                    return
                }
                
                guard let psiData = data else {
                    self.displayAlert("Oops...", details: AppConstant.error_message_data)
                    return
                }
                
                self.updateDisplay(psiData)
            }
        }
    }
    
    private func updateDisplay(data: PsiData) {
        self.spinner.stopAnimation(self)
        self.spinner.removeFromSuperview()
        currentPsiData = data
        
        let type = AppConstant.getDefaultReadingType()!
        
        for reading in data.readings {
            switch(reading.region) {
                case .North:
                    northLabel.stringValue = reading.getReading(type)
                case .South:
                    southLabel.stringValue = reading.getReading(type)
                case .West:
                    westLabel.stringValue = reading.getReading(type)
                case .East:
                    eastLabel.stringValue = reading.getReading(type)
                case .Central:
                    centralLabel.stringValue = reading.getReading(type)
                case .National:
                    let displayValue = reading.getReading(type)
                    nationalReadingLabel.stringValue = displayValue
                    // Update status bar display
                    if let button = statusBarItem {
                        button.image = nil
                        let attributes = AppConstant.statusBarItemAttributeForValue(displayValue)
                        button.attributedTitle = NSMutableAttributedString(string: displayValue, attributes: attributes)
                    }
                    // change background color as the PSI level
                    changeBackgroundColor(AppColor.colorForPsi(displayValue.toDouble()))
                
                    // update health level label as the PSI level
                    healthLevelLabel.stringValue = AppConstant.healthLevelForPsi(displayValue.toDouble())
            }
        }
        
        // update time label
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd hh:mm a"
        formatter.timeZone = NSTimeZone.localTimeZone()
        let time = formatter.stringFromDate(data.updatedTime)
        timeLabel.stringValue = "Updated on \(time)"
    }
    
    private func changeBackgroundColor(color: NSColor) {
        CATransaction.begin()
        let anime = CABasicAnimation(keyPath: "backgroundColor")
        
        anime.fromValue = self.view.layer?.backgroundColor
        anime.toValue = color.CGColor
        anime.duration = 0.2
        anime.autoreverses = false
        anime.delegate = self
        CATransaction.setCompletionBlock { () -> Void in
            self.view.layer?.backgroundColor = color.CGColor
        }
        self.view.layer?.addAnimation(anime, forKey: "backgroundColor")
        CATransaction.commit()
        
    }
    
    private func displayAlert(title:String, details:String) {
        let alert = NSAlert()
        alert.alertStyle = NSAlertStyle.WarningAlertStyle
        alert.messageText = title
        alert.informativeText = details
        alert.runModal()
    }
}
