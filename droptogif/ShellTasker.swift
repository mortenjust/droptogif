//
//  ShellTasker.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/6/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa


protocol ShellTaskDelegate {
    func shellTaskDidBegin()
    func shellTaskDidFinish()
}

class ShellTasker: NSObject {
    var scriptFile:String!
    var task:NSTask!
    
    
    init(scriptFile:String){
        //        println("initiate with \(scriptFile)")
        self.scriptFile = scriptFile
    }
    
    func stop(){
        //        println("shelltask stop")
        task.terminate()
    }
    
    func run(arguments args:[String]=[], complete:(output:NSString)-> Void) {
        
        var output = NSString()
        var data = NSData()
        
        if scriptFile == nil {
            return
        }
        
        print("running \(scriptFile)")
        

        let sp:AnyObject = NSBundle.mainBundle().pathForResource(scriptFile, ofType: "") as! AnyObject
        let scriptPath = sp as! String
        
        
        let tempPath:String = NSBundle.mainBundle().pathForResource("convert", ofType: "")!;
        let tempUrl:NSURL = NSURL(string: tempPath)!;
        
        let resourcesPath = tempUrl.URLByDeletingLastPathComponent?.path;
        
        let bash = "/bin/bash"
        
        task = NSTask()
        let pipe = NSPipe()
        
        task.launchPath = bash
        
        // build entire command as arguments to /bin/bash
        var allArguments = [String]()
        allArguments.append("\(scriptPath)") //
        allArguments.append(resourcesPath!) // the script sees this as $1

        for arg in args {
            allArguments.append(arg)
        }
        
        task.arguments = allArguments
        
        print(task.arguments);
        
        task.standardOutput = pipe
        
        self.task.launch()
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSFileHandleDataAvailableNotification, object: pipe.fileHandleForReading, queue: nil) { (notification) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                data = pipe.fileHandleForReading.readDataToEndOfFile() // use .availabledata instead to stream from the console, pretty cool
                output = NSString(data: data, encoding: NSUTF8StringEncoding)!
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    complete(output: output)
                })
            })
        }
        
        
    }
}