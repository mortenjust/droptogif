//
//  DetailsViewController.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/11/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class DetailsViewController: NSViewController {

    @IBOutlet var detailsTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startListening();
    }
    
    func startListening(){
        NSNotificationCenter.defaultCenter().addObserverForName("mj.newData", object: nil, queue: nil) { (notif) -> Void in            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let s = notif.object as! String
                self.detailsTextView.append(s)
            })
        }
    }
}


extension NSTextView {
    func append(string: String) {
        self.textStorage?.appendAttributedString(NSAttributedString(string: string))
        self.scrollToEndOfDocument(nil)
    }
}