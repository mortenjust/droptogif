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
     
        
        print("testing getscalepercentagepref: \(getScalePercentagePref())");
        if (getScalePercentagePref()! == 0.0)  {
            setScalePercentagePref(100)
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

    
}
