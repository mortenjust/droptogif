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
class AppDelegate: NSObject, NSApplicationDelegate, FolderWatcherDelegate {


    func folderWatcherEvent(event: FileSystemEvent) {
        handleNewFile(event.path)
    }
    
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let window = NSApplication.sharedApplication().windows.first!;
        
        window.titlebarAppearsTransparent = true
        
//        window.styleMask = NSBorderlessWindowMask
        window.title = ""
        window.movableByWindowBackground  = true
        window.canBecomeKeyWindow
        window.backgroundColor = NSColor(red:0.286, green:0.294, blue:0.329, alpha:1);
        
        var windowFrame = window.frame;
        windowFrame.size.width = 260;
        window.setFrame(windowFrame, display: true, animate: true);
        
        
        FolderWatcher.use.delegate = self;
        FolderWatcher.use.stopAll();
        startMonitoringFolderInPrefs()
    }
    
    func startMonitoringFolderInPrefs(){
        let prefFolder = Util.use.getStringPref("watchFolder")!
        FolderWatcher.use.startMonitoringFolder(prefFolder);
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
            print("It's a movie, convert");
            convertFiles([filePath]);
        }

    }
    
    
    func copyFileToPasteboard(filename:String){
//        print("copying \(filename) to paste")
//        var pasteboard = NSPasteboard.generalPasteboard()
//        pasteboard.clearContents()
//        pasteboard.writeFileContents(filename);

//        var gifData = NSData(contentsOfFile: filename);
//        pasteboard.setData(gifData, forType: "com.compuserve.gif");
//        pasteboard.setData(gifData, forType: String(kUTTypeGIF)); // crap! only copies the first frame. Worthless for us, the gif people
        
    }
    
    
//    func startMonitoringFolder(givenFolder:String){
//        let folder = String((NSString(string: givenFolder).stringByExpandingTildeInPath))
//        print("going for folder: \(folder)")
//        
//        let onEvents = {
//            (events: [FileSystemEvent]) -> () in
//            dispatch_async(dispatch_get_main_queue()) {
//                for ev in events {
//                    if(ev.flag.contains(FileSystemEventFlag.ItemCreated) || ev.flag.contains(FileSystemEventFlag.ItemRenamed)){ // only do new or moved files
//                        print("Event flag: Created. All flags: \(ev.flag)")
//                        print("\(ev.path) just \(ev.description)");
//                        self.handleNewFile(ev.path);
//                    }
//                }
//            }
//        }
//        monitor	= FileSystemEventMonitor(pathsToWatch: [folder], latency: 0, watchRoot: false, queue: queue, callback: onEvents)
//    }
    
    func convertFiles(filenames: [String]){
        showNotification("Animating...", text: "");
        // this one could return the path of the final file name, that way we can open the file in Finder
        for filename in filenames {
            print("let's process \(filename) ");
            ShellTasker(scriptFile: "gifify").run(arguments: [filename, "\(getFps())"], complete: { (output) -> Void in
                print("Done with output: \(output)");
                // remove if the shell script doesn't output as .mov.gif
               // let fileUrl = NSURL(fileURLWithPath: filename);
//                let gifFile = "\(fileUrl.URLByDeletingPathExtension!.path!).gif";
                let gifFile = "\(filename).gif";
                // self.copyFileToPasteboard(gifFile); // todo: add when this works
                self.openAndSelectFile(gifFile)
            })
        }
    }
    
    func getFps() -> String {
        var fps = Util.use.getStringPref("fps")
        if fps == nil {
            fps = "10"
        }
        print("fps pref is \(fps)");
        return fps!;
    }
    
    func showNotification(title:String, text:String){
        let center = NSUserNotificationCenter.defaultUserNotificationCenter()
        let notification = NSUserNotification()
        notification.title = title;
        notification.informativeText = text
        notification.soundName = NSUserNotificationDefaultSoundName;
        center.deliverNotification(notification)
    }
    
    func openAndSelectFile(filename:String){
        let files = [NSURL(fileURLWithPath: filename)];
        NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs(files);
    }

}

