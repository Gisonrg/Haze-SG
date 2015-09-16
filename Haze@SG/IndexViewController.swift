//
//  IndexViewController.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 14/9/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Cocoa

class IndexViewController: NSViewController {
    
    @IBOutlet weak var nationalReadingLabel: NSTextField!
    @IBOutlet weak var healthLevelView: NSView!
    @IBOutlet weak var northLabel: NSTextField!
    @IBOutlet weak var westLabel: NSTextField!
    @IBOutlet weak var centralLabel: NSTextField!
    @IBOutlet weak var southLabel: NSTextField!
    @IBOutlet weak var eastLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var healthLevelLabel: NSTextField!
    
    private let spinner = NSProgressIndicator()
    
    var currentPsiData: PsiData?
    var statusBarItem: NSStatusBarButton?
    
    override func viewDidLoad() {
        self.view.wantsLayer = true
        self.healthLevelView.wantsLayer = true
        
        // configure spinner
        spinner.style = .SpinningStyle
        spinner.frame = self.view.frame
        
        // add a line separator
        let lineView = NSView(frame: CGRect(x: 0, y: 220, width: self.view.frame.width, height: 2))
        lineView.wantsLayer = true
        lineView.layer?.backgroundColor = NSColor.whiteColor().CGColor
        self.view.addSubview(lineView)
    }
    
    override func viewWillAppear() {
        if let data = currentPsiData {
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
    }
    
    private func getPsiData() {
        ApiManager.getData { (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    self.displayAlert("Oops...", details: AppConstant.error_message_network)
                } else {
                    if let psiData = data {
                        self.spinner.stopAnimation(self)
                        self.spinner.removeFromSuperview()
                        self.updateDisplay(psiData)
                    }
                }
            }
        }
    }
    
    private func updateDisplay(data: PsiData) {
        currentPsiData = data
        for reading in data.readings {
            switch(reading.region) {
                case .North:
                    northLabel.stringValue = reading.get24HrsPsi()
                case .South:
                    southLabel.stringValue = reading.get24HrsPsi()
                case .West:
                    westLabel.stringValue = reading.get24HrsPsi()
                case .East:
                    eastLabel.stringValue = reading.get24HrsPsi()
                case .Central:
                    centralLabel.stringValue = reading.get24HrsPsi()
                case .National:
                    let displayValue = reading.get24HrsPsi()
                    nationalReadingLabel.stringValue = displayValue
                    // Update status bar display
                    if let button = statusBarItem {
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
        formatter.dateFormat = "MM-dd hh:mm"
        formatter.timeZone = NSTimeZone.localTimeZone()
        let time = formatter.stringFromDate(data.updatedTime)
        timeLabel.stringValue = "Updated on \(time)"
    }
    
    private func changeBackgroundColor(color: NSColor) {
        self.view.layer?.backgroundColor = color.CGColor
    }
    
    private func displayAlert(title:String, details:String) {
        let alert = NSAlert()
        alert.alertStyle = NSAlertStyle.WarningAlertStyle
        alert.messageText = title
        alert.informativeText = details
        alert.runModal()
    }
}
