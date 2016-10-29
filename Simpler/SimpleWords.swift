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
    var languageCode = "English"
    static let sharedInstance = SimpleWords()
    
    func getArray(){
        if allWords.count < 1 {
         loadDictionaryFromPrefs()
        }
    }

    func loadDictionaryForCode(_ code:String){
        readWordsForLanguage(code)
    }
    
    func loadDictionaryFromPrefs(){
        if let languageCode = UserDefaults.standard.string(forKey: "language") {
            print("reading words for \(languageCode)")
            readWordsForLanguage(languageCode)
        }
    }
    
    func getFilenameForLanguageCode(_ languageCode:String) -> String {
        return "\(languageCode).txt" // if we decide to show a more human readable name, this func will be the place
    }
    
    func isSimpleWord(_ word:String) -> Bool {
//        print("checking \(word)")
        
        // simple check first: One-letter words, numbers, contractions, go!
        if word.characters.count == 1 { return true }
        if word.characters.contains("'") { return true }
        let digits = CharacterSet.decimalDigits
        if digits.contains(UnicodeScalar((word.unicodeScalars.first?.value)!)!) {
            return true
        }
        if String(word.characters.first!).rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil
        {return true}
        
//        print("not simple, using dictionary")
        
        getArray()
        
        if allWords.contains(word.lowercased()) {
            return true
        }
        
        return false
    }
    
    func readWordsForLanguage(_ languageCode:String = "English"){
        print("loading file for \(languageCode)")
        self.languageCode = languageCode
        let fileName = getFilenameForLanguageCode(languageCode)
        
        let path = Bundle.main.path(forResource: fileName, ofType: "")!
        do {
            let text = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            self.allWords = text.components(separatedBy: "\n")
        } catch {
            print("read didn't work")
            return
        }
    }
    
    
}
