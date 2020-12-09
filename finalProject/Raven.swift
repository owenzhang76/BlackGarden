//
//  Raven.swift
//  finalProject
//
//  Created by Tory F on 12/8/20.
//  Copyright © 2020 Tory Farmer. All rights reserved.
//

import UIKit
import SpriteKit

class Raven: SKSpriteNode {
    
    var health:Int = 100;
    
    func test() {
        print("hi")
    }
    
    func takeDamage(damage:Int) {
        health = health - damage
        print(health)
    }
}
