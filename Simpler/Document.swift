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
    var simplerTextView: SimplerTextView!

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
        addWindowController(windowController)
    }

    override func dataOfType(typeName: String) throws -> NSData {
        return simplerTextView.string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        if data.length > 0 {
            contents = NSString(data: data, encoding: NSUTF8StringEncoding)!
        }
    }

}
