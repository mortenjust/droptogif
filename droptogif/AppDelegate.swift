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

    func folderWatcherEvent(event: FileSystemEvent) {
        handleNewFile(event.path)
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
        window.movableByWindowBackground  = true
        window.canBecomeKeyWindow
        
        
  //      window.backgroundColor = NSColor(red:0.286, green:0.294, blue:0.329, alpha:1);
        window.backgroundColor = NSColor(hue: 229/255, saturation: 13/255, brightness: 50/255, alpha: 1)
        
        
        var windowFrame = window.frame;
        windowFrame.size.width = 260;
        window.setFrame(windowFrame, display: true, animate: true);
        
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
        MovieConverter(delegate:self).convertFiles(filenames)
    }
    
    func handleNewFile(filePath:String){
        let file = NSURL(fileURLWithPath: filePath)
        let filetype = file.pathExtension
        if filetype == nil { return; } // no extension, get the fuck out
        
        if filetype == "mov" || filetype == "avi" || filetype == "mp4" || filetype == "gif" {
//            print("It's a movie, convert");
            MovieConverter(delegate:self).convertFiles([filePath]);
            
        }

    }
    
    func movieConverterDidFinish(resultingFilePath: String) {
        self.vc.stopLoader()
        self.vc.showPlaceholderArrow()
    }
    
    func movieConverterDidStart(filename: String) {
        vc.startLoader(filename)
        taskRunning = true;
    }
    
    func movieConverterDidUpdate() {
        vc.scene.addSlice(atLocation: nil, isProgressFeedback: true)
    }
}

