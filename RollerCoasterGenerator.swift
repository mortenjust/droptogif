//
//  RollerCoasterGenerator.swift
//  droptogif
//
//  Created by Morten Just Petersen on 10/12/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa
import SpriteKit

class RollerCoasterGenerator: NSObject {
    
    func getAllNodes() -> [SKSpriteNode] {
       // return [node1(), node2(), node3()]
         return [node4()]
    }
    
    func createSprite() -> SKSpriteNode {
        let sprite = SKSpriteNode(color: SKColor.clearColor(), size: CGSizeMake(424, 424))
        sprite.physicsBody?.affectedByGravity = false
        return sprite;
    }
    
    func node1() -> SKSpriteNode {
        let sprite = createSprite();
        let offsetX = sprite.size.width * sprite.anchorPoint.x
        let offsetY = sprite.size.height * sprite.anchorPoint.y
        
        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, 202 - offsetX, 395 - offsetY)
        CGPathAddLineToPoint(path, nil, 217 - offsetX, 396 - offsetY)
        CGPathAddLineToPoint(path, nil, 224 - offsetX, 367 - offsetY)
        CGPathAddLineToPoint(path, nil, 236 - offsetX, 360 - offsetY)
        CGPathAddLineToPoint(path, nil, 245 - offsetX, 357 - offsetY)
        CGPathAddLineToPoint(path, nil, 269 - offsetX, 348 - offsetY)
        CGPathAddLineToPoint(path, nil, 295 - offsetX, 338 - offsetY)
        CGPathAddLineToPoint(path, nil, 322 - offsetX, 327 - offsetY)
        CGPathAddLineToPoint(path, nil, 345 - offsetX, 296 - offsetY)
        CGPathAddLineToPoint(path, nil, 360 - offsetX, 240 - offsetY)
        CGPathAddLineToPoint(path, nil, 359 - offsetX, 230 - offsetY)
        CGPathAddLineToPoint(path, nil, 62 - offsetX, 232 - offsetY)
        CGPathAddLineToPoint(path, nil, 56 - offsetX, 228 - offsetY)
        CGPathAddLineToPoint(path, nil, 70 - offsetX, 267 - offsetY)
        CGPathAddLineToPoint(path, nil, 76 - offsetX, 293 - offsetY)
        CGPathAddLineToPoint(path, nil, 92 - offsetX, 323 - offsetY)
        CGPathAddLineToPoint(path, nil, 115 - offsetX, 339 - offsetY)
        CGPathAddLineToPoint(path, nil, 144 - offsetX, 347 - offsetY)
        CGPathAddLineToPoint(path, nil, 157 - offsetX, 349 - offsetY)
        CGPathAddLineToPoint(path, nil, 173 - offsetX, 355 - offsetY)
        CGPathAddLineToPoint(path, nil, 188 - offsetX, 368 - offsetY)
        CGPathAddLineToPoint(path, nil, 193 - offsetX, 377 - offsetY)
        CGPathAddLineToPoint(path, nil, 194 - offsetX, 390 - offsetY)
        CGPathAddLineToPoint(path, nil, 192 - offsetX, 398 - offsetY)
        CGPathAddLineToPoint(path, nil, 209 - offsetX, 406 - offsetY)
        CGPathAddLineToPoint(path, nil, 219 - offsetX, 396 - offsetY)
        
        CGPathCloseSubpath(path)
        
