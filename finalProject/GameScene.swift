//
//  GameScene.swift
//  finalProject
//
//  Created by Tory F on 11/19/20.
//  Copyright © 2020 Tory Farmer. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Thanks to https://www.hackingwithswift.com/example-code/games/how-to-create-a-random-terrain-tile-map-using-sktilemapnode-and-gkperlinnoisesource  and https://www.raywenderlich.com/1079-what-s-new-in-spritekit-on-ios-10-a-look-at-tile-maps for inspiration.
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    // touch location
    var targetLocation: CGPoint = .zero
    
    // other variables
    var isRavenSpawned = false;
    var enemiesArray = [RavenEnemy]();
    
    // Scene Nodes
    var car:SKSpriteNode!
    var mainCharacter = SKSpriteNode()
    var qyeAtlas = SKTextureAtlas()
    var qyeArray = [SKTexture]()
    var nodePosition = CGPoint()
    var startTouch = CGPoint()
    var mainNoiseMap = GKNoiseMap()
    
    
    let map = SKNode()
    
    func makeNoiseMap(columns: Int, rows: Int) -> GKNoiseMap {
        let source = GKPerlinNoiseSource()
        source.persistence = 0.80

        let noise = GKNoise(source)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0.0, 0.0)
        let sampleCount = vector2(Int32(columns), Int32(rows))

        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }
    
    func loadSceneNodes() {
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: 0, y: 0)
        self.addChild(cameraNode)
        self.camera = cameraNode
    }
    
    override func didMove(to view: SKView) {
        loadSceneNodes()
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        addChild(map)
        map.xScale = 0.2
        map.yScale = 0.2
        
        let tileSet = SKTileSet(named: "Sample Grid Tile Set")!
        let tileSize = CGSize(width: 128, height: 128)
        let columns = 128
        let rows = 128
        
        let waterTiles = tileSet.tileGroups.first { $0.name == "Water" }
        let grassTiles = tileSet.tileGroups.first { $0.name == "Grass"}
        let sandTiles = tileSet.tileGroups.first { $0.name == "Sand"}
        
        qyeAtlas = SKTextureAtlas(named: "Qye");
        for i in 1...qyeAtlas.textureNames.count {
            let name = "qye_\(i).png";
            qyeArray.append(SKTexture(imageNamed: name));
        }
        mainCharacter = SKSpriteNode(imageNamed: "qye_4.png")
        mainCharacter.size = CGSize(width: 70, height: 64)
       
        self.addChild(mainCharacter)
        print("mybigpepee");
        print(self);
        for items in qyeArray {
            //print(items);
        }
        let bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        bottomLayer.fill(with: sandTiles)
        map.addChild(bottomLayer)
        
        // create the noise map
        let noiseMap = makeNoiseMap(columns: columns, rows: rows)
        mainNoiseMap = noiseMap

        // create our grass/water layer
        let topLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)

        // make SpriteKit do the work of placing specific tiles
        topLayer.enableAutomapping = true

        // add the grass/water layer to our main map node
        map.addChild(topLayer)
        
        for column in 0 ..< columns {
            for row in 0 ..< rows {
                let location = vector2(Int32(row), Int32(column))
                let terrainHeight = noiseMap.value(at: location)
                if terrainHeight < 0 {
                    //Can be modified depending on how much water we want. Can even add conditions on height to create different tiles in splotchy pattern.
                    topLayer.setTileGroup(waterTiles, forColumn: column, row: row)
                } else {
                    topLayer.setTileGroup(grassTiles, forColumn: column, row: row)
                }
            }
        }

        print("testing")
        print(vector2(Int32(0), Int32(0)));
        print(vector2(Int32(128), Int32(128)));

        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
       
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self){
            startTouch = location
            nodePosition = mainCharacter.position
        }
        mainCharacter.run(SKAction.repeatForever(SKAction.animate(with: qyeArray, timePerFrame: 0.08)), withKey: "walk")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        var xlocDest = pos.x
        var ylocDest = pos.y
        let ogMainCharacterPos = mainCharacter.position
        xlocDest = min(xlocDest,1616)
        xlocDest = max(xlocDest,-1616)
        ylocDest = min(ylocDest,1616)
        ylocDest = max(ylocDest,-1616)
        let u = sqrt(pow(ogMainCharacterPos.x - xlocDest,2) + pow(ogMainCharacterPos.y - ylocDest,2))
        let numSteps = Int(u)
        var i = 1
        var actionsToDo:[SKAction] = []
        
        while(i <= numSteps) {
            let xToRun = ((xlocDest - mainCharacter.position.x)*(CGFloat(i)/CGFloat(numSteps))) + ogMainCharacterPos.x
            let yToRun = ((ylocDest - mainCharacter.position.y)*(CGFloat(i)/CGFloat(numSteps))) + ogMainCharacterPos.y
            let adjustedX = ((xToRun / 1616)*64) + 64
            let adjustedY = ((yToRun / 1616)*64) + 64
            var speed = 0.005
            let location = vector2(Int32(adjustedY), Int32(adjustedX))
            let terrIndex = mainNoiseMap.value(at: location)
            if terrIndex < 0 {
                speed = 0.015
            }
            else if terrIndex < 0.15 {
                speed = 0.01
            }
            
            actionsToDo.append(SKAction.move(to: CGPoint(x: xToRun, y: yToRun), duration: speed/2))
            i = i+1
        }
        mainCharacter.run(SKAction.sequence(actionsToDo), completion: {
            self.mainCharacter.removeAction(forKey: "walk");
        })
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        camera?.position.x = mainCharacter.position.x
        camera?.position.y = mainCharacter.position.y
        
        let position = mainCharacter.position
        //let positionTwo = mainCharacter.position
        //let column = landBackground.tileColumnIndex(fromPosition: position)
        //let row = landBackground.tileRowIndex(fromPosition: position)
        //let tile = landBackground.tileDefinition(atColumn: column, row: row)
        let adjustedX = ((mainCharacter.position.x / 1616)*64) + 64
        let adjustedY = ((mainCharacter.position.y / 1616)*64) + 64
        let location = vector2(Int32(adjustedY), Int32(adjustedX))
        //let locationTwo = vector2(Int32(adjustedYTwo), Int32(adjustedXTwo))
        //print(position)
        //print(mainNoiseMap.value(at: location))
        //print(mainNoiseMap.value(at: vector2(Int32(20), Int32(1615))))
        //print(mainNoiseMap.value(at: vector2(Int32(20), Int32(1616))))
        
        if (adjustedX >= 65 && adjustedY >= 65 && !isRavenSpawned) {
            // spawn one raven if character is in bounds.
            spawnRaven();
            isRavenSpawned = true;
        }
    }
    
    func spawnRaven() {
        print("spawnRaven ran");
       
        let location = vector2(Int32(74), Int32(74))
        let ravenOne = RavenEnemy(fromHealth: 10, fromLocation: location, fromSpeed: 1, fromDamage: 1)
        enemiesArray.append(ravenOne);
        let ravenAtlas = SKTextureAtlas(named: "ravenMissionary")
        for i in 1...ravenAtlas.textureNames.count {
            let name = "raven_missionary\(i).png";
            ravenOne.array.append(SKTexture(imageNamed: name))
        }
        ravenOne.image = SKSpriteNode(imageNamed: "raven_missionary_1.png")
        ravenOne.image.size = CGSize(width: 70, height: 105)
        let positionX = 1616*((90-64)/64);
        let positionY = 1616*((90-64)/64);
        let positionToSpawn = CGPoint(x:positionX, y:positionY);
        print("##########");
        print(positionX, mainCharacter.position.x, positionY, mainCharacter.position.y)
        ravenOne.image.position = positionToSpawn;
         self.addChild(ravenOne.image);
        for items in ravenOne.array {
            //print(items);
        }
        
//        ravenOne.image.run(SKAction.repeatForever(SKAction.animate(with: ravenOne.array, timePerFrame: 0.08)), withKey: "walk")
        
    }
    

}
