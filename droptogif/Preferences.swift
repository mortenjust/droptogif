//
//  Preferences.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/9/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class Preferences: NSObject {
    var fps:String = "24";
    var revealInFinder:Bool = true;
    var watchFolder:String? // optional as it could be intrusive
    
    func checkForDefaults(){
        let _fps = getFpsPref()
        let _revealInFinder = getRevealInFinderPref()
        
        if _fps == nil {
            setFpsPref("24")
        }
        
        if _revealInFinder == false {
            setRevealInFinderPref(true)
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
}
