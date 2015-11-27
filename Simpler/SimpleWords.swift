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
    var languageCode = "en"
    
    func getArray(){
        if allWords.count < 1 {
         loadDictionaryFromPrefs()
        }
    }

    func loadDictionaryForCode(code:String){
        readWordsForLanguage(code)
    }
    
    func loadDictionaryFromPrefs(){
        if let languageCode = NSUserDefaults.standardUserDefaults().stringForKey("language") {
            print("reading words for \(languageCode)")
            readWordsForLanguage(languageCode)
        }
    }
    
    func getFilenameForLanguageCode(languageCode:String) -> String {
        return "\(languageCode).txt" // if we decide to show a more human readable name, this func will be the place
    }
    
    func isSimpleWord(word:String) -> Bool {
        if word.characters.count == 1 { return true }
        getArray()
        if allWords.contains(word.lowercaseString) {
            print("\(word) is simple in \(self.languageCode)")
            return true
        }
        
        print("\(word) is difficult in \(self.languageCode)")
        return false
    }
    
    func readWordsForLanguage(languageCode:String = "en"){
        self.languageCode = languageCode
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
