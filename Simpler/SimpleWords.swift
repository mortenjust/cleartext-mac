//
//  SimpleWords.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/22/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class SimpleWords: NSObject {
    private var allWords = [String]()
    private var languageCode = "English"
    static let sharedInstance = SimpleWords()

    private func getArray() {
        if allWords.count < 1 {
            loadDictionaryFromPrefs()
        }
    }

    func loadDictionaryForCode(code: String) {
        readWordsForLanguage(code)
    }

    private func loadDictionaryFromPrefs() {
        if let languageCode = NSUserDefaults.standardUserDefaults().stringForKey("language") {
            print("reading words for \(languageCode)")
            readWordsForLanguage(languageCode)
        }
    }

    private func getFilenameForLanguageCode(languageCode: String) -> String {
        return "\(languageCode).txt" // if we decide to show a more human readable name, this func will be the place
    }

    func isSimpleWord(word: String) -> Bool {
        // print("checking \(word)")

        // simple check first: One-letter words, numbers, contractions, go!
        if word.characters.count == 1 { return true }
        if word.characters.contains("'") { return true }
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        if digits.longCharacterIsMember((word.unicodeScalars.first?.value)!) {
            return true
        }

        if String(word.characters.first!).rangeOfCharacterFromSet(NSCharacterSet.uppercaseLetterCharacterSet()) != nil {
            return true
        }

        // print("not simple, using dictionary")

        getArray()

        return allWords.contains(word.lowercaseString)
    }

    private func readWordsForLanguage(languageCode: String = "English") {
        print("loading file for \(languageCode)")
        self.languageCode = languageCode
        let fileName = getFilenameForLanguageCode(languageCode)
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "")!
        do {
            let text = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            allWords = text.componentsSeparatedByString("\n")
        } catch {
            print("read didn't work")
            return
        }
    }

}
