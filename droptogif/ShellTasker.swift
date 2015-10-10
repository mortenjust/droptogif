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
        
        print("casting sp to string")
        
        let scriptPath = sp as! String
        
        print("script path: \(scriptPath)")
        
        let tempPath:String = NSBundle.mainBundle().pathForResource("convert", ofType: "")!;
        
        print("tempPath is \(tempPath)")
        
        let tempUrl:NSURL = NSURL(fileURLWithPath: tempPath);
//        let tempUrl:NSURL = NSURL(string: tempPath)!;
        
        print("5")
        
        let resourcesPath = tempUrl.URLByDeletingLastPathComponent?.path!;
        
        print("6")
        
        let bash = "/bin/bash"
        
        task = NSTask()
        let pipe = NSPipe()
        
        
        task.launchPath = bash
        
        // build entire command as arguments to /bin/bash
        var allArguments = [String]()
        allArguments.append("\(scriptPath)") //
        allArguments.append(resourcesPath!) // the script sees this as $1

        for arg in args {
            print("##argadded:\(arg)")
            allArguments.append(arg)
        }
        
        task.arguments = allArguments
        
        print("let's do these arguments:")
        
        var i = 0
        for a in task.arguments! {
            print("argument \(i++): \(a)")
        }
        
        print(task.arguments!);
        
        task.standardOutput = pipe
        
        print("7: launching")
        self.task.launch()
        print("8: waitfordata")
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        print("9: addobserver")
        NSNotificationCenter.defaultCenter().addObserverForName(NSFileHandleDataAvailableNotification, object: pipe.fileHandleForReading, queue: nil) { (notification) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                print("10: got notification")
                data = pipe.fileHandleForReading.readDataToEndOfFile() // use .availabledata instead to stream from the console, pretty cool. But this solution waits before it hands the control back
                output = NSString(data: data, encoding: NSUTF8StringEncoding)!
                
//                
//                let handle = pipe.fileHandleForReading;
//                let data = handle.availableData
//                
//                if(data.length>0){
//                    let s = NSString(data: data, encoding: NSUTF8StringEncoding)
//                    print("10.5: data: \(s)")
//                }
                
                
                print("11: output: \(output)")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("12: callback")
                    complete(output: output)
                })
            })
        }
        
        
    }
}