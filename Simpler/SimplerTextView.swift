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
    func simplerTextViewKeyUp(_ character:String)
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
//        simplerStorage.addLayoutManager(layoutManager!)
        layoutManager?.replaceTextStorage(simplerStorage)

        resetFormatting()
        NotificationCenter.default.addObserver(self, selector: #selector(SimplerTextView.selectionDidChange(_:)), name: NSNotification.Name.NSTextViewDidChangeSelection, object: nil)
    }
    
    func selectionDidChange(_ n:Notification){
//        Swift.print("view:selectiondidchange")
//        Swift.print("---inwhich the selected range is \(self.selectedRange())")
         simplerStorage.selectionDidChange(self.selectedRange())
    }

    func simplerTextStorageGotComplexWord() {
        simplerDelegate.simplerTextViewGotComplexWord()

    }
    
    
    func simplerTextStorageGotComplexWordAtRange(_ range:NSRange) {
        //simplerDelegate.simplerTextViewGotComplexWord()
        // so to not duplicate the effect
        
        if(UserDefaults.standard.bool(forKey: C.PREF_FORCESELECT)){
            setSelectedRange(range)
            }
    }
    
    func simplerTextStorageShouldChangeAtts(_ atts: [String : AnyObject]) {
        
    }
    
    override func shouldChangeText(in affectedCharRange: NSRange, replacementString: String?) -> Bool {
        return true
    }
    
    override func shouldChangeText(inRanges affectedRanges: [NSValue], replacementStrings: [String]?) -> Bool {
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
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
}
