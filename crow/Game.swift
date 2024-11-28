//
//  Game.swift
//  crow
//
//  Created by Евгений Карымов on 18.11.2024.
//

import SpriteKit
import SwiftUI

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let crow: UInt32 = 0b1       // 1
    static let obstacle: UInt32 = 0b10      // 2
}


#Preview {
    ContentView()
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    var bird: Bird = Bird(imageNamed: "crow_start")
    var display: CGRect{
        CGRect(origin: CGPoint(x: bird.position.x - paddingBird + self.size.width / 2, y: self.size.height / 2), size: self.size)
    }
    var paddingBird: CGFloat = 0 // отступ птицы от левого края
    var columns: [Column] = []
    var snows: [SKNode] = []
    let snowPattern = SKSpriteNode(imageNamed: "crow_snow")
    
    override func didMove(to view: SKView) {
        DispatchQueue.main.async{
            self.view?.showsFPS = true
            self.view?.showsNodeCount = true
        }
        
        
        newGame()
        
        

        
    }
    
    private func newGame(){
        self.isPaused = false
        
        columns = []
        snows = []
        
        self.removeAllActions()
        self.removeAllChildren()
        
        physicsWorld.gravity = bird.gravityVecor
        physicsWorld.contactDelegate = self
        physicsWorld.speed = bird.worldSpeed
        let background = SKSpriteNode(imageNamed: "crow_back")
        background.size = self.size
        background.position.x = self.size.width / 2
        background.position.y = self.size.height / 2
        background.zRotation = .pi
        addChild(background)
        setupBird()
        setupColumns()
        
        // MARK: setup snow pattern
        snowPattern.size = CGSize(width: display.size.width, height: 50)
        snowPattern.zPosition = 100
        snowPattern.position.y = snowPattern.size.height * 0.1
        
        self.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: display.height ), to: CGPoint(x: display.width, y: display.height))
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        physicsBody?.contactTestBitMask = PhysicsCategory.crow
        physicsBody?.collisionBitMask = PhysicsCategory.none
        physicsBody?.usesPreciseCollisionDetection = true
        
        
        let snowpoint1 = CGPoint(x: -snowPattern.size.width / 2, y: snowPattern.size.height / 2)
        let snowpoint2 = CGPoint(x: snowPattern.size.width / 2, y: snowPattern.size.height / 2)
        
        
        snowPattern.physicsBody = SKPhysicsBody(edgeFrom: snowpoint1, to: snowpoint2)
        snowPattern.physicsBody?.isDynamic = true
        snowPattern.physicsBody?.affectedByGravity = false
        snowPattern.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        snowPattern.physicsBody?.contactTestBitMask = PhysicsCategory.crow
        snowPattern.physicsBody?.collisionBitMask = PhysicsCategory.none
        snowPattern.physicsBody?.usesPreciseCollisionDetection = true

        
        
        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(ColumnGeneration),
                SKAction.wait(forDuration: 1.0)
                ])
            ))
        
        run(SKAction.repeatForever(
              SKAction.sequence([
                SKAction.run(SnowGeneration),
                SKAction.wait(forDuration: 2.5)
                ])
            ))
        bird.fly()

    }
    
    
    
    
    
    private func setupBird(){
        paddingBird = 200
        
        bird.size.width = min(display.width, display.height) / 3
        bird.size.width = min(display.width, display.height) / 3
        
        bird.position.x = paddingBird
        bird.position.y = self.size.height / 2
        bird.zPosition = 100
        bird.addPhysics()
        addChild(bird)
    }
    
    private func setupColumns(){
        Column.betweenColumns = 0
        Column.columnSize = CGSize(width: display.height, height: display.height)
    }
    
    private func ColumnGeneration(){
        while columns.last == nil || columns.last!.position.x < display.maxX {
            let type = Column.ColumnType.allCases[.random(in: 0...1)]
            let state = Column.ColunmState.allCases[.random(in: 0...1) + abs(Int(!type) - 1)]
            if let lastColumn = columns.last {
                createColumn(type: type, state: state, positionX: lastColumn.position.x + lastColumn.size.width + Column.betweenColumns)
            
            }
            else{
                createColumn(type: type, state: state, positionX: bird.position.x + bird.size.width + display.size.width / 2)
            }
        }
        while columns.first != nil && columns.first!.position.x < display.minX {
            columns.removeFirst()
        }
    }
    
    
    private func createColumn(type: Column.ColumnType, state: Column.ColunmState, positionX: CGFloat){
        let column = Column(imageNamed: type == .top ? "crow_ice" : "crow_tree")
        column.type = type
        column.state = state
        let height = display.height / 2
        column.size = CGSize(width: height, height: height)
        column.position.x = positionX
        if !type == 0{
            column.position.y = -column.size.height + (column.size.height * 0.3 * !state)
        }
        else{
            column.position.y = display.height - (column.size.height * 0.3 * !state)
        }
//        column.position.y = (display.height * !type) - (column.size.height * (1 - !state)) + (height * 0.3 * !state * pow(-1, !type))
        columns.append(column)
        column.addPhysics()
        addChild(column)
        let actualDuration = 10.0
        let actionMove = SKAction.move(to: CGPoint(x: -display.size.width * 2 + column.position.x, y: column.position.y),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        column.run(SKAction.sequence([actionMove, actionMoveDone]))
      }
    
    private func SnowGeneration(){
        while snows.last == nil || snows.last!.position.x < display.midX {
            if let lastSnow = snows.last {
                createSnow(positionX: display.maxY * 2)
            
            }
            else{
                createSnow(positionX: display.size.width / 2)
            }
        }
//        while snows.first != nil && snows.first!.position.x < display.minX {
//            snows.removeFirst()
//        }
    }
    

    

    

    
    private func createSnow(positionX: CGFloat){
        let snow = snowPattern.copy() as! SKNode

        snow.position.x = positionX
        snows.append(snow)
        addChild(snow)
        let actualDuration = 10.0
        let actionMove = SKAction.move(to: CGPoint(x: -display.size.width * 2 + snow.position.x, y: snow.position.y),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        snow.run(SKAction.sequence([actionMove, actionMoveDone]))
      }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
//        var firstBody: SKPhysicsBody
//        var secondBody: SKPhysicsBody
        
        self.isPaused = true
    
        
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        guard !self.isPaused else {newGame(); return}
        
        if !bird.physicsBody!.isDynamic{
            bird.physicsBody!.isDynamic = true
            
        }
        
        bird.addImpulse()
        
        
        
//        bird.position.y = location.y
    }
    
    
}




extension CGVector{
    static func + (lhs: CGVector, rhs: CGVector) -> CGVector{
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
}
extension CGPoint{
    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint{
        return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
}
