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
    
    @IBOutlet weak var languageMenu: NSMenuItem!
    

    @IBAction func languageClicked(_ sender: NSMenuItem) {
        print("you clicked language")
    }


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let ud = UserDefaults.standard
        ud.register(defaults: C.defaultPrefValues)
        
        if ud.string(forKey: "language") == "" { ud.setValue("English", forKey: "language") }
    }
    
    

    


    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

