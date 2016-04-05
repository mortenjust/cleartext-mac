//
//  SimplerTextView.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/21/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

protocol SimplerTextViewDelegate {
    func simplerTextViewGotComplexWord()
}

class SimplerTextView: NSTextView, SimplerTextStorageDelegate {
    var simplerDelegate: SimplerTextViewDelegate?
    let simplerStorage = SimplerTextStorage()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
        simplerStorage.simpleDelegate = self
        simplerStorage.addLayoutManager(layoutManager!)
        layoutManager?.replaceTextStorage(simplerStorage)

        resetFormatting()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SimplerTextView.selectionDidChange(_:)), name: NSTextViewDidChangeSelectionNotification, object: nil)
    }

    func selectionDidChange(n: NSNotification) {
        // Swift.print("view:selectiondidchange")
        // Swift.print("---inwhich the selected range is \(selectedRange())")
        simplerStorage.selectionDidChange(selectedRange())
    }

    func simplerTextStorageGotComplexWord() {
        simplerDelegate?.simplerTextViewGotComplexWord()
    }

    func simplerTextStorageGotComplexWordAtRange(range: NSRange) {
        simplerDelegate?.simplerTextViewGotComplexWord()

        if NSUserDefaults.standardUserDefaults().boolForKey(C.PREF_FORCESELECT) {
            setSelectedRange(range)
        }
    }

    private func resetFormatting() {
        font = C.editorFont
        backgroundColor = C.editorBackgroundColor
        textColor = C.editorTextColor
    }

}
