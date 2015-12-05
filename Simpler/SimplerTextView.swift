//
//  SimplerTextView.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/21/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa
import Quartz

protocol SimplerTextViewDelegate {
    func simplerTextViewKeyUp(character:String)
    func simplerTextViewGotComplexWord()
}

class SimplerTextView: NSTextView, SimplerTextStorageDelegate {
    var simplerDelegate:SimplerTextViewDelegate!
    var simplerStorage: SimplerTextStorage!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        resetFormatting()
        simplerStorage = SimplerTextStorage()
        simplerStorage.simpleDelegate = self
        simplerStorage.layoutManager = layoutManager!
        
        layoutManager?.replaceTextStorage(simplerStorage)
        wantsLayer = true
    }
    
    
    
    func simplerTextStorageGotComplexWordAtRange(range:NSRange) {
        Swift.print("setting range to \(range)")
        simplerDelegate.simplerTextViewGotComplexWord()
    }
    
    func simplerTextStorageShouldChangeAtts(atts: [String : AnyObject]) {
        resetFormatting()
    }
    
    func resetFormatting(){
        font = C.editorFont
        backgroundColor = C.editorBackgroundColor
        textColor = C.editorTextColor
    }
    
    override func didChangeText() {
        super.didChangeText()
        resetFormatting()
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        // Drawing code here.
    }
}
