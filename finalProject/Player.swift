//
//  Player.swift
//  finalProject
//
//  Created by Marissa Kalkar on 12/6/20.
//  Copyright © 2020 Tory Farmer. All rights reserved.
//

import UIKit
import SpriteKit

class Player:CharacterProtocol {
    var health:Int
    var location = vector2(Int32(), Int32())
    var speed:Double
    var damage:Int
    var image = SKSpriteNode()
    var array = [SKTexture]()
    var position:CGPoint
    var items = [Item]()
    var crownCount: Int = 0
    var didWin: Bool = false
    
    
    init(fromHealth health:Int, fromLocation location:simd_int2, fromSpeed speed:Double, fromDamage damage:Int, fromPosition position:CGPoint, fromItems items: [Item], fromImage image: SKSpriteNode) {
        self.health = health
        self.location = location
        self.speed = speed
        self.damage = damage
        self.position = position
        self.items = items
        self.image = image
        
    }
    
    func collectItem() {
        //if collision add to array
        // if it's a crown then add it to the crown count
        // you win if there are 5 crowns
        
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

