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
         loadDictionaryFromPrefs()
        }
    }
    
    func loadDictionaryFromPrefs(){
        if let languageCode = NSUserDefaults.standardUserDefaults().stringForKey("editorLanguage") {
            readWordsForLanguage(languageCode)
        }

    }
    
    func getFilenameForLanguageCode(languageCode:String) -> String {
        return "\(languageCode).txt" // if we decide to show a more human readable name, this func will be the place
    }
    
    func isSimpleWord(word:String) -> Bool {
        getArray()
        if allWords.contains(word.lowercaseString) {
            return true
        }
        return false
    }
    
    func readWordsForLanguage(languageCode:String = "en"){
        let fileName = getFilenameForLanguageCode(languageCode)
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "")!
        do {
            let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            self.allWords = text.componentsSeparatedByString("\n")
        } catch {
            print("read didn't work")
            return
        }
    }
}
