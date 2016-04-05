//
//  ViewController.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/21/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, SimplerTextViewDelegate {

    @IBOutlet weak var languagePicker: NSPopUpButton!
    @IBOutlet var editor: SimplerTextView!
    
    @IBOutlet weak var editorScrollView: NSScrollView!
    
    @IBOutlet weak var trumpSealImageView: NSImageView!

    private var document: Document!

    override func viewWillAppear() {
        super.viewWillAppear()

        let win = view.window!
        let winController = win.windowController
        document = winController!.document as! Document
        
        win.titlebarAppearsTransparent = true
        win.movableByWindowBackground = true
        win.styleMask = win.styleMask | NSFullSizeContentViewWindowMask
        win.title = ""
        win.backgroundColor = C.editorBackgroundColor
        
        editor.string = document.contents as String
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        document.simplerTextView = editor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        editor.simplerDelegate = self
        showLanguageBackdrop()
    }

    private func showTrump() {
        trumpSealImageView.alphaValue = 0.6
    }

    private func hideTrump() {
        trumpSealImageView.alphaValue = 0.0
    }

    private func showLanguageBackdrop() {
        if let languageCode = NSUserDefaults.standardUserDefaults().stringForKey("language") {
            if languageCode == "Trump" {
                showTrump()
            } else {
                hideTrump()
            }
        } else {
            hideTrump()
        }
    }

    @IBAction func changeLanguage(sender: LanguagePopupButton) {
        print("new language, loading from prefs " + (sender.selectedItem?.title)!)
        showLanguageBackdrop()
        let attr = editor.attributedString().fontAttributesInRange(NSRange(location: 1, length: 1))
        let linefeed = NSAttributedString(string: "\n\n", attributes: attr)
        editor.textStorage?.appendAttributedString(linefeed)
        editor.simplerStorage.checker.loadDictionaryForCode((sender.selectedItem?.title)!)
    }

    private func makeBadSound() {
        if NSUserDefaults.standardUserDefaults().boolForKey(C.PREF_MAKESOUND) {
            NSSound(named: "Basso")?.play()
        }
    }
    
    func simplerTextViewGotComplexWord() {
        playBeginAnimation {
            self.playEndAnimation({ () -> Void in })
        }
        makeBadSound()
    }

    private func playBeginAnimation(completion: () -> Void) {
        editorScrollView.wantsLayer = true

        CATransaction.begin()
        editorScrollView.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        let frame = CGRectOffset(editorScrollView.frame, 10, 0)
        let anim = CABasicAnimation(keyPath: "position")
        anim.fromValue = NSValue(point: frame.origin)
        anim.autoreverses = false
        anim.duration = 0.15
        anim.removedOnCompletion = false
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut )
        CATransaction.setCompletionBlock(completion)
        editorScrollView.layer!.addAnimation(anim, forKey: anim.keyPath)
        CATransaction.commit()
    }

    private func playEndAnimation(completion: () -> Void) {
        CATransaction.begin()
        editor.wantsLayer = true
        editor.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        let frame = CGRectOffset(editor.frame, 0, 0)
        let anim = CABasicAnimation(keyPath: "position")
        anim.fromValue = NSValue(point: frame.origin)
        anim.autoreverses = false
        anim.duration = 0.3
        anim.removedOnCompletion = true
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn )
        CATransaction.setCompletionBlock(completion)
        editor.layer?.addAnimation(anim, forKey: anim.keyPath)
        CATransaction.commit()
    }

    @IBAction func biggerText(sender: AnyObject) {
        let newSize = editor.font!.pointSize + CGFloat(2)
        editor.font = NSFont(name: (editor.font?.fontName)!, size: newSize)
    }

    @IBAction func smallerText(sender: AnyObject) {
        let newSize = editor.font!.pointSize - CGFloat(2)
        editor.font = NSFont(name: (editor.font?.fontName)!, size: newSize)
    }

}
