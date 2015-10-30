//
//  ViewController.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/6/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa
import AVFoundation
import SpriteKit
import AVKit

class ViewController: NSViewController, NSOpenSavePanelDelegate, NSTextViewDelegate, CircleDropDelegate {
    
    @IBOutlet weak var watchFolderLabel: NSTextView!
    @IBOutlet weak var settingsButton: NSButton!
    
    @IBOutlet weak var sizeSlider: NSSlider!
    @IBOutlet weak var sizeLabel: NSTextField!
    
    @IBOutlet weak var circleDropView: DragReceiverView!
    var appDelegate:AppDelegate!
    
    @IBOutlet weak var waitForDrop: NSView!
    
    @IBOutlet weak var bigCircle: NSImageView!
    @IBOutlet weak var canvasView: NSImageView!
    
    @IBOutlet weak var posterizeSlider: NSSlider!
    
    @IBOutlet weak var posterizeLabel: NSTextField!
    @IBOutlet weak var arrowIcon: NSImageView!
    
    
    @IBOutlet weak var alphaPicker: NSColorWell!
    @IBOutlet weak var alphaLabel: NSTextField!
    @IBOutlet weak var alphaCheckbox: NSButton!
    
    @IBOutlet weak var matchFpsCheckBox: NSButton!
    
    @IBOutlet weak var videoPlayer: AVPlayerView!
    
    
    
    @IBOutlet weak var fpsLabel: NSTextField!
    @IBOutlet weak var fpsTextField: NSTextField!
    
    var activeFromDragging = false
    
    var loaderUI:LoaderUI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderUI = LoaderUI(videoView: videoPlayer)
        watchFolderLabel.delegate = self
        appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate;
        appDelegate.vc = self
        circleDropView.delegate = self // receive drops
        setBaseColor()
    }
    
    override func viewDidAppear() {
        // wait 1s for UI to become ready, then update labels
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            self.updateUILabels()
        }
    }
    
    func updateUILabels(){
        sizeChanged(sizeSlider)
        posterizeChanged(posterizeSlider)
    }
    
    func willBecomeInactive(){
        print("willBecomeInactive")
        activeFromDragging = false;
    }
    
    func willBecomeActive(fromDragging:Bool=false){
        print("willbecomeactive")
    }
    
    func setBaseColor(){
        bigCircle.alphaValue = 0.1
        
    }
    
    func startLoader(filePath:String=""){
        print("startLoader")
        hidePlaceholderArrow()
        loaderUI.start(filePath)
    }
    
    func stopLoader(){
        print("stoploader")
        loaderUI.stop()
        showPlaceholderArrow()
    }
    
    func showPlaceholderArrow(){
        print("showPlaceholderArrow")
        arrowIcon.alphaValue = 1.0
    }
    func hidePlaceholderArrow(){
        print("hideplaceholderarrw")
        arrowIcon.alphaValue = 0.0
    }

    
    @IBAction func posterizeChanged(sender: NSSlider) {
        switch sender.integerValue {
        case 0..<5:
            posterizeLabel.stringValue = "Don't go there"
        case 5..<16:
            posterizeLabel.stringValue = "Tiny and distorted"
        case 16..<27:
            posterizeLabel.stringValue = "Okay & Small"
        case 27..<38:
            posterizeLabel.stringValue = "So-so"
        case 38..<49:
            posterizeLabel.stringValue = "Great, but big"
        case Int(C.DISABLED_POSTERIZE):
            posterizeLabel.stringValue = "Best quality, large file"
        default:
            posterizeLabel.stringValue = "Good"
        }
    }
    
    @IBAction func sizeChanged(sender: NSSlider) {
        let maxSegmentWidth = sender.integerValue
        sizeLabel.stringValue = "Max \(maxSegmentWidth) px"
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
        print("toggleWindowSize")
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
    

    
    func circleDropDragEntered(filePath: String) {
        willBecomeActive(true)
        print("circleDropDragEntered")
        showDropInvitation(filePath)
    }
    
    func circleDropDragExited() {
        print("circleDropDragExited")
        showPlaceholderArrow()
        hideDropInvitation()
    }
    
    func hideDropInvitation(){
        showPlaceholderArrow()
    }
    
    func showDropInvitation(filepath:String){
        hidePlaceholderArrow()
    }
    

    
    func circleDropDragPerformed(filePath: String) {
        print("drag performed vc, filepath:\(filePath)")
        appDelegate.handleNewFile(filePath)
    }
    
    func circleDropUpdated(location: NSPoint) {

    }
    
}

