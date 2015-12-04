//
//  C.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/23/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

struct Language {
    var code:String
    var name:String
}

class C: NSObject {
    static let editorBackgroundColor = NSColor(red:0.988, green:0.988, blue:0.980, alpha:1)
    static let editorTextColor = NSColor(red:0.349, green:0.349, blue:0.314, alpha:1)
    static let canvasBackgroundColor = NSColor(red:0.988, green:0.988, blue:0.980, alpha:1)
    static let languageItemColor = NSColor(red:0.745, green:0.741, blue:0.749, alpha:1)
    
    static let PREF_MAKESOUND = "makeSound"
    static let PREF_REMOVEIMMEDIATELY = "removeImmediately"
    static let defaultPrefValues = [
        "makeSound":true,
        "removeImmediately":true,
        "language":"en"
    ]

    static let languages = [
        Language(code: "da", name: "da"),
        Language(code: "en", name: "en"),
        Language(code: "nl", name: "nl"),
        Language(code: "xkcd", name: "xkcd")
    ]
}
