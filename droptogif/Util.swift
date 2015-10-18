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
        print("\(key) set to \(value)")
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
    
    func getIntPref(key:String) -> Int? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(key)
    }

    func getFloatPref(key:String) -> Float? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.floatForKey(key)
    }
    
    func getColorPref(key:String) -> NSColor? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.getColorPref(key)
    }
    
    func saveColorPref(key:String, color:NSColor){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.saveColorPref(color, forKey: key)
    }
  
    func getFileSize(filePath:String) -> UInt64 {
        
        do {
            let atts:NSDictionary = try NSFileManager.defaultManager().attributesOfItemAtPath(filePath)
            return atts.fileSize()
        } catch _ {
        }
        
        return 1
    }
    
    
    func NSColorToHex(color: NSColor) -> NSString {
        // Get the red, green, and blue components of the color
        var r :CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        var rInt, gInt, bInt : Int
        var rHex, gHex, bHex : NSString
        
        var hexColor: NSString
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        rInt = Int((r * 255.99999))
        gInt = Int((g * 255.99999))
        bInt = Int((b * 255.99999))
        
        // Convert the numbers to hex strings
        rHex = NSString(format:"%02X", rInt)
        gHex = NSString(format:"%02X", gInt)
        bHex = NSString(format:"%02X", bInt)
        
        hexColor = "\(rHex)\(gHex)\(bHex)"
        // println(rHex+gHex+bHex)
        return hexColor
    }
}


extension NSUserDefaults {
    
    func getColorPref(key: String) -> NSColor? {
        var color: NSColor?
        if let colorData = dataForKey(key) {
          //  color = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? NSColor
            color = NSUnarchiver.unarchiveObjectWithData(colorData) as? NSColor
        }
        return color
    }
    
    func saveColorPref(color: NSColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            // colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
            colorData = NSArchiver.archivedDataWithRootObject(color)
        }
        setObject(colorData, forKey: key)
    }
    
}
