//
//  SimpleWords.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/22/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class SimpleWords: NSObject {
    var allWords = [String]()
    
    func getArray(){
        if allWords.count < 1 {
            readAllWords()
        }
    }
    
    func simpleWord(word:String) -> Bool {
        getArray()
        if allWords.contains(word.lowercaseString) {
            return true
        }
        return false
    }
    
    func readAllWords(){
        let path = NSBundle.mainBundle().pathForResource("simplewords", ofType: "txt")!
        do {
            let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            self.allWords = text.componentsSeparatedByString("\n")
        } catch {
            print("read didn't work")
            return
        }
    }
}
