//
//  Util.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/7/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class Util: NSObject {
   static let use = Util() // singleton
    
    func savePref(key:String, value:AnyObject){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key)
        print("set to \(value)")
    }
    
    func getPref(key:String) -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(key)
    }
    
    func getStringPref(key:String) -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey(key)
    }
   
    func getBoolPref(key:String) -> Bool? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(key)
    }
   
}
