//: Playground - noun: a place where people can play

import SpriteKit
import XCPlayground

//Create the SpriteKit View
let view:SKView = SKView(frame: CGRectMake(0, 0, 1024, 768))

//Add it to the TimeLine
XCPShowView("Live View", view: view)

//Create the scene and add it to the view
let scene:SKScene = SKScene(size: CGSizeMake(1024, 768))
scene.scaleMode = SKSceneScaleMode.AspectFit

//Add something to it!
let redBox:SKSpriteNode = SKSpriteNode(color: SKColor.redColor(), size:CGSizeMake(300, 300))
redBox.position = CGPointMake(512, 384)
redBox.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(6, duration: 2)))
scene.addChild(redBox)




class LoaderScene: SKScene, SKPhysicsContactDelegate {
    var REPEAT_ACTION = "repeatAction"
    var radial : SKFieldNode!
    var ballCategory:UInt32 = 0x1 << 0;
    
    func getAddSliceAction() -> SKAction {
        let x = size.width/2
        let y = size.height/2
        
        let action = SKAction.runBlock { () -> Void in
            self.addSlice(atLocation: CGPointMake(x, y))
        }
        
        let wait = SKAction.waitForDuration(1)
        let remove = SKAction.removeFromParent()
        let actionGroup = SKAction.group([action, wait, remove])
        return actionGroup
    }
    
