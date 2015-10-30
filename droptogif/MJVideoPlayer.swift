//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit


class MJVideoPlayer: NSObject {
    var loop = true
    var player: AVPlayer!
    var playerView:AVPlayerView!
    var playerItem:AVPlayerItem!
    var vc:NSViewController!
    
    init(filepath:String, playerView _playerView:AVPlayerView){
        super.init()
        
        playerItem = AVPlayerItem(URL: NSURL(fileURLWithPath: filepath))
        playerView = _playerView
        player = AVPlayer(playerItem: playerItem)
        playerView.player = player
        player.pause()
        player.play()
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserverForName("AVPlayerItemDidPlayToEndTimeNotification", object: playerItem, queue: nil) { (notification) -> Void in
            self.playerItemDidReachEnd()
        }
        
        
        center.addObserverForName("ReadyForPlayback", object: nil, queue: nil) { (n) -> Void in
            self.setRate()
        }
    }
    
    func setRate(){
        self.player.rate = 1
    }
    
    
    
    func playerItemDidReachEnd(){
        if loop {
            rewindAndPlay()
        }
    }
    
    func play(){
        player.play()
    }
    
    func rewindAndPlay(){
        player.seekToTime(kCMTimeZero)
        setRate()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}