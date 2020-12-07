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
    var enemiesArray = [RavenEnemy]();
    
    // Scene Nodes
    var car:SKSpriteNode!
    //var mainCharacter = SKSpriteNode()
    var mainCharacter = Player(fromHealth: 100, fromLocation: vector2(Int32(0), Int32(0)), fromSpeed: 0.0, fromDamage: 50, fromPosition: CGPoint(x: 0.0,y: 0.0), fromItems: [Item](), fromImage: SKSpriteNode(imageNamed: "qye_idle_1.png"))
    var qyeIdleAtlas = SKTextureAtlas()
    var qyeIdleArray = [SKTexture]()
    var qyeWalkAtlas = SKTextureAtlas()
    var qyeWalkArray = [SKTexture]()
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
        let pX = 151.5;
        let pY = 151.5;
        var numRavensPlaced = 0
        while (numRavensPlaced < 25) { //Currently places 25 enemies
            let xPos = Double(Int.random(in: -1616..<1616))
            let yPos = Double(Int.random(in: -1616..<1616))
            spawnRaven(positionX: xPos, positionY: yPos)
            numRavensPlaced = numRavensPlaced + 1
        }
        print("position",pX,pY)
        spawnRaven(positionX: pX, positionY: pY)
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
        
        qyeIdleAtlas = SKTextureAtlas(named: "QyeIdle");
        for i in 0...qyeIdleAtlas.textureNames.count - 1 {
            let name = "qye_idle_\(i).png";
            qyeIdleArray.append(SKTexture(imageNamed: name));
        }
        
        qyeWalkAtlas = SKTextureAtlas(named: "QyeWalking");
        for i in 1...qyeWalkAtlas.textureNames.count {
            let name = "qye_walking_\(i).png";
            qyeWalkArray.append(SKTexture(imageNamed: name));
        }
        
        //mainCharacter.image = SKSpriteNode(imageNamed: "qye_idle_1.png")
        mainCharacter.image.size = CGSize(width: 70, height: 64)
        self.addChild(mainCharacter.image)
        mainCharacter.image.run(SKAction.repeatForever(SKAction.animate(with: qyeIdleArray, timePerFrame: 0.2)), withKey: "idle")
        print("my big pepee");
        print(self);
        let bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        bottomLayer.fill(with: sandTiles)
        map.addChild(bottomLayer)
        
        // create the noise map
        let noiseMap = makeNoiseMap(columns: columns, rows: rows)
        mainNoiseMap = noiseMap
        
        // add items to the world
        spawnItems()

        // create layers.
        let topLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
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
            nodePosition = mainCharacter.image.position
            
        }
        mainCharacter.image.run(SKAction.repeatForever(SKAction.animate(with: qyeWalkArray, timePerFrame: 0.08)), withKey: "walk")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        var xlocDest = pos.x
        var ylocDest = pos.y
        let ogMainCharacterPos = mainCharacter.image.position
        xlocDest = min(xlocDest,1616)
        xlocDest = max(xlocDest,-1616)
        ylocDest = min(ylocDest,1616)
        ylocDest = max(ylocDest,-1616)
        let u = sqrt(pow(ogMainCharacterPos.x - xlocDest,2) + pow(ogMainCharacterPos.y - ylocDest,2))
        let numSteps = Int(u)
        var i = 1
        var actionsToDo:[SKAction] = []
        
        while(i <= numSteps) {
            let xToRun = ((xlocDest - mainCharacter.image.position.x)*(CGFloat(i)/CGFloat(numSteps))) + ogMainCharacterPos.x
            let yToRun = ((ylocDest - mainCharacter.image.position.y)*(CGFloat(i)/CGFloat(numSteps))) + ogMainCharacterPos.y
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
        mainCharacter.image.run(SKAction.sequence(actionsToDo), completion: {
            self.mainCharacter.image.removeAction(forKey: "walk");
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
        camera?.position.x = mainCharacter.image.position.x
        camera?.position.y = mainCharacter.image.position.y
        
        //let position = mainCharacter.image.position
        //let positionTwo = mainCharacter.position
        //let column = landBackground.tileColumnIndex(fromPosition: position)
        //let row = landBackground.tileRowIndex(fromPosition: position)
        //let tile = landBackground.tileDefinition(atColumn: column, row: row)
        let adjustedX = ((mainCharacter.image.position.x / 1616)*64) + 64
        let adjustedY = ((mainCharacter.image.position.y / 1616)*64) + 64
        //let location = vector2(Int32(adjustedY), Int32(adjustedX))
        //let locationTwo = vector2(Int32(adjustedYTwo), Int32(adjustedXTwo))
        //print(position)
        //print(mainNoiseMap.value(at: location))
        //print(mainNoiseMap.value(at: vector2(Int32(20), Int32(1615))))
        //print(mainNoiseMap.value(at: vector2(Int32(20), Int32(1616))))
    }
    
    func spawnItems() {
        var numCrownsPlaced = 0
        while (numCrownsPlaced < 5) { //Currently places 5 crowns
            let xPos = Double(Int.random(in: -1616..<1616))
            let yPos = Double(Int.random(in: -1616..<1616))
            let adjustedX = ((xPos / 1616)*64) + 64
            let adjustedY = ((yPos / 1616)*64) + 64
            let location = vector2(Int32(adjustedY), Int32(adjustedX))
            let terrHeight = mainNoiseMap.value(at: location)
            if terrHeight > 0 {
                //Spawn crown
                let positionToSpawn = CGPoint(x:xPos, y:yPos);
                let crown = SKSpriteNode(imageNamed: "black_garden_crown_1.png")
                crown.position = positionToSpawn
                self.addChild(crown)
                numCrownsPlaced = numCrownsPlaced + 1
            }
        }
        
        var numCompassPlaced = 0
        while (numCompassPlaced < 5) {
            let xPos = Double(Int.random(in: -1616..<1616))
            let yPos = Double(Int.random(in: -1616..<1616))
            let adjustedX = ((xPos / 1616)*64) + 64
            let adjustedY = ((yPos / 1616)*64) + 64
            let location = vector2(Int32(adjustedY), Int32(adjustedX))
            let terrHeight = mainNoiseMap.value(at: location)
            if terrHeight > 0 {
                let positionToSpawn = CGPoint(x:xPos, y:yPos);
                let comp = SKSpriteNode(imageNamed: "black_garden_compass_1.png")
                comp.position = positionToSpawn
                self.addChild(comp)
                numCompassPlaced = numCrownsPlaced + 1
            }
        }
        
        var numShotgunPlaced = 0
        while (numShotgunPlaced < 5) {
            let xPos = Double(Int.random(in: -1616..<1616))
            let yPos = Double(Int.random(in: -1616..<1616))
            let adjustedX = ((xPos / 1616)*64) + 64
            let adjustedY = ((yPos / 1616)*64) + 64
            let location = vector2(Int32(adjustedY), Int32(adjustedX))
            let terrHeight = mainNoiseMap.value(at: location)
            if terrHeight > 0 {
                let positionToSpawn = CGPoint(x:xPos, y:yPos);
                let sg = SKSpriteNode(imageNamed: "black_garden_shotgun_1.png")
                sg.position = positionToSpawn
                self.addChild(sg)
                numShotgunPlaced = numShotgunPlaced + 1
            }
        }
        
        var numSwordPlaced = 0
        while (numSwordPlaced < 10) {
            let xPos = Double(Int.random(in: -1616..<1616))
            let yPos = Double(Int.random(in: -1616..<1616))
            let adjustedX = ((xPos / 1616)*64) + 64
            let adjustedY = ((yPos / 1616)*64) + 64
            let location = vector2(Int32(adjustedY), Int32(adjustedX))
            let terrHeight = mainNoiseMap.value(at: location)
            if terrHeight > 0 {
                let positionToSpawn = CGPoint(x:xPos, y:yPos);
                let sword = SKSpriteNode(imageNamed: "black_garden_sword_1.png")
                sword.position = positionToSpawn
                self.addChild(sword)
                numSwordPlaced = numSwordPlaced + 1
            }
        }
    }
    
    func spawnRaven(positionX: Double, positionY: Double) {
        // instantiate raven object
        let positionToSpawn = CGPoint(x:positionX, y:positionY);
        let ravenOne = RavenEnemy(fromHealth: 10, fromLocation: vector2(Int32(70), Int32(70)), fromSpeed: 1, fromDamage: 1, fromPosition: positionToSpawn)
        // append to all enemies array
        enemiesArray.append(ravenOne);
        // setup raven sprite
        let ravenAtlas = SKTextureAtlas(named: "ravenMissionaryIdle")
        for i in 0...ravenAtlas.textureNames.count-1 {
            let name = "raven_missionary_idle_\(i).png";
            ravenOne.array.append(SKTexture(imageNamed: name))
        }
        ravenOne.image = SKSpriteNode(imageNamed: "raven_missionary_idle_1.png")
        ravenOne.image.size = CGSize(width: 60, height: 90)
        ravenOne.image.position = ravenOne.position;
        // append to map
        self.addChild(ravenOne.image);
        // animate idle animation
        ravenOne.image.run(SKAction.repeatForever(SKAction.animate(with: ravenOne.array, timePerFrame: 0.2)), withKey: "idle")
    }
}
