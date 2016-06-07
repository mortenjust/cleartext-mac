//
//  SimpleTextStorage.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/29/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

protocol SimplerTextStorageDelegate {
    func simplerTextStorageGotComplexWord()
    func simplerTextStorageGotComplexWordAtRange(range:NSRange)
    func simplerTextStorageShouldChangeAtts(atts:[String:AnyObject])
}

class SimplerTextStorage: NSTextStorage {
    var backingStore = NSMutableAttributedString()
    let checker = SimpleWords()
    var simpleDelegate : SimplerTextStorageDelegate?
//    var layoutManager : NSLayoutManager!
    var currentWord : (word:String, range:NSRange)!
    
    override var string: String {
        return backingStore.string
    }

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init?(pasteboardPropertyList propertyList: AnyObject, ofType type: String) {
        fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
    }
    

    func selectionDidChange(range:NSRange){
//        print("storage:selectionddichange")
    }
    
    override func processEditing() {
        super.processEditing()

        if editedRange.length > 0 && editedRange.location < backingStore.string.characters.count  {
            
            let token = tokenAtIndex(editedRange.location, inString: backingStore.string)
            let word = NSString(string: backingStore.string).substringWithRange(token.range)
            
            if (token.token == NSLinguisticTagWhitespace            // check on spaces
                || token.token == NSLinguisticTagPunctuation)       // check on punctuation like , and .
                && !word.characters.contains("'") {                 // but not on ' like in it's and don't
                if currentWord != nil {
                    performReplacementsForRange(token.range+1)
                }
            } else {
                currentWord = (word: word, token.range) // build it!
            }
        }
    }
    
    func performReplacementsForRange(changedRange: NSRange) {
        let index = changedRange.location-1
        
        if let wordRange = wordRangeAtIndex(index, inString: string) {
            lookForBadWords(wordRange)
            }
    }
    
    func substringForRange(range:NSRange) -> String {
//        print("storagee:substinrgforfrange")
        return String(NSString(string: self.string).substringWithRange(range))
    }
    
    
    func lookForBadWords(range:NSRange){
        let word = NSString(string: string).substringWithRange(range)
        if word.characters.count == 0 { return }
//        let timer = ParkBenchTimer()

        if self.checker.isSimpleWord(word) { // could have sworn these should be the other way around. But actual response is king.
//            processGoodWord(word, atRange: range)
        } else {
            processBadWord(word, atRange: range)
        }
    }
    
    func processBadWord(word:String, atRange range:NSRange){
        simpleDelegate?.simplerTextStorageGotComplexWord()
        simpleDelegate?.simplerTextStorageGotComplexWordAtRange(range)
    }
    
    func processGoodWord(word:String, atRange range:NSRange){
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return backingStore.attributesAtIndex(location, effectiveRange: range)
   }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        beginEditing()
        backingStore.replaceCharactersInRange(range, withString: str)
        edited(.EditedCharacters, range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.EditedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    func tokenAtIndex(index:Int, inString str:NSString) -> (range:NSRange, token:String) {
        let tokenType = NSLinguisticTagSchemeTokenType
        let tagger = NSLinguisticTagger(tagSchemes: [tokenType], options: 0)
        var r : NSRange = NSMakeRange(0, 0)
        tagger.string = str as String
        let tag = tagger.tagAtIndex(index, scheme: tokenType, tokenRange: &r, sentenceRange: nil)
        return(range:r, token:tag!)
    }
    
    
    
    func wordRangeAtIndex(index:Int, inString str:NSString) -> NSRange? {
        let options = (NSLinguisticTaggerOptions.OmitWhitespace.rawValue)
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeTokenType],
                                        options: Int(options))
        
        var r : NSRange = NSMakeRange(0,0)
        tagger.string = str as String
        
        let tag = tagger.tagAtIndex(index, scheme: NSLinguisticTagSchemeTokenType, tokenRange: &r, sentenceRange: nil)

        if tag == NSLinguisticTagWord {
            return r
        } else
        {
            return nil
        }
    }

}
