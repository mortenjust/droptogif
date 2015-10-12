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
class AppDelegate: NSObject, NSApplicationDelegate, FolderWatcherDelegate, ShellTaskDelegate {
    @IBOutlet weak var window: NSWindow!
    var vc:ViewController! // it's safe, the VC sets it from its viewdidload

    func folderWatcherEvent(event: FileSystemEvent) {
        handleNewFile(event.path)
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        if vc != nil {
            vc.willBecomeInactive();
            }
    }
    
    
    func applicationWillBecomeActive(notification: NSNotification) {
        if vc != nil {
        vc.willBecomeActive();
        }
    }
    

    func applicationDidFinishLaunching(aNotification: NSNotification)
    {

        let window = NSApplication.sharedApplication().windows.first!
        

        
        Preferences().checkForDefaults()

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
        convertFiles(filenames)

    }
    
    func handleNewFile(filePath:String){
        let file = NSURL(fileURLWithPath: filePath)
        let filetype = file.pathExtension
        if filetype == nil { return; } // no extension, get the fuck out
        
        if filetype == "mov" || filetype == "avi" || filetype == "mp4" {
//            print("It's a movie, convert");
            convertFiles([filePath]);
        }

    }
    
    func getImageMagickOptions() -> String {
        var options = [String]()
        
        if let p = Preferences().getPosterizePref() {
            if p < C.DISABLED_POSTERIZE {
                options.append("-posterize \(p)")
                }
        }
        var optionsString = ""
        for option in options {
            optionsString = "\(optionsString) \(option)"
        }
        return optionsString
    }
    
    
    func getFilters() -> String {
        // https://ffmpeg.org/ffmpeg-filters.html#Video-Filters
        // of interest, scale (done), fade (esp. alpha? fade=in:0:25:alpha=1,), 9.86 palettegen, paletteuse, 9.124 trim, vignette, zoompan
        
        
        var filters = [String]()
        var filterString = ""
        
        // scale
        if let p = Preferences().getScalePercentagePref(){ // 55
            let r = p/100 // 0.55
            let scaleFilter = "scale=iw*\(r):-1"
            filters.append(scaleFilter)
        }

        for filter in filters {
            filterString = "\(filter)" // todo: prepare this for multiple filters
        }

//        return "-vf \(filterString),fade=in:0:15";
          return "-vf \(filterString)";
    }
    
    func convertFiles(filenames: [String]){
        showNotification("Animating...", text: "");
        vc.startLoader()
        // this one could return the path of the final file name, that way we can open the file in Finder
        for filename in filenames {
//            print("let's process \(filename) ");
            
            let args = [filename, getFps(), getFilters(), getImageMagickOptions()];
            
      //      print("shell tasking with arguments: \(args)");
            
            let gifShellTasker = ShellTasker(scriptFile: "gifify")
            gifShellTasker.delegate = self
            
            gifShellTasker.run(arguments: args, complete: { (output) -> Void in
        //        print("Done with output: \(output)");
                let gifFile = "\(filename).gif";
                
                if(Util.use.getBoolPref("revealInFinder")!){
                    self.openAndSelectFile(gifFile)
                    }
                self.vc.stopLoader()
            })
        }
    }
    
    
    func shellTaskDidUpdate(update: String) {
        vc.scene.addSlice(atLocation: nil, isProgressFeedback: true)
    }
    
    func shellTaskDidFinish(output: String) {
        
    }
    
    func shellTaskDidBegin() {
        
    }
    
    
    func getFps() -> String {
        var fps = Util.use.getStringPref("fps")
        if fps == nil {
            fps = "10"
        }
        
        return fps!;
    }
    
    func showNotification(title:String, text:String){
        let center = NSUserNotificationCenter.defaultUserNotificationCenter()
        let notification = NSUserNotification()
        notification.title = title;
        notification.informativeText = text
        notification.soundName = nil;
        center.deliverNotification(notification)
    }
    
    func openAndSelectFile(filename:String){
        let files = [NSURL(fileURLWithPath: filename)];
        NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs(files);
    }

}

