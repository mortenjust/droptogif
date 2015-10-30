//
//  AppDelegate.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/6/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa
import EonilFileSystemEvents


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, FolderWatcherDelegate, MovieConverterDelegate {
    @IBOutlet weak var window: NSWindow!
    var vc:ViewController! // it's safe, the VC sets it from its viewdidload
    var taskRunning = false;

    
    func folderWatcherEvent(event: FileSystemEvent) { // delegate
        let path = event.path
        let pathUrl = NSURL(fileURLWithPath: path)

        if let pathExtension = pathUrl.pathExtension {
            if pathExtension == "gif" {
                return; // abort, or recursive hell
            }
        }
        if(pathUrl.pathExtension! != "gif"){
            handleNewFile(path)
            }
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        if vc != nil && taskRunning == false {
            vc.willBecomeInactive();
            }
    }
    
    func applicationWillFinishLaunching(notification: NSNotification) {
        Preferences().checkForDefaults()
    }
    
    func applicationWillBecomeActive(notification: NSNotification) {
        if vc != nil && taskRunning == false{
        vc.willBecomeActive();
        }
    }
    

    func applicationDidFinishLaunching(aNotification: NSNotification)
    {

        let window = NSApplication.sharedApplication().windows.first!
        NSApplication.sharedApplication()
        window.titlebarAppearsTransparent = true
        window.title = ""
        window.canBecomeKeyWindow
        window.backgroundColor = NSColor(hue: 229/255, saturation: 13/255, brightness: 50/255, alpha: 1)
        var windowFrame = window.frame;
        windowFrame.size.width = 260;
        window.setFrame(windowFrame, display: true, animate: true);
        window.movableByWindowBackground  = true
        
        FolderWatcher.use.delegate = self;
        FolderWatcher.use.stopAll();
        startMonitoringFolderInPrefs()
    }
    
    func startMonitoringFolderInPrefs(){
        let prefFolder = Util.use.getStringPref("watchFolder")
        if prefFolder != nil {
            FolderWatcher.use.startMonitoringFolder(prefFolder!);
            }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
    // when dragging a file onto the dock icon
    func application(sender: NSApplication, openFiles filenames: [String]) {
        for filename in filenames {
            MovieConverter(delegate:self).convertFile(filename)
            }
    }
    
    func handleNewFile(filePath:String){
        let file = NSURL(fileURLWithPath: filePath)
        let filetype = file.pathExtension
        if filetype == nil { return; } // no extension, get the fuck out
        
        if filetype == "mov" || filetype == "avi" || filetype == "mp4" || filetype == "gif" {
            MovieConverter(delegate:self).convertFile(filePath); // calls delegate methods
            }

    }
    
    func movieConverterDidFinish(resultingFilePath: String) {
        self.vc.stopLoader()
        self.vc.showPlaceholderArrow()
    }
    
    func movieConverterDidStart(filename: String) {
        vc.startLoader(filename)
        Util.use.showNotification("Animating...", text: "");
        taskRunning = true;
    }
    
    func movieConverterDidUpdate() {
//        vc.scene.addSlice(atLocation: nil, isProgressFeedback: true)
    }
}

