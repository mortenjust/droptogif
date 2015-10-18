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


class MovieConverter: ShellTaskDelegate {
    var delegate : MovieConverterDelegate!
    var taskRunning = false;
    
    init(delegate : MovieConverterDelegate){
        self.delegate = delegate
    }
    
    func convertFiles(filenames: [String]){
        Util.use.showNotification("Animating...", text: "");
        // this one could return the path of the final file name, that way we can open the file in Finder
        for filename in filenames {
            delegate.movieConverterDidStart(filename)
            let args = [filename, getFps(), getFilters(), getImageMagickOptions(), getAlphaPrefs()];
            let gifShellTasker = ShellTasker(scriptFile: "gifify")
            gifShellTasker.delegate = self
            
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
    
    func getFilters() -> String {
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
        
        return "-vf \(filterString)";
    }

    func getFps() -> String {
        var fps = Util.use.getStringPref("fps") // TODO: Call Preferences.use instead
        if fps == nil {
            fps = "10"
        }
        
        return fps!;
    }
    
    
    private func getImageMagickOptions() -> String {
        var options = [String]()
        
        if let p = Preferences().getPosterizePref() {
            if p < C.DISABLED_POSTERIZE {
                options.append("-posterize \(p)")
            }
        }
        var optionsString = ""
        for option in options {
            optionsString = "\(optionsString) \(option)"
        }
        return optionsString
    }

    
}
