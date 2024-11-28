//
//  column.swift
//  crow
//
//  Created by Евгений Карымов on 20.11.2024.
//

import SpriteKit
import SwiftUI


class Column: SKSpriteNode{
    
    static var betweenColumns: CGFloat = 0
    static var columnSize: CGSize = .zero
    var type: ColumnType? = nil
    var state: ColunmState? = nil
    
    enum ColumnType: CaseIterable{
        case top, bottom
        static prefix func !(type: ColumnType) -> CGFloat{
            return type == .top ? 1 : 0
        }
    }
    enum ColunmState: CaseIterable{
        case low, medium, high
        static prefix func !(state: ColunmState) -> CGFloat{
            switch state{
            case .low: return 1
            case .medium: return 2
            case .high: return 3
            }
        }
    }
    
    func addPhysics() {
        self.anchorPoint = .zero
        
        var point1: CGPoint
        var point2: CGPoint
        var point3: CGPoint
        let testPath = CGMutablePath()
        
        if type == .bottom{
            point1 = CGPoint(x: 0, y: 0)
            point2 = CGPoint(x: size.width / 2, y: size.height)
            point3 = CGPoint(x: size.width, y: 0)
        }
        else{
            point1 = CGPoint(x: 0, y: size.height)
            point2 = CGPoint(x: size.width / 2, y: 0)
            point3 = CGPoint(x: size.width, y: size.height)
        }
        testPath.move(to: point1)
        testPath.addLine(to: point2)
        testPath.addLine(to: point3)
        
//        let test = SKShapeNode(path: testPath)
//        test.strokeColor = .red
//        test.lineWidth = 3
//        self.addChild(test)
        
        physicsBody = SKPhysicsBody(polygonFrom: testPath)
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        physicsBody?.contactTestBitMask = PhysicsCategory.crow
        physicsBody?.collisionBitMask = PhysicsCategory.none
        physicsBody?.usesPreciseCollisionDetection = true
        

    }
    
    deinit {self.removeAllActions() ;self.removeFromParent()}
}
