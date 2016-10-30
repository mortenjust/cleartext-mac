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
    
    @IBOutlet var masterView: NSView!
    
    
    var win : NSWindow!
    
    var document:Document!
    var allText = NSAttributedString()
    
    override func viewWillAppear() {
        win = self.view.window!
        let winController = self.view.window?.windowController
        document = winController!.document as! Document
        
        win.titlebarAppearsTransparent = true
        win.isMovableByWindowBackground = true
        //win.styleMask = win.styleMask | NSFullSizeContentViewWindowMask;
//        win.styleMask = [.borderless]
        
        win.title = ""
        win.backgroundColor = C.editorBackgroundColor
        
        editor.string = document.contents as String
    }
    
    override func viewDidAppear() {
        document.simplerTextView = self.editor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editor.simplerDelegate = self
        showLanguageBackdrop()

    }
    
    
    func showTrump(){
        trumpSealImageView.alphaValue = 0.6
    }
    func hideTrump(){
        trumpSealImageView.alphaValue = 0.0
    }
    
    func showLanguageBackdrop(){
        if let languageCode = UserDefaults.standard.string(forKey: "language") {
            if languageCode == "Trump" {
                showTrump()
            } else {
                hideTrump()
            }
        } else {
            hideTrump()
        }
    }
    
    
    @IBAction func changeLanguage(_ sender: LanguagePopupButton) {
        let langId = (sender.selectedItem?.title)!
        print("new language, loading from prefs "+langId)
        showLanguageBackdrop()
//        let attr = editor.attributedString().fontAttributes(in: NSMakeRange(1, 1))
//        let linefeed = NSAttributedString(string: "\n\n", attributes: attr)
//        editor.textStorage?.append(linefeed)
        editor.simplerStorage.checker.loadDictionaryForCode((sender.selectedItem?.title)!)
    }
    
    func makeBadSound(){
        if UserDefaults.standard.bool(forKey: C.PREF_MAKESOUND) {
            NSSound(named: "Basso")?.play()
            }
    }
    
    func simplerTextViewGotComplexWord() {
        print("got complex")
        playBeginAnimation { () -> Void in
            self.playMiddleAnimation({ () -> Void in
                self.playEndAnimation {
                    //
                }
            })
        }
        makeBadSound()
    }
    
    
    
    func playBeginAnimation(_ completion:@escaping ()->Void){
        print("start animation")
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.10
            let f = win.frame
            let fo = win.frame.origin
            win.animator().setFrame(NSMakeRect(fo.x+10, fo.y, f.width, f.height), display: true)
        }, completionHandler: {
            completion()
        })

    }
    
    func playMiddleAnimation(_ completion:@escaping ()->Void){
        print("end animation")
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.10
            let f = win.frame
            let fo = win.frame.origin
            win.animator().setFrame(NSMakeRect(fo.x-20, fo.y, f.width, f.height), display: true)
        }, completionHandler: {
            completion()
        })
    }
    
    func playEndAnimation(_ completion:@escaping ()->Void){
        print("end animation")
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.10
            let f = win.frame
            let fo = win.frame.origin
            win.animator().setFrame(NSMakeRect(fo.x+10, fo.y, f.width, f.height), display: true)
        }, completionHandler: {
             completion()
        })
    }
    
    
    func simplerTextViewKeyUp(_ character: String) {

    }

 
    @IBAction func biggerText(_ sender:AnyObject){
            let newSize = editor.font!.pointSize + CGFloat(2)
            editor.font = NSFont(name: (editor.font?.fontName)!, size: newSize)
    }
    
    @IBAction func smallerText(_ sender:AnyObject){
            let newSize = editor.font!.pointSize - CGFloat(2)
            editor.font = NSFont(name: (editor.font?.fontName)!, size: newSize)
    }

}

