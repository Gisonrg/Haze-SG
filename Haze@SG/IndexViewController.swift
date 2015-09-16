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
    
    private let spinner = NSProgressIndicator()
    
    private var currentPsiData: PsiData?
    
    
    var statusBarItem: NSStatusBarButton?
    
    override func viewDidLoad() {
        self.view.wantsLayer = true
        self.healthLevelView.wantsLayer = true
        
        // configure spinner
        spinner.style = .SpinningStyle
        spinner.frame = self.view.frame
        self.view.addSubview(spinner)
        spinner.startAnimation(self)
        
        // initializtion data receiving
        getPsiData()
    }
    
    override func viewWillAppear() {
        self.view.layer?.backgroundColor = AppColor.backgroundColor.CGColor
    }
    
    func getPsiData() {
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
                    nationalReadingLabel.stringValue = reading.get24HrsPsi()
                    // Update status bar display
                    if let button = statusBarItem {
                        let attributes = AppConstant.statusBarItemAttributeForValue(reading.get24HrsPsi())
                        button.attributedTitle = NSMutableAttributedString(string: reading.get24HrsPsi(), attributes: attributes)
                    }
            }
        }
    }
    
    private func displayAlert(title:String, details:String) {
        let alert = NSAlert()
        alert.alertStyle = NSAlertStyle.WarningAlertStyle
        alert.messageText = title
        alert.informativeText = details
        alert.runModal()
    }
}

// MARK: Actions
extension IndexViewController {

}