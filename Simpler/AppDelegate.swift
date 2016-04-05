//
//  AppDelegate.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/21/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.registerDefaults(C.defaultPrefValues)
        
        if ud.stringForKey("language") == "" {
            ud.setValue("English", forKey: "language")
        }
    }

}
