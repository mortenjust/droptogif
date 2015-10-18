//: Playground - noun: a place where people can play

import Cocoa

var blue = NSColor.blueColor()

blue.blueComponent * 0xFF


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

String(format: "%X", 255)

NSColorToHex(NSColor.cyanColor())