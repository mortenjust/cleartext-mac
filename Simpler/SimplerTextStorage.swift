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
    
    override var string: String {
        return backingStore.string
    }

    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectionDidChange:", name: NSTextViewDidChangeSelectionNotification, object: nil)
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
    
    func selectionDidChange(n:NSNotification){
        if(self.editedRange.length==0){
        lookForBadWords(NSMakeRange(0, backingStore.string.characters.count))
            }
        else {
        }
    }
    
    override func processEditing() {
                super.processEditing()
        print("edited range \(self.editedRange)")
        if self.editedRange.length == 1 {
            let addedChar = NSString(string: backingStore.string).substringWithRange(self.editedRange)
            if addedChar == " " {
                performReplacementsForRange(self.editedRange)
                }
            }
    }
    
    func performReplacementsForRange(changedRange: NSRange) {
        var extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(changedRange.location, 0)))
            extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(NSMaxRange(changedRange), 0)))

        
        
        
//        let substring = NSString(string: backingStore.string).substringWithRange(extendedRange)
//        print("range to test: \(extendedRange) which is \(substring)")

        
        lookForBadWords(extendedRange)
    }
    
    func substringForRange(range:NSRange) -> String {
        return String(NSString(string: self.backingStore.string).substringWithRange(range))
    }
    

    
    func lookForBadWords(range:NSRange){
        print("Looking for bad words in \(substringForRange(range))")
        // \b for word boundaries, \W for any non-word character so we don't end up evaluating while typing
        // TODO: Don't match names like: Hello, Abraham. For now writers will use 1 char names, like: Hello, A
//        let regexStr = "(\\w+)"
        let regexStr = "\\b(\\w+)\\W"
        
        let regex = try! NSRegularExpression(pattern: regexStr, options: .CaseInsensitive)
        regex.enumerateMatchesInString(backingStore.string, options: .ReportCompletion, range: range) { (result, flags, point) -> Void in
            
            let matchRangeTest = result?.rangeAtIndex(1)
            if let matchRange = matchRangeTest {
                let word = NSString(string: self.backingStore.string).substringWithRange(matchRange)
                if !self.checker.isSimpleWord(word) {
                    print("BAD word")
                    self.processBadWord(word, atRange: matchRange)
                    }
                else {
                    self.processGoodWord(word, atRange: matchRange)
                }
                }
        }
    }
    
    
    func processGoodWord(word:String, atRange passedRange:NSRange){
        var range = passedRange
        var attsAt = attributesAtIndex(range.location, longestEffectiveRange: nil, inRange: range)
        attsAt[NSBackgroundColorAttributeName] = C.editorBackgroundColor
        
        if backingStore.length > (range.location+1) {
            range.length++
        }
        
        beginEditing()
        setAttributes(attsAt, range: range)
        simpleDelegate?.simplerTextStorageShouldChangeAtts(attsAt)
        endEditing()
        
    }
    
    func processBadWord(word:String, atRange range:NSRange){
        // 1. call delegate, so it can call a delegate
        // 2. check prefs if we want to replace the word or just change the attribs
        
        //let deleteRange = NSMakeRange(range.location, range.length+1)
        //self.replaceCharactersInRange(deleteRange, withString: "")
//        simpleDelegate?.simplerTextStorageGotComplexWordAtRange(deleteRange)
        
        var attsAt = attributesAtIndex(range.location, longestEffectiveRange: nil, inRange: range)
        attsAt[NSBackgroundColorAttributeName] = NSColor.yellowColor()
        setAttributes(attsAt, range: range)
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
//        Swift.print("##replacing range: \(range) with string: \(str)")
        beginEditing()
            backingStore.replaceCharactersInRange(range, withString: str)
            let change = (str as NSString).length - range.length
            edited(NSTextStorageEditActions.EditedCharacters , range: range, changeInLength: change)
        endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        //Swift.print("setAttributes: \(attrs) with range: \(range)")
        
        beginEditing()
            backingStore.setAttributes(attrs, range: range)
            edited(NSTextStorageEditActions.EditedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    


}
