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
            let maxWidth = Int(p.getSegmentMaxWidth()!)
            
            calculateScaleWithMaxWidth(filename, maxWidth: maxWidth, completion: { (dimensions) -> Void in
                self.executeConversion(filename, fps: fps!, posterize: posterize, dim:dimensions)
            })
        } else {
            // todo: Some kind of magic auto file size estimator/optimizer
        }
    }
    
    func calculateScaleWithMaxWidth(filepath:String, maxWidth:Int, completion:((Int, Int)) -> Void) {
        dimensionsForFilepath(filepath) { (width, height) -> Void in
            print("we're ready to deal with width: \(width) wheight: \(height)  ")

            var dim = (width:width, height:height)
            let biggestSeg = max(dim.width, dim.height)
            let factor = Float(biggestSeg)/Float(maxWidth)
            if factor > 1 {
                dim = (Int(Float(dim.width)/factor), Int(Float(dim.height)/factor))
            }
            
            completion(dim)
        }
    }
    
    func dimensionsForFilepath(filepath:String, completion:(Int, Int) -> Void ){
        print("we're in the deepest of dimensionsforfile, will now attempt shelltasker")
        let args = [filepath, "2>&1 | /usr/bin/grep Stream"]
        ShellTasker(scriptFile: "getsize.sh").run(arguments: args) { (output) -> Void in
            print("ffmpeg is done and returned this: \(output)")
            let dimensions:(Int, Int) = self.extractDimensionsFromFfmpegInfo(String(output))
            print("2 checking dims")
            if dimensions.0 != 0 && dimensions.1 != 0 {
                print("dimensions: \(dimensions)")
                print("call completion")
                completion(dimensions)
                }
        }
    }
    
    
    func extractDimensionsFromFfmpegInfo(info:String) -> (Int, Int) {
        
        do {
        let re = try NSRegularExpression(pattern: ", (\\d.{0,}?)x(\\d.{0,}?), ",
            options: NSRegularExpressionOptions.CaseInsensitive)
            
            let matches = re.matchesInString(info,
                options: NSMatchingOptions.ReportProgress,
                range:
                NSRange(location: 0, length: info.utf16.count))
            
            if matches.count != 0 {
                let width = (info as NSString).substringWithRange(matches[0].rangeAtIndex(1))
                let height = (info as NSString).substringWithRange(matches[0].rangeAtIndex(2))
                return (Int(width)!, Int(height)!)
                }
            else {
                return (0,0)
            }
                
            
        } catch {
            print("Problem! Abort! Returning 0,0 from extract Dimensions")
            return (0,0)
        }
        
        

    }
    

    func executeConversion(filename: String, fps:Int, posterize:Int, dim:(width:Int, height:Int)) {
        let scaleArg:String = "-vf scale=\(dim.width):\(dim.height)"
        
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
        print("shell task update")
        self.delegate.movieConverterDidUpdate()
    }
    
    func shellTaskDidFinish(output: String) {
        print("shell task finish")
        // we're calling did finish from convertfile method instead
    }
    
    func shellTaskDidBegin() {
        print("Shell task betgin")
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
        if let p = Preferences().getSegmentMaxWidth(){ // 55
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
