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
    func simplerTextStorageGotComplexWordAtRange(range: NSRange)
}

class SimplerTextStorage: NSTextStorage {
    private let backingStore = NSMutableAttributedString()
    let checker = SimpleWords()
    var simpleDelegate: SimplerTextStorageDelegate?

    override var string: String {
        return backingStore.string
    }

    func selectionDidChange(range: NSRange) {
//        print("storage:selectionddichange")
    }

    override func processEditing() {
        super.processEditing()

        if editedRange.length > 0 && editedRange.location < backingStore.string.characters.count {

            let token = tokenAtIndex(editedRange.location, inString: backingStore.string)
            let word = NSString(string: backingStore.string).substringWithRange(token.range)

            if (token.token == NSLinguisticTagWhitespace            // check on spaces
                || token.token == NSLinguisticTagPunctuation)       // check on punctuation like , and .
                && !word.characters.contains("'") {                 // but not on ' like in it's and don't
                    performReplacementsForRange(token.range)
            }
        }
    }

    func performReplacementsForRange(changedRange: NSRange) {
        let index = changedRange.location - 1
        if index >= 0 {
            if let wordRange = wordRangeAtIndex(index, inString: string) {
                lookForBadWords(wordRange)
            }
        }
    }

    func substringForRange(range: NSRange) -> String {
//        print("storagee:substinrgforfrange")
        return String(NSString(string: string).substringWithRange(range))
    }

    private func lookForBadWords(range: NSRange) {
        let word = NSString(string: string).substringWithRange(range)

        guard word.characters.count > 0 else {
            return
        }

        if !checker.isSimpleWord(word) {
            processBadWord(word, atRange: range)
        }
    }

    private func processBadWord(word: String, atRange range: NSRange) {
        simpleDelegate?.simplerTextStorageGotComplexWord()
        simpleDelegate?.simplerTextStorageGotComplexWordAtRange(range)
    }

    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String: AnyObject] {
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

    private func tokenAtIndex(index: Int, inString str: NSString) -> (range: NSRange, token: String) {
        let tokenType = NSLinguisticTagSchemeTokenType
        let tagger = NSLinguisticTagger(tagSchemes: [tokenType], options: 0)
        var range = NSRange(location: 0, length: 0)

        tagger.string = str as String
        let tag = tagger.tagAtIndex(index, scheme: tokenType, tokenRange: &range, sentenceRange: nil)

        return (range: range, token: tag!)
    }

    private func wordRangeAtIndex(index: Int, inString str: NSString) -> NSRange? {
        let options = NSLinguisticTaggerOptions.OmitWhitespace.rawValue
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeTokenType],
                                        options: Int(options))

        var range = NSRange(location: 0, length: 0)
        tagger.string = str as String

        let tag = tagger.tagAtIndex(index, scheme: NSLinguisticTagSchemeTokenType, tokenRange: &range, sentenceRange: nil)

        return tag == NSLinguisticTagWord ? range : nil
    }

}
