//
//  AppDelegate.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/6/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func application(sender: NSApplication, openFiles filenames: [AnyObject]) {
        convertFiles(filenames as! [String])

    }
    
    func convertFiles(filenames: [String]){
        for filename in filenames {
            println("let's process \(filename) ");
            ShellTasker(scriptFile: "gifify").run(arguments: [filename], complete: { (output) -> Void in
                println("Done with output: \(output)");
            })
        }
    }


}

