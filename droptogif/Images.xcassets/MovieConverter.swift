//
//  MovieConverter.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/17/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

protocol MovieConverterDelegate {
    func movieConverterDidStart(filePath:String)
    func movieConverterDidUpdate()
    func movieConverterDidFinish(resultingFilePath:String)
}

struct GifQuality {
    var fps:Int
    var posterize:Int
    var scale:Int
}


class MovieConverter: ShellTaskDelegate {
    var delegate : MovieConverterDelegate!
    var taskRunning = false;
    var fps:String = ""
    
    init(delegate : MovieConverterDelegate){
        self.delegate = delegate
    }
    
    
    func convertFile(filename:String, maxSize:UInt64 = 0){
        print("convertfile for \(filename) with size \(maxSize)")
        
        if maxSize == 0 {
            let p = Preferences();
            let fps = Int(p.getFpsPref()!)
            let posterize = Int(p.getPosterizePref()!)
            let scale = Int(p.getScalePercentagePref()!)
            executeConversion(filename, fps: fps!, posterize: posterize, scale: scale)
        } else {
            optimizeForSize(filename, maxSize: maxSize)
        }
    }
    
    func optimizeForSize(filename:String, maxSize:UInt64){
//        var thisSize:UInt64 = 0;
//        var lastSize:UInt64 = 0;
//        
//        print("let's see wha tthe worst thinkable settings will get us")
//        var fps:Int = 30
//        var posterize:Int = 50
//        var scale:Int = 10
//        
//        // recursive function that calls this function until we hit a good size
//        tryConversionForSize(filename, fps: <#T##Int#>, posterize: <#T##Int#>, scale: <#T##Int#>, completionWithSize: <#T##(UInt64) -> Void#>)
//        
    }
    
    func tryConversionForSize(filename:String, fps:Int, posterize:Int, scale:Int, completionWithSize: (UInt64) -> Void){
        let r:Float = Float(scale)/100 // 0.55
        let scaleArg:String = "-vf scale=iw*\(r):-1"
        let posterizeArg:String = "-posterize \(posterize)"
        let fpsArg:String = "\(fps)"
        
        let args = [filename, fpsArg, scaleArg, posterizeArg];
        let gifShellTasker = ShellTasker(scriptFile: "gifify")
        
        gifShellTasker.run(arguments: args, complete: { (output) -> Void in
            let gifFile = "\(filename).gif"; // TODO: This resulting file name gets generated twice. Here, and in gifify.sh
            let gifSize = Util.use.getFileSize(gifFile)
            
            completionWithSize(gifSize)
            self.taskRunning = false
        })
    }

    func executeConversion(filename: String, fps:Int, posterize:Int, scale:Int) {
        // maybe make a fork in the road here. If maxsize!=null, call normal converter, else call size converter

        let r:Float = Float(scale)/100 // 0.55
        let scaleArg:String = "-vf scale=iw*\(r):-1"
        let posterizeArg:String = "-posterize \(posterize)"
        let fpsArg:String = "\(fps)"

        let args = [filename, fpsArg, scaleArg, posterizeArg];
        let gifShellTasker = ShellTasker(scriptFile: "gifify")

        gifShellTasker.delegate = self
        
        delegate.movieConverterDidStart(filename)
        
        taskRunning = true;
        gifShellTasker.run(arguments: args, complete: { (output) -> Void in
            let gifFile = "\(filename).gif"; // TODO: This resulting file name gets generated twice. Here, and in gifify.sh
            self.taskRunning = false
            if(Util.use.getBoolPref("revealInFinder")!){
                Util.use.openAndSelectFile(gifFile)
            }
            
            self.delegate.movieConverterDidFinish(gifFile)
            
        })

    }
    

    
    
    func shellTaskDidUpdate(update: String) {
        self.delegate.movieConverterDidUpdate()
    }
    
    func shellTaskDidFinish(output: String) {
        // we're calling did finish from convertfile method instead
    }
    
    func shellTaskDidBegin() {
        // we're calling did begin from convertfile method instead
    }
    
    
    func getAlphaPrefs() -> String {
        var alphaArgument = ""
        if let alphaOn = Preferences().getAlphaOn(){
            if alphaOn {
                let alphaColor = Preferences().getAlphaColor()
                let alphaColorHex = Util.use.NSColorToHex(alphaColor!)
                alphaArgument = "\(alphaColorHex)\""
            }
        }
        return alphaArgument
    }
    
    func getScale() -> String {
        // https://ffmpeg.org/ffmpeg-filters.html#Video-Filters
        // of interest, scale (done), fade (esp. alpha? fade=in:0:25:alpha=1,), 9.86 palettegen, paletteuse, 9.124 trim, vignette, zoompan
        
        
        var filters = [String]()
        var filterString = ""
        
        // scale
        if let p = Preferences().getScalePercentagePref(){ // 55
            let r = p/100 // 0.55
            let scaleFilter = "scale=iw*\(r):-1"
            filters.append(scaleFilter)
        }
        
        for filter in filters {
            filterString = "\(filter)" // todo: prepare this for multiple filters
        }
        
        return "\(filterString)";
    }

    func getFps() -> String {
        var fps = Util.use.getStringPref("fps") // TODO: Call Preferences.use instead
        if fps == nil {
            fps = "10"
        }
        
        return fps!;
    }
    
    
    private func getPosterize() -> String {
        var options = [String]()
        
        if let p = Preferences().getPosterizePref() {
            if p < C.DISABLED_POSTERIZE {
                options.append("\(p)")
            }
        }
        var optionsString = ""
        for option in options {
            optionsString = "\(optionsString) \(option)"
        }
        return optionsString
    }

    
}
