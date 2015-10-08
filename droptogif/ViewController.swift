//
//  ViewController.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/6/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSOpenSavePanelDelegate, NSTextViewDelegate {
    
    @IBOutlet weak var watchFolderLabel: NSTextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // watchFolderLabel.folderTextViewDelegate = self;
        watchFolderLabel.delegate = self;
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
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
            }
        }
    }
}

