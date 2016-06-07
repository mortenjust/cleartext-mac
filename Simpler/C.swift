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
    static let editorFont = NSFont(name: "Avenir Next", size: 23)
    
    static let editorAtts:[String:AnyObject] = [
        NSFontNameAttribute : C.editorFont!,
        NSForegroundColorAttributeName : C.editorTextColor,
        NSBackgroundColorAttributeName : C.editorBackgroundColor
    ]

    static let PREF_MAKESOUND = "makeSound"
    static let PREF_FORCESELECT = "forceSelect"
    static let defaultPrefValues = [
        "makeSound":true,
        "forceSelect":true,
        "language":"English"
    ]

    static let languages = [
        Language(code: "English", name: "English"),
        Language(code: "Español", name: "Español"),
        Language(code: "Čeština", name: "Čeština"),
        Language(code: "Français", name: "Français"),
        Language(code: "Português", name: "Português"),
        Language(code: "Deutsch", name: "Deutsch"),
        Language(code: "Italiano", name: "Italiano"),
        Language(code: "Nederlands", name: "Nederlands"),
        Language(code: "Norsk", name: "Norsk"),
        Language(code: "Dansk", name: "Dansk"),
        Language(code: "Suomi", name: "Suomi"),
        Language(code: "Svenska", name: "Svenska"),
        Language(code: "Íslenska", name: "Íslenska"),
        Language(code: "Italiano", name: "Italiano"),
        Language(code: "Shqip", name: "Shqip"),
        Language(code: "Hrvatski", name: "Hrvatski"),
        Language(code: "Srpski", name: "Srpski"),
        Language(code: "Bahasa", name: "Bahasa"),
        Language(code: "русский", name: "русский"),
        Language(code: "Trump", name: "Trump"),
        Language(code: "xkcd", name: "xkcd"),
        Language(code: "jobs", name: "jobs"),
        Language(code: "hemingway", name: "hemingway"),        
    ]
    
    
//    
//    font = NSFont(name: "Avenir Next", size: 23)
//    backgroundColor = C.editorBackgroundColor
//    textColor = C.editorTextColor
//    
    
}
