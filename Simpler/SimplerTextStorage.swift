//
//  SimpleTextStorage.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/29/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

protocol SimplerTextStorageDelegate {
    func simplerTextStorageGotComplexWordAtRange(range:NSRange)
    func simplerTextStorageShouldChangeAtts(atts:[String:AnyObject])
}

class SimplerTextStorage: NSTextStorage {
    let backingStore = NSMutableAttributedString()
    let checker = SimpleWords()
    var simpleDelegate : SimplerTextStorageDelegate?
    var layoutManager : NSLayoutManager!
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
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return backingStore.attributesAtIndex(location, effectiveRange: range)
    }
    
    func selectionDidChange(range:NSRange){

        
        if editedRange.length > 0 && editedRange.location < backingStore.string.characters.count  {
            
            
            let token = tokenAtIndex(editedRange.location, inString: backingStore.string)
            let word = NSString(string: backingStore.string).substringWithRange(token.range)
            
            print("\(token.range), \(word), is a: \(token.token)")
            if token.token == NSLinguisticTagWhitespace || token.token == NSLinguisticTagPunctuation {
                if currentWord != nil {
                    performReplacementsForRange(token.range)
                    }
                } else {
                    currentWord = (word: word, token.range) // build it!
                }
            

            }
        

    }
    
    override func processEditing() {
        super.processEditing()

//        if self.editedRange.length == 1 {
//            let addedChar = NSString(string: backingStore.string).substringWithRange(self.editedRange)
//            if addedChar == " " {
//                performReplacementsForRange(self.editedRange)
//                }
//            }
        


    }
    
    func performReplacementsForRange(changedRange: NSRange) {

        let index = changedRange.location-1
        print("performreplacements: \(changedRange)")
        
        if let wordRange = wordRangeAtIndex(index, inString: backingStore.string) {
            lookForBadWords(wordRange)
            }
    }
    
    func substringForRange(range:NSRange) -> String {
        return String(NSString(string: self.backingStore.string).substringWithRange(range))
    }
    
    
    func lookForBadWords(range:NSRange){
        print("Looking for bad words in ::\(substringForRange(range))::")
        let word = NSString(string: backingStore.string).substringWithRange(range)
        if word.characters.count == 0 { return }

        
        let timer = ParkBenchTimer()

        if self.checker.isSimpleWord(word) {
            processGoodWord(word, atRange: range)
        } else {
            processBadWord(word, atRange: range)
        }
        
        if timer.stop() > 0.001 { Swift.print("########### took  \(timer.stop())") }
    }
    
    func processGoodWord(word:String, atRange range:NSRange){
        var atts = [String:AnyObject]()
        atts[NSBackgroundColorAttributeName] = NSColor.clearColor()
        atts[NSFontNameAttribute] = C.editorFont
        setAttributes(atts, range: range)
        setAttributes(atts, range: self.editedRange)
    }
    
    func processBadWord(word:String, atRange range:NSRange){
        var atts = [String:AnyObject]()
        atts[NSBackgroundColorAttributeName] = NSColor.yellowColor()
        atts[NSFontNameAttribute] = C.editorFont
        setAttributes(atts, range: range)
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        beginEditing()
            backingStore.replaceCharactersInRange(range, withString: str)
            let change = (str as NSString).length - range.length
            edited(NSTextStorageEditActions.EditedCharacters , range: range, changeInLength: change)
        endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        beginEditing()
            backingStore.setAttributes(attrs, range: range)
            edited(NSTextStorageEditActions.EditedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    
    func tokenAtIndex(index:Int, inString str:NSString) -> (range:NSRange, token:String) {
        let tokenType = NSLinguisticTagSchemeTokenType
//        let lexi = NSLinguisticTagSchemeNameTypeOrLexicalClass
        let tagger = NSLinguisticTagger(tagSchemes: [tokenType], options: 0)
        var r : NSRange = NSMakeRange(0, 0)
        tagger.string = str as String
        let tag = tagger.tagAtIndex(index, scheme: tokenType, tokenRange: &r, sentenceRange: nil)
//        let lexitag = tagger.tagAtIndex(index, scheme: lexi, tokenRange: &r, sentenceRange: nil)
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
//    
//    func wordAtIndex(index:Int, inString str:NSString) -> NSString {
//        return str.substringWithRange(wordRangeAtIndex(index, inString: str))
//    }


}
