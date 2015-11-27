//
//  LanguagePopupButton.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/26/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class LanguagePopupButton: NSPopUpButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func mouseUp(theEvent: NSEvent) {
        Swift.print("mouse is up")
    }
    
    override func didCloseMenu(menu: NSMenu, withEvent event: NSEvent?) {
        styleItems()
    }
    
    func setup(){
        self.wantsLayer = true
        populateItems()
        styleItems()
        style()
    }
    
    func style(){
        layer?.backgroundColor = NSColor(red:0.902, green:0.902, blue:0.902, alpha:0.5).CGColor
    }
    
    func populateItems(){
        for l in C.languages {
            self.addItemWithTitle(l.name)
        }
    }
    
    func styleItems(){
        let menuAttributes = [
            NSForegroundColorAttributeName : C.languageItemColor
        ]
        
        for item in self.itemArray {
            let s = NSMutableAttributedString(string: item.title, attributes: menuAttributes)
            item.attributedTitle = s
        }
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }

    
}
