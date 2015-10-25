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
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.valueForKey(C.PREF_MATCH_FPS) == nil {
            setMatchFps(true)
        }
        
        if defaults.valueForKey(C.PREF_REVEAL_IN_FINDER) == nil {
            setRevealInFinderPref(true)
        }
        
        if getFpsPref() == nil {
            setFpsPref("30")
        }
     
        if (getSegmentMaxWidth()! == 0.0)  {
            setSegmentMaxWidth(500)
        }
        
        if(getPosterizePref()! == 0.0) {
            setPosterizePref(50) //
        }
        
    }
    
    // todo: write getters and setters for named preferences here, and use them instead of the raw string values elsewhere in the app
    
    func getFpsPref() -> String? {
        return Util.use.getStringPref(C.PREF_FPS)
    }
    
    func setFpsPref(fps:String){
        Util.use.savePref(C.PREF_FPS, value: fps)
    }
    
    func getRevealInFinderPref() -> Bool? {
        return Util.use.getBoolPref(C.PREF_REVEAL_IN_FINDER)
    }
    
    func setRevealInFinderPref(r:Bool){
        Util.use.savePref(C.PREF_REVEAL_IN_FINDER, value: r)
    }
    
    func setAlphaOn(r:Bool){
        Util.use.savePref("alphaOn", value: r)
    }
    
    func getAlphaOn() -> Bool? {
        return Util.use.getBoolPref("alphaOn")
    }
    
    func setMatchFps(r:Bool){
        Util.use.savePref(C.PREF_MATCH_FPS, value: r)
    }
    
    func getMatchFps() -> Bool? {
        return Util.use.getBoolPref(C.PREF_MATCH_FPS)
    }

    
    func getAlphaColor() -> NSColor? {
        return Util.use.getColorPref("alphaColor")
    }
    
    func setAlphaColor(color:NSColor) {
        Util.use.saveColorPref("alphaColor", color: color)
    }
    
    
    func getWatchFolderPref() -> String? {
        return Util.use.getStringPref(C.PREF_WATCHFOLDER)
    }
    
    func setWatchFolderPref(w:String){
        Util.use.savePref(C.PREF_WATCHFOLDER, value: w)
    }
    
    func getSegmentMaxWidth() -> Float? {
        return Util.use.getFloatPref(C.PREF_SEGMENT_MAX_WIDTH)
    }
    
    func setSegmentMaxWidth(s:Float) {
        Util.use.savePref(C.PREF_SEGMENT_MAX_WIDTH, value: s)
    }

    func setPosterizePref(t:Float){
        Util.use.savePref(C.PREF_POSTERIZE, value: t)
    }
    
    func getPosterizePref() -> Float? {
        return Util.use.getFloatPref(C.PREF_POSTERIZE)
    }

}
