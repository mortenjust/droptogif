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

class ViewController: NSViewController, NSOpenSavePanelDelegate, NSTextViewDelegate, CircleDropDelegate {
    
    @IBOutlet weak var watchFolderLabel: NSTextView!
    @IBOutlet weak var settingsButton: NSButton!
    @IBOutlet weak var loaderSKView: SKView!
    var scene:LoaderScene!
    
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
    
    
    var activeFromDragging = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchFolderLabel.delegate = self;
        
        scene = LoaderScene()
        loaderSKView.allowsTransparency = true
        loaderSKView.presentScene(scene)
        loaderSKView.showsPhysics = false
        appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate;
        appDelegate.vc = self
        circleDropView.delegate = self;
        setBaseColor()
    }
    
    override func viewDidAppear() {
        // wait 1s for UI to become ready, then update labels
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            self.updateUILabels()
            
            
            // debug
//            self.scene.useRollerCoasterBody()
//            self.scene.startLoading()
        }

    }
    
    func updateUILabels(){
        // trigger updating of labels
        sizeChanged(sizeSlider)
        posterizeChanged(posterizeSlider)
        alphaCheckboxChanged(alphaCheckbox)
    }
    
    func willBecomeInactive(){
        print("willBecomeInactive")
        showPlaceholderArrow()
        scene.enterInactiveState()
        loaderSKView.hidden = true
        activeFromDragging = false;
    }
    
    func willBecomeActive(fromDragging:Bool=false){
        print("willbecomeactive")
        hidePlaceholderArrow()
        loaderSKView.hidden = false;
        
        self.activeFromDragging = fromDragging
        
        if !activeFromDragging { // dragging is a few hundred ms behind, so annoying
             scene.enterInviteState()
        } else {
            // do absolutely nothing, yet
        }
    }
    
    func setBaseColor(){
        bigCircle.alphaValue = 0.1
        
    }
    
    func startLoader(filePath:String=""){
        print("startLoader")
        //animateDropInvitationOut()
        scene.startLoading(filePath)
    }
    
    func stopLoader(){
        print("stoploader")
        animateDropInvitationIn()
        scene.stopLoading()
    }
    
    func showPlaceholderArrow(){
        print("showPlaceholderArrow")
        arrowIcon.alphaValue = 1.0
        loaderSKView.hidden = true
    }
    func hidePlaceholderArrow(){
        print("hideplaceholderarrw")
        arrowIcon.alphaValue = 0.0
        loaderSKView.hidden = false
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
    
    func enableAlphaControls(){
        alphaLabel.alphaValue = 1.0
        alphaPicker.enabled = true
    }
    
    func disableAlphaControls(){
        alphaLabel.alphaValue = 0.3
        alphaPicker.enabled = false
    }
    
    @IBAction func alphaCheckboxChanged(sender: NSButton) {
        if sender.state == NSOnState {
            enableAlphaControls();
        } else {
            disableAlphaControls();
        }        
    }
    
    @IBAction func sizeChanged(sender: NSSlider) {
        let ratio = sender.integerValue
        sizeLabel.stringValue = "Scale \(ratio)%"
    }
    
    // todo, subclass NSView for waitforDrop and put these funcs in there
    func animateDropInvitationOut(){
        print("animateDropInvitationOut")
        waitForDrop.wantsLayer = true
        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.duration = 0.3
        fadeAnim.fromValue = 1
        fadeAnim.toValue = 0
        waitForDrop.layer?.addAnimation(fadeAnim, forKey: "opacity")
        
//        let moveAnim = CABasicAnimation(keyPath: "position.y")
//        moveAnim.byValue = -10
//        moveAnim.duration = 0.3
//        waitForDrop.layer?.addAnimation(moveAnim, forKey: "position.y")

        let scale = CABasicAnimation(keyPath: "transform")
        var tr = CATransform3DIdentity
        tr = CATransform3DTranslate(tr, waitForDrop.bounds.size.width/2, waitForDrop.bounds.size.height/2, 0);
        tr = CATransform3DScale(tr, 0.5, 0.5, 1);
        tr = CATransform3DTranslate(tr, -waitForDrop.bounds.size.width/2, -waitForDrop.bounds.size.height/2, 0);
        scale.toValue = NSValue(CATransform3D: tr)
        
        waitForDrop.layer?.addAnimation(scale, forKey: "transform")
        
        waitForDrop.alphaValue = 0
    }
    
    
    
    func animateDropInvitationIn(){
        //scene.enterInviteState()
        print("animateDropInvitationIn")
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
    
    func circleDropDragExited() {
        print("circleDropDragExited")
        
//        animateDropInvitationIn()
//        scene.hideDragInvite()
//        willBecomeInactive()
//        scene.enterInviteState()
        showPlaceholderArrow()
        animateDropInvitationIn()
    }
    
    
    
    func circleDropDragEntered(filePath: String) {
        willBecomeActive(true)
        loaderSKView.hidden = false
        scene.useCircleBody()
        print("circleDropDragEntered")
        animateDropInvitationOut()
        scene.showDragInvite(Util.use.getFileSize(filePath))
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

