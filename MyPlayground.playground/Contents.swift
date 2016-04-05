//: Playground - noun: a place where people can play

import Cocoa

let str = "Let's get to the bottom of these strings. Two is where the fish go. Three is where they hang out. Four is where they play. Five is five. But how long is a line really?"

func wordRangeAtIndex(index: Int, inString str: NSString) -> NSRange {
    let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeTokenType], options: 0)
    var r = NSRange(location: 0, length: 0)
    tagger.string = str as String
    tagger.tagAtIndex(index, scheme: NSLinguisticTagSchemeTokenType, tokenRange: &r, sentenceRange: nil)
    return r
}


func wordAtIndex(index: Int, inString str: NSString) -> NSString {
    return str.substringWithRange(wordRangeAtIndex(index, inString: str))
}

wordAtIndex(20, inString: str)

