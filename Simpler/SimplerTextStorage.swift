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
    func simplerTextStorageGotComplexWordAtRange(_ range:NSRange)
    func simplerTextStorageShouldChangeAtts(_ atts:[String:AnyObject])
}

class SimplerTextStorage: NSTextStorage {
    var backingStore = NSMutableAttributedString()
    let checker = SimpleWords()
    var simpleDelegate : SimplerTextStorageDelegate?
//    var layoutManager : NSLayoutManager!
    
    override var string: String {
        return backingStore.string
    }

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init?(pasteboardPropertyList propertyList: Any, ofType type: String) {
        fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
    }
    

    func selectionDidChange(_ range:NSRange){
//        print("storage:selectionddichange")
    }
    
    override func processEditing() {
        super.processEditing()

        if editedRange.length > 0 && editedRange.location < backingStore.string.characters.count  {
            
            let token = tokenAtIndex(editedRange.location, inString: backingStore.string as NSString)
            let word = NSString(string: backingStore.string).substring(with: token.range)
            
            if (token.token == NSLinguisticTagWhitespace            // check on spaces
                || token.token == NSLinguisticTagPunctuation)       // check on punctuation like , and .
                && !word.characters.contains("'") {                 // but not on ' like in it's and don't
                    performReplacementsForRange(token.range)
            }
        }
    }
    
    func performReplacementsForRange(_ changedRange: NSRange) {
        let index = changedRange.location-1
        if index>=0 {
            if let wordRange = wordRangeAtIndex(index, inString: string as NSString) {
                lookForBadWords(wordRange)
            }
        }
    }
    
    func substringForRange(_ range:NSRange) -> String {
//        print("storagee:substinrgforfrange")
        return String(NSString(string: self.string).substring(with: range))
    }
    
    
    func lookForBadWords(_ range:NSRange){
        let word = NSString(string: string).substring(with: range)
        if word.characters.count == 0 { return }
//        let timer = ParkBenchTimer()

        if self.checker.isSimpleWord(word) { // could have sworn these should be the other way around. But actual response is king.
//            processGoodWord(word, atRange: range)
        } else {
            processBadWord(word, atRange: range)
        }
    }
    
    func processBadWord(_ word:String, atRange range:NSRange){
        simpleDelegate?.simplerTextStorageGotComplexWord()
        simpleDelegate?.simplerTextStorageGotComplexWordAtRange(range)
    }
    
    func processGoodWord(_ word:String, atRange range:NSRange){
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : Any] {
        return backingStore.attributes(at: location, effectiveRange: range)
   }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        backingStore.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [String : Any]?, range: NSRange) {
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    func tokenAtIndex(_ index:Int, inString str:NSString) -> (range:NSRange, token:String) {
        let tokenType = NSLinguisticTagSchemeTokenType
        let tagger = NSLinguisticTagger(tagSchemes: [tokenType], options: 0)
        var r : NSRange = NSMakeRange(0, 0)
        tagger.string = str as String
        let tag = tagger.tag(at: index, scheme: tokenType, tokenRange: &r, sentenceRange: nil)
        return(range:r, token:tag!)
    }
    
    
    
    func wordRangeAtIndex(_ index:Int, inString str:NSString) -> NSRange? {
        let options = (NSLinguisticTagger.Options.omitWhitespace.rawValue)
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeTokenType],
                                        options: Int(options))
        
        var r : NSRange = NSMakeRange(0,0)
        tagger.string = str as String
        
        let tag = tagger.tag(at: index, scheme: NSLinguisticTagSchemeTokenType, tokenRange: &r, sentenceRange: nil)

        if tag == NSLinguisticTagWord {
            return r
        } else
        {
            return nil
        }
    }

}