        sprite.physicsBody = SKPhysicsBody(edgeLoopFromPath:  path)
        return sprite
    }
    
    func node2() -> SKSpriteNode {
        let sprite = createSprite()
        let offsetX = sprite.size.width * sprite.anchorPoint.x
        let offsetY = sprite.size.height * sprite.anchorPoint.y
        
        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, 247 - offsetX, 115 - offsetY)
        CGPathAddLineToPoint(path, nil, 356 - offsetX, 0 - offsetY)
        CGPathAddLineToPoint(path, nil, 417 - offsetX, 4 - offsetY)
        CGPathAddLineToPoint(path, nil, 421 - offsetX, 277 - offsetY)
        CGPathAddLineToPoint(path, nil, 409 - offsetX, 233 - offsetY)
        CGPathAddLineToPoint(path, nil, 407 - offsetX, 209 - offsetY)
        CGPathAddLineToPoint(path, nil, 404 - offsetX, 179 - offsetY)
        CGPathAddLineToPoint(path, nil, 400 - offsetX, 148 - offsetY)
        CGPathAddLineToPoint(path, nil, 394 - offsetX, 119 - offsetY)
        CGPathAddLineToPoint(path, nil, 381 - offsetX, 97 - offsetY)
        CGPathAddLineToPoint(path, nil, 372 - offsetX, 85 - offsetY)
        CGPathAddLineToPoint(path, nil, 361 - offsetX, 77 - offsetY)
        CGPathAddLineToPoint(path, nil, 352 - offsetX, 73 - offsetY)
        CGPathAddLineToPoint(path, nil, 339 - offsetX, 72 - offsetY)
        CGPathAddLineToPoint(path, nil, 329 - offsetX, 76 - offsetY)
        CGPathAddLineToPoint(path, nil, 310 - offsetX, 82 - offsetY)
        
        CGPathCloseSubpath(path)
        
        sprite.physicsBody = SKPhysicsBody(polygonFromPath: path)
        return sprite
    }
    
    func node3() -> SKSpriteNode {
        let sprite = createSprite()
        
        let offsetX = sprite.size.width * sprite.anchorPoint.x
        let offsetY = sprite.size.height * sprite.anchorPoint.y
        
        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, 106 - offsetX, 4 - offsetY)
        CGPathAddLineToPoint(path, nil, 175 - offsetX, 122 - offsetY)
        CGPathAddLineToPoint(path, nil, 157 - offsetX, 105 - offsetY)
        CGPathAddLineToPoint(path, nil, 136 - offsetX, 90 - offsetY)
        CGPathAddLineToPoint(path, nil, 125 - offsetX, 84 - offsetY)
        CGPathAddLineToPoint(path, nil, 110 - offsetX, 77 - offsetY)
        CGPathAddLineToPoint(path, nil, 91 - offsetX, 74 - offsetY)
        CGPathAddLineToPoint(path, nil, 80 - offsetX, 77 - offsetY)
        CGPathAddLineToPoint(path, nil, 71 - offsetX, 84 - offsetY)
        CGPathAddLineToPoint(path, nil, 58 - offsetX, 96 - offsetY)
        CGPathAddLineToPoint(path, nil, 52 - offsetX, 113 - offsetY)
        CGPathAddLineToPoint(path, nil, 46 - offsetX, 128 - offsetY)
        CGPathAddLineToPoint(path, nil, 41 - offsetX, 142 - offsetY)
        CGPathAddLineToPoint(path, nil, 38 - offsetX, 155 - offsetY)
        CGPathAddLineToPoint(path, nil, 29 - offsetX, 190 - offsetY)
        CGPathAddLineToPoint(path, nil, 28 - offsetX, 200 - offsetY)
        CGPathAddLineToPoint(path, nil, 20 - offsetX, 221 - offsetY)
        CGPathAddLineToPoint(path, nil, 13 - offsetX, 244 - offsetY)
        CGPathAddLineToPoint(path, nil, 4 - offsetX, 265 - offsetY)
        CGPathAddLineToPoint(path, nil, 1 - offsetX, 280 - offsetY)
        CGPathAddLineToPoint(path, nil, 2 - offsetX, 3 - offsetY)
        
        CGPathCloseSubpath(path)
        
        sprite.physicsBody = SKPhysicsBody(polygonFromPath: path)
        return sprite
    }
    
    
    func node4() -> SKSpriteNode {
        let sprite = createSprite()
        
        let offsetX = sprite.size.width * sprite.anchorPoint.x
        let offsetY = sprite.size.height * sprite.anchorPoint.y
        
        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, 95 - offsetX, 197 - offsetY)
        CGPathAddLineToPoint(path, nil, 114 - offsetX, 195 - offsetY)
        CGPathAddLineToPoint(path, nil, 86 - offsetX, 191 - offsetY)
        CGPathAddLineToPoint(path, nil, 127 - offsetX, 189 - offsetY)
        CGPathAddLineToPoint(path, nil, 65 - offsetX, 176 - offsetY)
        CGPathAddLineToPoint(path, nil, 136 - offsetX, 169 - offsetY)
        CGPathAddLineToPoint(path, nil, 45 - offsetX, 150 - offsetY)
        CGPathAddLineToPoint(path, nil, 147 - offsetX, 122 - offsetY)
        CGPathAddLineToPoint(path, nil, 28 - offsetX, 102 - offsetY)
        CGPathAddLineToPoint(path, nil, 160 - offsetX, 90 - offsetY)
        CGPathAddLineToPoint(path, nil, 22 - offsetX, 49 - offsetY)
        CGPathAddLineToPoint(path, nil, 181 - offsetX, 39 - offsetY)
        CGPathAddLineToPoint(path, nil, 65 - offsetX, 22 - offsetY)
        CGPathAddLineToPoint(path, nil, 134 - offsetX, 16 - offsetY)
        CGPathAddLineToPoint(path, nil, 82 - offsetX, 9 - offsetY)
        CGPathAddLineToPoint(path, nil, 107 - offsetX, 1 - offsetY)
        
        CGPathCloseSubpath(path)
        
        sprite.physicsBody = SKPhysicsBody(polygonFromPath: path)
        return sprite
    }
    

}
