//
//  LaunchStarter.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 20/9/15.
//  Copyright © 2015 Gisonrg. All rights reserved.
//

import Foundation

//func applicationIsInStartUpItems() -> Bool {
//    return (itemReferencesInLoginItems().existingReference != nil)
//}

//func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
//
//    if let appUrl : URL = URL(fileURLWithPath: Bundle.main.bundlePath) {
//        let loginItemsRef = LSSharedFileListCreate(
//            nil,
//            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
//            nil
//            ).takeRetainedValue() as LSSharedFileList?
//        if loginItemsRef != nil {
//            let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
//            if(loginItems.count > 0)
//            {
//                let lastItemRef: LSSharedFileListItem = loginItems.lastObject as! LSSharedFileListItem
//                for i in 0 ..< loginItems.count += 1 {
//                    let currentItemRef: LSSharedFileListItem = loginItems.object(at: i) as! LSSharedFileListItemRef
//                    if let itemURL = LSSharedFileListItemCopyResolvedURL(currentItemRef, 0, nil) {
//                        if (itemURL.takeRetainedValue() as URL) == appUrl {
//                            return (currentItemRef, lastItemRef)
//                        }
//                    }
//                }
//                
//                //The application was not found in the startup list
//                return (nil, lastItemRef)
//            } else {
//                let addatstart: LSSharedFileListItem = kLSSharedFileListItemBeforeFirst.takeRetainedValue()
//                return(nil,addatstart)
//            }
//        }
//    }
//    return (nil, nil)
//}

//func toggleLaunchAtStartup() {
//    let itemReferences = itemReferencesInLoginItems()
//    let shouldBeToggled = (itemReferences.existingReference == nil)
//    if let loginItemsRef = LSSharedFileListCreate( nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileList? {
//        if shouldBeToggled {
//            if let appUrl : CFURL = URL(fileURLWithPath: Bundle.main.bundlePath) as CFURL? {
//                LSSharedFileListInsertItemURL(loginItemsRef, itemReferences.lastReference, nil, nil, appUrl, nil, nil)
//            }
//        } else {
//            if let itemRef = itemReferences.existingReference {
//                LSSharedFileListItemRemove(loginItemsRef,itemRef);
//            }
//        }
//    }
//}
