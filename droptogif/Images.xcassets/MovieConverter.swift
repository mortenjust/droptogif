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
            let posterize = Int(p.getPosterizePref()!)
            let maxWidth = Int(p.getSegmentMaxWidth()!)
            
            calculateScaleWithMaxWidth(filename, maxWidth: maxWidth, completion: { (dimensions) -> Void in
                self.getFps(filename, completion: { (fps) -> Void in
                    self.executeConversion(filename, fps: fps, posterize: posterize, dim:dimensions)
                })
                
            })
        } else {
            // todo: Some kind of magic auto file size estimator/optimizer
        }
    }

    
    
    
    func calculateScaleWithMaxWidth(filepath:String, maxWidth:Int, completion:((Int, Int)) -> Void) {
    _ = MovieMetadataExtractor(forMovie: filepath) { (metadata) -> Void in
            var dim = (width:metadata.size.width, height:metadata.size.height)
            let biggestSeg = max(dim.width, dim.height)
            let factor = Float(biggestSeg)/Float(maxWidth)
            if factor > 1 {
                dim = (Int(Float(dim.width)/factor), Int(Float(dim.height)/factor))
            }
            
            completion(dim)
        }
    }

    func executeConversion(filename: String, fps:Float, posterize:Int, dim:(width:Int, height:Int)) {
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

    func getFps(filepath:String, completion:(Float)->Void) {
        var finalFps:Float = 1
        
        // match movie fps?
        if (Preferences().getMatchFps() == true) {
            print("# Let's match the original")
            _ = MovieMetadataExtractor(forMovie: filepath, completion: { (metadata) -> Void in
                finalFps = metadata.fps
                print("extracted fps is \(metadata.fps)")
                completion(finalFps)
            })
        } else {
            // no, use the one from prefs
            var fps = Preferences().getFpsPref()
            if fps == nil {
                fps = "10"
            }
            completion(finalFps)
        }
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
