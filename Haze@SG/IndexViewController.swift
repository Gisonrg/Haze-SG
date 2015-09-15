//
//  IndexViewController.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 14/9/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Cocoa

class IndexViewController: NSViewController {
    override func viewDidLoad() {
        ApiManager.getData { (data, error) -> Void in
            if error != nil {
                println(error)
            } else {
                if let psiData = data {
                    println(psiData)
                }
            }
        }
    }
}

// MARK: Actions

extension IndexViewController {

}