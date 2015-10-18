//
//  Preferences.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/9/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class Preferences: NSObject {
    var fps:String = "25";
    var revealInFinder:Bool = true;
    var watchFolder:String? // optional as it could be intrusive
    
    func checkForDefaults(){
        
        if getFpsPref() == nil {
            setFpsPref("24")
        }
        
        if getRevealInFinderPref() == false {
            setRevealInFinderPref(true)
        }
     
        if (getScalePercentagePref()! == 0.0)  {
            setScalePercentagePref(100)
        }
        
        if(getPosterizePref()! == 0.0) {
            setPosterizePref(50) //
        }
        
    }
    
    // todo: write getters and setters for named preferences here, and use them instead of the raw string values elsewhere in the app
    
    func getFpsPref() -> String? {
        return Util.use.getStringPref("fps")
    }
    
    func setFpsPref(fps:String){
        Util.use.savePref("fps", value: fps)
    }
    
    func getRevealInFinderPref() -> Bool? {
        return Util.use.getBoolPref("revealInFinder")
    }
    
    func setRevealInFinderPref(r:Bool){
        Util.use.savePref("revealInFinder", value: r)
    }
    
    func setAlphaOn(r:Bool){
        Util.use.savePref("alphaOn", value: r)
    }
    
    func getAlphaOn() -> Bool? {
        return Util.use.getBoolPref("alphaOn")
    }

    
    func getAlphaColor() -> NSColor? {
        return Util.use.getColorPref("alphaColor")
    }
    
    func setAlphaColor(color:NSColor) {
        Util.use.saveColorPref("alphaColor", color: color)
    }
    
    
    func getWatchFolderPref() -> String? {
        return Util.use.getStringPref("watchFolder")
    }
    
    func setWatchFolderPref(w:String){
        Util.use.savePref("watchFolder", value: w)
    }
    
    func getScalePercentagePref() -> Float? {
        return Util.use.getFloatPref("scalePercentage")
    }
    
    func setScalePercentagePref(s:Float) {
        Util.use.savePref("scalePercentage", value: s)
    }

    func setPosterizePref(t:Float){
        Util.use.savePref("posterize", value: t)
    }
    
    func getPosterizePref() -> Float? {
        return Util.use.getFloatPref("posterize")
    }
    
    
    
    
    
}
