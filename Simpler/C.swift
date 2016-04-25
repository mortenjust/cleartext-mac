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
        Language(code: "Español (Spanish)", name: "Español (Spanish)"),
        Language(code: "Français (French)", name: "Français (French)"),
        Language(code: "Português (Portuguese)", name: "Português (Portuguese)"),
        Language(code: "Deutsch (German)", name: "Deutsch (German)"),
        Language(code: "Italiano (Italian)", name: "Italiano (Italian)"),
        Language(code: "Nederlands (Dutch)", name: "Nederlands (Dutch)"),
        Language(code: "Dansk (Danish)", name: "Dansk (Danish)"),
        Language(code: "Suomi (Finnish)", name: "Suomi (Finnish)"),
        Language(code: "Svenska (Swedish)", name: "Svenska (Swedish)"),
        Language(code: "Íslenska (Icelandic)", name: "Íslenska (Icelandic)"),
        Language(code: "Čeština (Czech)", name: "Čeština (Czech)"),
        Language(code: "Shqip (Albanian)", name: "Shqip (Albanian)"),
        Language(code: "Hrvatski (Croatian)", name: "Hrvatski (Croatian)"),
        Language(code: "Srpski (Serbian)", name: "Srpski (Serbian)"),
        Language(code: "Bahasa (Indonesian)", name: "Bahasa (Indonesian)"),
        Language(code: "Trump", name: "Trump"),
        Language(code: "xkcd", name: "xkcd"),
        Language(code: "Jobs", name: "Jobs"),
        Language(code: "Hemingway", name: "Hemingway"),
    ]
    
    
//    
//    font = NSFont(name: "Avenir Next", size: 23)
//    backgroundColor = C.editorBackgroundColor
//    textColor = C.editorTextColor
//    
    
}
