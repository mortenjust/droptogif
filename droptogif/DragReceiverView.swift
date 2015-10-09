//
//  CircleDropView.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/8/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

protocol CircleDropDelegate{
    func circleDropDragEntered()
    func circleDropDragPerformed(filePath:String)
    func circleDropDragExited()
    func circleDropUpdated(mouseAt:NSPoint)
}

class DragReceiverView: NSImageView {
    var delegate:CircleDropDelegate?
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        Swift.print("HELLO \(getPathFromBoard(sender.draggingPasteboard()))")
        delegate?.circleDropDragEntered()
        return NSDragOperation.Copy
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    
    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
        delegate?.circleDropUpdated(sender.draggingLocation())
        return NSDragOperation.Copy
    }
    override func draggingExited(sender: NSDraggingInfo?) {
        delegate?.circleDropDragExited()
    }
    
    override func concludeDragOperation(sender: NSDraggingInfo?) {
        let path = getPathFromBoard((sender?.draggingPasteboard())!)
        delegate?.circleDropDragPerformed(path)
    }
    
    func getPathFromBoard(board:NSPasteboard) -> String {
        let url = NSURL(fromPasteboard: board)
        let path = url?.path!
        Swift.print("dragged item: \(path)")
        return path!;
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){

        let fileTypes = ["com.apple.quicktime-movie ",
            "public.avi",
            "public.mpeg",
            "public.movie"
        ]
        registerForDraggedTypes(fileTypes);        
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
