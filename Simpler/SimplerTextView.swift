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
        wantsLayer = true
        simplerStorage = SimplerTextStorage()
        simplerStorage.simpleDelegate = self
        simplerStorage.addLayoutManager(layoutManager!)
        layoutManager?.replaceTextStorage(simplerStorage)

        resetFormatting()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectionDidChange:", name: NSTextViewDidChangeSelectionNotification, object: nil)
    }
    
    func selectionDidChange(n:NSNotification){
        Swift.print("view:selectiondidchange")
        Swift.print("---inwhich the selected range is \(self.selectedRange())")
         simplerStorage.selectionDidChange(self.selectedRange())
    }

    func simplerTextStorageGotComplexWord() {
        simplerDelegate.simplerTextViewGotComplexWord()
        resetSelection()
    }
    
    func resetSelection(){
        setSelectedRange(NSMakeRange(0, 0))
    }

    
    func simplerTextStorageGotComplexWordAtRange(range:NSRange) {
        Swift.print("view:gotcomplexword")
        Swift.print("textview:setting range to \(range)")
        simplerDelegate.simplerTextViewGotComplexWord()
        setSelectedRange(range)
    }
    
    func simplerTextStorageShouldChangeAtts(atts: [String : AnyObject]) {
        Swift.print("view:shouldchangeatts")
        resetFormatting()
    }
    
    override func shouldChangeTextInRange(affectedCharRange: NSRange, replacementString: String?) -> Bool {
        Swift.print("view:shouldChangeTextInRange")
        return true
    }
    
    override func shouldChangeTextInRanges(affectedRanges: [NSValue], replacementStrings: [String]?) -> Bool {
        Swift.print("view:shouldChangeTextInRangeSSSS")
        return true
    }
    
    func resetFormatting(){
        font = C.editorFont
        backgroundColor = C.editorBackgroundColor
        textColor = C.editorTextColor
    }
    
    override func didChangeText() {
        super.didChangeText()
        
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        // Drawing code here.
    }
}
