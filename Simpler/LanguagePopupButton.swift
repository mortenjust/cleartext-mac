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
        super.moveUp(theEvent)
        Swift.print("mouse is up")
    }
    
    override func didCloseMenu(menu: NSMenu, withEvent event: NSEvent?) {
        styleItems()
    }

    private func setup() {
        wantsLayer = true
        populateItems()
        styleItems()
        style()
    }

    private func style() {
        layer?.backgroundColor = NSColor(red:0.902, green:0.902, blue:0.902, alpha:0.5).CGColor
    }

    private func populateItems() {
        for l in C.languages {
            addItemWithTitle(l.name)
        }
    }

    private func styleItems() {
        let menuAttributes = [
            NSForegroundColorAttributeName : C.languageItemColor
        ]

        for item in itemArray {
            item.attributedTitle = NSAttributedString(string: item.title, attributes: menuAttributes)
        }
    }

}
