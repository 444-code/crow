//
//  Bird.swift
//  crow
//
//  Created by Евгений Карымов on 20.11.2024.
//

import SpriteKit
import SwiftUI

class Bird: SKSpriteNode{
    var vector = CGVector(dx: 0, dy: 200)
    var gravityVecor: CGVector = CGVector(dx: 0, dy: -1.5)
    var worldSpeed: CGFloat = 1.76
    var actionAnim: SKAction?
    func move(){
        position = position + vector + gravityVecor
    }
    
    func fly(){
        var flyAnim: [SKTexture] = []
        for i in 1...8{
            flyAnim.append(SKTexture(imageNamed: "crow_fly0\(i)"))
        }
        actionAnim = SKAction.animate(with: flyAnim, timePerFrame: 0.1)
        run(.repeatForever(actionAnim!))
    
    }
    
    func addPhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        
        physicsBody?.velocity = .zero
        
        physicsBody?.affectedByGravity = true
        physicsBody?.mass = 1
        physicsBody?.categoryBitMask = PhysicsCategory.crow
        physicsBody?.contactTestBitMask = PhysicsCategory.obstacle
        physicsBody?.collisionBitMask = PhysicsCategory.none
        physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func addImpulse(){
//        self.physicsBody?.applyImpulse(.init(dx: 0, dy: -physicsBody!.velocity.dy + 500))
        self.physicsBody?.velocity = self.vector
    }
    
}
