//
//  MJWatchFolderTextView.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/7/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

protocol MJWatchFolderTextViewDelegate {
    func folderTextViewClicked();
}

class MJWatchFolderTextView: NSTextView {
    var folderTextViewDelegate:MJWatchFolderTextViewDelegate?;
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        folderTextViewDelegate!.folderTextViewClicked() // set this or crash. SET THIS OR CRASH.
    }
    
}
