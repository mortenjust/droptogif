//
//  FolderWatcher.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/7/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa
import EonilFileSystemEvents

struct MJFolderMonitor {
    var monitor:FileSystemEventMonitor
    var path:String
}

protocol FolderWatcherDelegate{
    func folderWatcherEvent(event:FileSystemEvent)
}

class FolderWatcher: NSObject {
    var monitors = [MJFolderMonitor]()
    var	queue	=	dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    var delegate: FolderWatcherDelegate?;
    
    static let use = FolderWatcher() // singleton
    
    func folderWatcherEvent(event: FileSystemEvent) {
        print("Warning! Don't forget to set the delegate when instantiating this the first time");
    }
    
    func stopAll(){
        monitors.removeAll()
    }
    
    func startMonitoringFolder(givenFolder:String){
        let folder = String((NSString(string: givenFolder).stringByExpandingTildeInPath))
        print("got \(givenFolder) for folder: \(folder)")
        
        let onEvents = {
            (events: [FileSystemEvent]) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                for ev in events {
                    if(ev.flag.contains(FileSystemEventFlag.ItemCreated) || ev.flag.contains(FileSystemEventFlag.ItemRenamed)){ // only do new or moved files
                        print("Event flag: Created. All flags: \(ev.flag)")
                        print("\(ev.path) just \(ev.description)");
                        self.delegate?.folderWatcherEvent(ev);
                    }
                }
            }
        }
        
        
        let monitor	= FileSystemEventMonitor(pathsToWatch: [folder], latency: 0, watchRoot: false, queue: queue, callback: onEvents)
        
        monitors.append(MJFolderMonitor(monitor: monitor, path: folder));
    }
    

}
