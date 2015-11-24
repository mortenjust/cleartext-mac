//
//  Document.swift
//  Simpler
//
//  Created by Morten Just Petersen on 11/21/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    var contents: NSString = ""

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }

    override func dataOfType(typeName: String) throws -> NSData {
        return contents.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        if data.length > 0 {
            self.contents = NSString(data: data, encoding: NSUTF8StringEncoding)!
            
        }
        
    }


}

