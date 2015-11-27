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
    var document:Document!
    
    override func viewWillAppear() {
        let win = self.view.window!
        let winController = self.view.window?.windowController
        document = winController!.document as! Document
        
        win.titlebarAppearsTransparent = true
        win.movableByWindowBackground = true
        win.styleMask = win.styleMask | NSFullSizeContentViewWindowMask;
        win.title = ""
        win.backgroundColor = C.editorBackgroundColor
        editor.string = document.contents as String
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editor.simplerDelegate = self
    }
    
    @IBAction func changeLanguage(sender: LanguagePopupButton) {
        print("new language is, and loading from prefs "+(sender.selectedItem?.title)!)
        editor.simpleWords.loadDictionaryFromPrefs()
    }
    
    
    func makeBadSound(){
        if NSUserDefaults.standardUserDefaults().boolForKey(C.PREF_MAKESOUND) {
            NSSound(named: "Basso")!.play()
            }
    }
    
    func simplerTextViewGotComplexWord() {
        makeBadSound()
        playBeginAnimation { () -> Void in
            self.playEndAnimation({ () -> Void in })
        }
    }
    
    
    func playBeginAnimation(completion:()->Void){
        CATransaction.begin()
            editor.wantsLayer = true
            editor.layerContentsRedrawPolicy = .OnSetNeedsDisplay
            let frame = CGRectOffset(editor.frame, 5, 0)
            let anim = CABasicAnimation(keyPath: "position")
            anim.fromValue = NSValue(point: frame.origin)
            anim.autoreverses = false
            anim.duration = 0.3
            anim.removedOnCompletion = true
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn )
        CATransaction.setCompletionBlock { () -> Void in
            completion()
        }
        editor.layer?.addAnimation(anim, forKey: anim.keyPath)
        CATransaction.commit()
    }
    
    func playEndAnimation(completion:()->Void){
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
        CATransaction.setCompletionBlock { () -> Void in
            completion()
        }
        editor.layer?.addAnimation(anim, forKey: anim.keyPath)
        CATransaction.commit()
    }
    
    
    func simplerTextViewKeyUp(character: String) {
        document.contents = "\(document.contents)\(character)"
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func biggerText(sender:AnyObject){
            let newSize = editor.font!.pointSize + CGFloat(2)
            editor.font = NSFont(name: (editor.font?.fontName)!, size: newSize)
    }
    
    @IBAction func smallerText(sender:AnyObject){
            let newSize = editor.font!.pointSize - CGFloat(2)
            editor.font = NSFont(name: (editor.font?.fontName)!, size: newSize)
    }

}

