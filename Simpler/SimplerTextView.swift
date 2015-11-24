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

class SimplerTextView: NSTextView {
    var simpleWords = SimpleWords()
    var simplerDelegate:SimplerTextViewDelegate!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        font = NSFont(name: "Avenir Next", size: 23)
        backgroundColor = C.editorBackgroundColor
        textColor = C.editorTextColor
//        insertionPointColor = NSColor(red:1, green:1, blue:1, alpha:1)
        wantsLayer = true
        frame.origin.x += 1000
        
    }
    
    override func keyUp(theEvent: NSEvent) {
        if theEvent.characters == " "
            || theEvent.characters == ","
            || theEvent.characters == "."
            || theEvent.characters == "?"
            || theEvent.characters == ";"
        {
            checkDocument(theEvent.characters!)
        }
        
        if theEvent.characters != nil {
            simplerDelegate.simplerTextViewKeyUp(theEvent.characters!)
            }
    }
    
    func checkDocument(trigger:String){
        let storage = textStorage?.string
        let words = storage!.characters.split{$0 == " "}.map(String.init)
        if let word = words.last {
            checkWord(word, trigger: trigger)
        }
    }
    
    func checkWord(word:String, trigger:String){
        var w = word.stringByReplacingOccurrencesOfString(".", withString: "")
        w = w.stringByReplacingOccurrencesOfString(",", withString: "")
        w = w.stringByReplacingOccurrencesOfString("?", withString: "")
        w = w.stringByReplacingOccurrencesOfString(";", withString: "")
        w = w.stringByReplacingOccurrencesOfString("\n", withString: "")
        
        if simpleWords.simpleWord(w){
            Swift.print("\(w) is simple")
        } else {
            Swift.print("\(w) is complex, deeeye")
            // get current selection
            
            
            // do UI stuff in the viewcontroller
            simplerDelegate.simplerTextViewGotComplexWord()
            
            // remove the shit
            
            if NSUserDefaults.standardUserDefaults().boolForKey(C.PREF_REMOVEIMMEDIATELY) {
                self.string = NSString(string: self.string!).stringByReplacingOccurrencesOfString("\(w)\(trigger)", withString:"")
                }
            
            // set current selection
            
        }
    }
    
    
    
    func shake(){        
        simplerDelegate.simplerTextViewGotComplexWord()
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        // Drawing code here.
    }
}
