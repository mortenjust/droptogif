//
//  LoaderUI.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/29/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit

class LoaderUI {
    var videoView:AVPlayerView!
    var player:MJVideoPlayer!
    
    init(videoView _v:AVPlayerView){
        videoView = _v;
    }
    
    func start(filepath:String){
        videoView.hidden = false;
        player = MJVideoPlayer(filepath: filepath, playerView: videoView)
    }
    
    func stop(){
        videoView.hidden = true;
    }
}
