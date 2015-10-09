//
//  ViewController.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/6/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController, NSOpenSavePanelDelegate, NSTextViewDelegate, CircleDropDelegate {
    
    @IBOutlet weak var watchFolderLabel: NSTextView!
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var loaderSKView: SKView!
    var scene:LoaderScene!
    
    @IBOutlet weak var circleDropView: DragReceiverView!
    var appDelegate:AppDelegate!
    
    @IBOutlet weak var waitForDrop: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchFolderLabel.delegate = self;
        
        scene = LoaderScene()
        loaderSKView.allowsTransparency = true
        loaderSKView.presentScene(scene)
        loaderSKView.showsPhysics = false
//        startLoader()
        appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate;
        appDelegate.vc = self
        circleDropView.delegate = self;
    }
    
    func startLoader(){
        animateDropInvitationOut()
        scene.startLoading()
    }
    
    func stopLoader(){
        animateDropInvitationIn()
        scene.stopLoading()
    }
    
    
    // todo, subclass NSView for waitforDrop and put these funcs in there
    func animateDropInvitationOut(){
        waitForDrop.wantsLayer = true
        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.duration = 0.3
        fadeAnim.fromValue = 1
        fadeAnim.toValue = 0
        
        let moveAnim = CABasicAnimation(keyPath: "position.y")
        moveAnim.byValue = -100
        moveAnim.duration = 0.3
        waitForDrop.layer?.addAnimation(moveAnim, forKey: "position.y")
        waitForDrop.layer?.addAnimation(fadeAnim, forKey: "opacity")
        waitForDrop.alphaValue = 0


    }
    
    
    func animateDropInvitationIn(){

        waitForDrop.wantsLayer = true
        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.duration = 0.3
        fadeAnim.fromValue = 0
        fadeAnim.toValue = 1
        
        waitForDrop.layer?.addAnimation(fadeAnim, forKey: "opacity")
        waitForDrop.alphaValue = 1

    }

    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func settingsClicked(sender: AnyObject) {
        toggleWindowSize()
    }
    
    func toggleWindowSize(){
        let window = NSApplication.sharedApplication().windows.first;
        var frame = window?.frame
        print(frame?.size.width)
        if frame?.size.width == 400 {
            frame?.size.width = 260
        } else {
            frame?.size.width = 400
        }
        window?.setFrame(frame!, display: true, animate: true)

    }
    
    @IBAction func watchFolderPressed(sender: AnyObject) {
        selectFolder()
    }
    
    func folderTextViewClicked() {
        NSWorkspace.sharedWorkspace().openFile(watchFolderLabel.string!);
    }
    

    func selectFolder(){
        let openPanel = NSOpenPanel();
        openPanel.title = "Select a folder to watch for videos"
        openPanel.message = "Videos you drop in the folder you select will be converted to animated gifs"
        openPanel.showsResizeIndicator=true;
        openPanel.canChooseDirectories = true;
        openPanel.canChooseFiles = false;
        openPanel.allowsMultipleSelection = false;
        openPanel.canCreateDirectories = true;
        openPanel.delegate = self;
        
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if(result == NSFileHandlingPanelOKButton){
                let path = openPanel.URL!.path!
                print("selected folder is \(path)");
               // self.watchFolderLabel.stringValue = path; //  no need when binding
                Util.use.savePref("watchFolder", value: path)
                FolderWatcher.use.startMonitoringFolder(path);
            }
        }
    }
    
    func circleDropDragExited() {
        //
        print("drag exited vc")
        
        animateDropInvitationIn()
        scene.hideDragInvite()
    }
    
    func circleDropDragEntered() {
        //
        print("drag entered vc")
        animateDropInvitationOut()
        scene.showDragInvite()
    }
    
    func circleDropDragPerformed(filePath: String) {
        // PASSITON
        print("drag performed vc, filepath:\(filePath)")
        scene.prepareForDrop()
        appDelegate.handleNewFile(filePath)
    }
    
    func circleDropUpdated(location: NSPoint) {
        scene.updateDragPosition(location)
    }
    
}

