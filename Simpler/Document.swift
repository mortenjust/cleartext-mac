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


    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        return simplerTextView.string!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }

    override func read(from data: Data, ofType typeName: String) throws {
        if data.count > 0 {
            self.contents = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        }
        
    }


}

