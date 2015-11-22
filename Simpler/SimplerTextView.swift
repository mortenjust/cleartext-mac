//
//  SimplerTextView.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/21/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class SimplerTextView: NSTextView {
    var simpleWords = SimpleWords()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        font = NSFont(name: "Avenir Next", size: 23)
        backgroundColor = NSColor(red:0.090, green:0.149, blue:0.220, alpha:1)
        textColor = NSColor(red:1, green:1, blue:1, alpha:1)
        insertionPointColor = NSColor(red:1, green:1, blue:1, alpha:1)
    }
    

    
    override func keyUp(theEvent: NSEvent) {
        theEvent.keyCode
        if theEvent.characters == " " {
            checkLastWord()
        }
    }
    
    func checkLastWord(){
        let storage = textStorage?.string
        let words = storage!.characters.split{$0 == " "}.map(String.init)
        if let lastWord = words.last {
            checkWord(lastWord)
            }
    }
    
    func checkWord(word:String){
        var w = word.stringByReplacingOccurrencesOfString(".", withString: "")
        w = w.stringByReplacingOccurrencesOfString(",", withString: "")
        
        if simpleWords.simpleWord(w){
            Swift.print("\(w) is simple")
        } else {
            Swift.print("\(w) is complex, deeeye")
            string = textStorage?.string.stringByReplacingOccurrencesOfString(" \(w)", withString: "")
        }
    }
    
    
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Drawing code here.
    }
}
