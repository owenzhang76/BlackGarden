//
//  RavenEnemy.swift
//  finalProject
//
//  Created by Owen on 12/5/20.
//  Copyright © 2020 Tory Farmer. All rights reserved.
//

import UIKit
import SceneKit
import GameKit


protocol CharacterProtocol {
    func appear()
    func wonder()
    func attack(another:SKNode)
    func die()
}

class RavenEnemy:CharacterProtocol {
    var health:Int
    var location = vector2(Int32(), Int32())
    var speed:Double
    var damage:Int
    var image = SKSpriteNode()
    var array = [SKTexture]()
    var position:CGPoint
    
    init(fromHealth health:Int, fromLocation location:simd_int2, fromSpeed speed:Double, fromDamage damage:Int, fromPosition position:CGPoint) {
        self.health = health
        self.location = location
        self.speed = speed
        self.damage = damage
        self.position = position
    }
    
    func appear() {
        
    }
    
    func wonder() {
        
    }
    
    func attack(another:SKNode) {
        
    }
    
    func die() {
        
    }
}