    func addSlice(atLocation loc:CGPoint? = nil, isProgressFeedback:Bool=false){
        let slice = SKSpriteNode(imageNamed: "slice")
        slice.alpha = 1
        
        if let location = loc {
            slice.position = location
        } else {
            slice.position = CGPointMake(size.width/2, size.height-1)
        }
        
        
        let random = (arc4random()+10) % 30;
        let randomScale:CGFloat = CGFloat(random)/100;
        
        slice.physicsBody = SKPhysicsBody(circleOfRadius: slice.size.height-20)
        addChild(slice)
        
        let scaleAction = SKAction.scaleBy(randomScale, duration: 0)
        slice.physicsBody?.affectedByGravity = true
        slice.runAction(scaleAction)
        slice.physicsBody?.dynamic = true
        slice.physicsBody?.density = 0.01
        slice.physicsBody?.restitution = 0.3
        slice.physicsBody?.charge = 0.02
        slice.physicsBody?.collisionBitMask = ballCategory;
        slice.physicsBody?.contactTestBitMask = ballCategory;
        slice.physicsBody?.categoryBitMask = ballCategory;
        
        let randomHue = CGFloat(Int.random(263...354))/360
        
        
        
        if isProgressFeedback {
            slice.color = SKColor(hue: randomHue, saturation: 50/100, brightness: 100/100, alpha: 1.0)
        } else {
            slice.color = SKColor(hue: randomHue, saturation: 50/100, brightness: 60/100, alpha: 1.0)
        }
        
        slice.colorBlendFactor = 1
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        
        return() // disabling for now, after trying this on JP's old fart of a mac
        
        //    var secondBody: SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA
            //    secondBody = contact.bodyB
            
            let firstNode = firstBody.node! as! SKSpriteNode
            //       let secondNode = secondBody.node! as! SKSpriteNode
            
            let newColor = NSColor(hue: firstNode.color.hueComponent,
                saturation: firstNode.color.saturationComponent,
                brightness: firstNode.color.brightnessComponent,
                alpha: firstNode.color.alphaComponent)
            
            let colorAction = SKAction.colorizeWithColor(newColor, colorBlendFactor: 1.0, duration: 1)
            
            let scaleTo = CGFloat( Int.random(5...30) )/100 // scale between 5 and 30%
            
            let scaleAction = SKAction.scaleTo(scaleTo, duration: 0.5)
            
            //            let squishIn = SKAction.scaleXTo(0.9, duration: 0.2)
            //            let squishOut = SKAction.scaleXTo(1, duration: 0.2)
            //            let squish = SKAction.group([squishIn, squishOut])
            
            let actions = SKAction.group([scaleAction, colorAction])
            
            firstNode.runAction(actions)
            
        }
        else // collission with scene
        {
            firstBody = contact.bodyB
            //   secondBody = contact.bodyA
            //            print("contact B to A")
            
        }
        
        
    }
    
    
    func startLoading(filePath:String){
        let waitAction = SKAction.waitForDuration(0.04);
        let addAndWait = SKAction.sequence([getAddSliceAction(), waitAction])
        let repeatAction = SKAction.repeatActionForever(addAndWait)
        
        // set gravity according to filesize
        let fileSize = Util.use.getFileSize(filePath)
        
        useArrowBody()
        setFileSizeGravity(fileSize)
        runAction(repeatAction, withKey: REPEAT_ACTION)
    }
    
    
    func showDragInvite(fileSize:UInt64){ // shown onMoiseOver
        print("showDragInvite")
        removeAllChildren()
        useCircleBody()
        var balls = Int(fileSize/100000)
        if balls > 100 { balls = 100 }
        
        // add a bunch of balls at random locations
        setInviteGravity()
        
        // then a force that will follow the mouse
        setRadialGravity()
        
        
        let add = SKAction.runBlock { () -> Void in
            let random = CGFloat(arc4random()%2)
            self.addSlice(atLocation: CGPointMake(self.size.width/2+random, self.size.height/2))
        }
        
        let wait = SKAction.waitForDuration(0.005)
        let addThenWait = SKAction.group([add, wait])
        let addAll = SKAction.repeatAction(addThenWait, count: balls)
        runAction(addAll)
    }
    
    func enterDragOverState(){
        //        setStandardGravity()
        removeAllChildren()
    }
    
    
    func prepareForDrop(){
        physicsWorld.gravity = CGVectorMake(0, 20)
        radial.animationSpeed = 10
        radial.position = CGPointMake(size.width, size.height+100)
        let scaleAction = SKAction.scaleTo(0, duration: 0.1)
        let opacityAction = SKAction.fadeAlphaTo(0.9, duration: 0.1)
        let goAwayAction = SKAction.group([scaleAction, opacityAction])
        
        for child in children{
            child.runAction(goAwayAction, completion: { () -> Void in
                // self.setStandardGravity()
            })
        }
    }
    
    func updateDragPosition(location:CGPoint){
        if radial != nil {
            radial.position = location;
        }
    }
    
    override func mouseMoved(theEvent: NSEvent) {
        updateDragPosition(theEvent.locationInNode(self))
    }
    
    
    func stopLoading(){
        // todo: do something sexier here
        if children.count > 0 {
            removeAllChildren()
        }
        removeActionForKey(REPEAT_ACTION)
    }
    
    
    func setInviteGravity(){
        physicsWorld.gravity = CGVectorMake(0, 0.4)
    }
    
    func setStandardGravity(){
        physicsWorld.gravity = CGVectorMake(0, -0.5)
    }
    
    func setFileSizeGravity(size:UInt64){
        physicsWorld.gravity = CGVectorMake(0, -(CGFloat(size)/200000))
    }
    
    func setRadialGravity(){
        radial = SKFieldNode.radialGravityField()
        radial.strength = 3.5
        radial.falloff = 0.01
        radial.animationSpeed = 10.1
        radial.position = CGPointMake(size.width/2, size.height/2)
        addChild(radial)
    }
    
    override func didMoveToView(view: SKView) {
        print("didMoveToView")
        size = view.frame.size
        backgroundColor = SKColor.blueColor()
        setStandardGravity()
    }
    
    func enterInviteState(){
        print("enterInviteState")
        removeAllChildren()
        setStandardGravity()
        useArrowBody()
        let addBall = SKAction.runBlock { () -> Void in
            self.addSlice(atLocation: CGPointMake(self.size.width/2, self.size.height/2), isProgressFeedback: false)
        }
        
        let wait = SKAction.waitForDuration(0.01)
        let showtime = SKAction.group([addBall, wait])
        let multipleBalls = SKAction.repeatAction(showtime, count: 60)
        runAction(multipleBalls)
    }
    
    func enterInactiveState(){ // save cpu
        print("enterInactiveState")
        //        if self.children.count > 0 {
        //            removeAllChildren()
        //            }
    }
    
    func useRollerCoasterBody(){
        print("useRollerCoasterBody")
        self.physicsBody = SKPhysicsBody()
        let nodes = RollerCoasterGenerator().getAllNodes()
        for node in nodes {
            self.addChild(node)
        }
    }
    
    func useArrowBody(){
        print("useArrowBody")
        self.physicsBody = SKPhysicsBody(edgeLoopFromPath: getArrowPath())
    }
    
    func useCircleBody(){
        print("useCircleBody")
        let circleRect = CGRectMake(0, 0, view!.frame.width, view!.frame.width)
        let circlePath = CGPathCreateWithEllipseInRect(circleRect, nil)
        self.physicsBody = SKPhysicsBody(edgeLoopFromPath: circlePath)
    }
    
    
    func getArrowPath() -> CGPath {
        let offsetX = self.size.width * self.anchorPoint.x
        let offsetY = self.size.height * self.anchorPoint.y
        
        let path = CGPathCreateMutable()
        
        
        CGPathMoveToPoint(path, nil, 75 - offsetX, 173 - offsetY)
        CGPathAddLineToPoint(path, nil, 139 - offsetX, 171 - offsetY)
        CGPathAddLineToPoint(path, nil, 139 - offsetX, 110 - offsetY)
        CGPathAddLineToPoint(path, nil, 164 - offsetX, 107 - offsetY)
        CGPathAddLineToPoint(path, nil, 107 - offsetX, 40 - offsetY)
        CGPathAddLineToPoint(path, nil, 49 - offsetX, 107 - offsetY)
        CGPathAddLineToPoint(path, nil, 75 - offsetX, 109 - offsetY)
        CGPathAddLineToPoint(path, nil, 73 - offsetX, 172 - offsetY)
        
        
        CGPathCloseSubpath(path)
        
        return path
        //        sprite.physicsBody = SKPhysicsBody(polygonFromPath: path)
    }
    
    
    
    
}

extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}


