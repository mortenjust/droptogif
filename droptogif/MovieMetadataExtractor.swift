//
//  MovieMetadataExtractor.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/24/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

struct MovieMetadata {
    var size: (width:Int, height:Int)
    var fps: Float
}

class MovieMetadataExtractor: NSObject {
    var filepath:String!

    init(forMovie _filepath:String, completion:(MovieMetadata) -> Void){
        super.init()
        filepath = _filepath;
        getMetadata(filepath) { (metadata) -> Void in
            completion(metadata)
        }
    }
    
    
    // regexp extraction
    func getMetadata(filepath:String, completion:(MovieMetadata) -> Void){
        getRawMetadata(filepath) { (rawOutput) -> Void in
            let dimensions = self.extractDimensionsFromFfmpegInfo(rawOutput)
            let fps = self.extractFpsFromFfmpegInfo(rawOutput)
            completion(MovieMetadata(size: dimensions, fps: fps))
        }
        
    }
    
    
    // get raw string
    func getRawMetadata(filepath:String, completion:(String) -> Void){
        let args = [filepath, "2>&1 | /usr/bin/grep Stream"]
        ShellTasker(scriptFile: "getsize.sh").run(arguments: args) { (output) -> Void in
            completion("\(output)")
        }
    }
    
    
    // mark: Regexp Extractor functions for metadata
    
    func extractFpsFromFfmpegInfo(info:String) -> Float {
        
        print("this is the info we got:###\(info)###")
        
        
        do {
            let re = try NSRegularExpression(pattern: "(\\d*[.]?\\d*) fps",
                options: NSRegularExpressionOptions.CaseInsensitive)
            
            let matches = re.matchesInString(info,
                options: NSMatchingOptions.ReportProgress,
                range:
                NSRange(location: 0, length: info.utf16.count))
            
            if matches.count != 0 {
                let fps = (info as NSString).substringWithRange(matches[0].rangeAtIndex(1))
                return (Float(fps))!
            }
            else {
                return (0)
            }
            
        } catch {
            print("#fps# Problem! Abort! Returning 0 from extract fps")
            return (0)
        }
        
        
        
    }


    
    func extractDimensionsFromFfmpegInfo(info:String) -> (Int, Int) {
        
        do {
            let re = try NSRegularExpression(pattern: "\\, (\\d+)x(\\d.+?)\\D",
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
            print("#fps# Problem! Abort! Returning 0,0 from extract Dimensions")
            return (0,0)
        }
        
        
        
    }
    

}



