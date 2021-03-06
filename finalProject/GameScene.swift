//
//  GameScene.swift
//  finalProject
//
//  Created by Tory F on 11/19/20.
//  Copyright © 2020 Tory Farmer. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    //Thanks to https://www.hackingwithswift.com/example-code/games/how-to-create-a-random-terrain-tile-map-using-sktilemapnode-and-gkperlinnoisesource  and https://www.raywenderlich.com/1079-what-s-new-in-spritekit-on-ios-10-a-look-at-tile-maps for inspiration.
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var playerLocationDefault = UserDefaults.standard.string(forKey: "playerLocationDefault")
    
    // touch location
    var targetLocation: CGPoint = .zero
    
    // other variables
    var enemiesArray = [String]();
    
    // Scene Nodes
    var car:SKSpriteNode!
    //var mainCharacter = SKSpriteNode()
   // playerLocationDefault.
    var mainCharacter = Player(fromHealth: 100.00, fromLocation: vector2(Int32(0), Int32(0)), fromSpeed: 0.0, fromDamage: 50, fromPosition: CGPoint(x: 0,y: 0), fromItems: [Item](), fromImage: SKSpriteNode(imageNamed: "qye_idle_1.png"), forRavensTouched: 0)
    
    var introOST: AVAudioPlayer?
    
//    if (playerLocationDefault != "") {
//        let x = CGPointFromString(playerLocationDefault).x
//        let y = CGPointFromString(playerLocationDefault).y
//
//        var mainCharacter = Player(fromHealth: 100.00, fromLocation: vector2(Int32(0), Int32(0)), fromSpeed: 0.0, fromDamage: 50, fromPosition: CGPoint(x: x,y: y), fromItems: [Item](), fromImage: SKSpriteNode(imageNamed: "qye_idle_1.png"), forRavensTouched: 0)
//    }

    
    var qyeIdleAtlas = SKTextureAtlas()
    var qyeIdleArray = [SKTexture]()
    var qyeWalkAtlas = SKTextureAtlas()
    var qyeWalkArray = [SKTexture]()
    var qyeAttackAtlas = SKTextureAtlas()
    var qyeAttackArray = [SKTexture]()
    var qyeDeathAtlas = SKTextureAtlas()
    var qyeDeathArray = [SKTexture]()
    var nodePosition = CGPoint()
    var startTouch = CGPoint()
    var mainNoiseMap = GKNoiseMap()
    
    var itemsCollected: [String] = UserDefaults.standard.stringArray(forKey: "playerItems") as? [String] ?? []
//    var crowns: Int = 0
//    var health: Int = 0
//    var damage: Int = 0
    
    let stats = UserDefaults.standard
    //var health : Int
    
    var enemiesUserDefault = UserDefaults.standard.stringArray(forKey: "enemiesUserDefault") ?? []
    
    
  
      
//        self.health  = stats.integer(forKey: "health")
//        self.damage  = stats.integer(forKey: "damage")
//        self.crowns = stats.integer(forKey: "crowns")
//        print("in init")
//        print(crowns)
    
    
    

//    let baseBar = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(CGRectGetMidX(self.frame)-40, self.frame.size.height/10)]
//
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
        var numRavensPlaced = 0
        print("loc default",playerLocationDefault)
        let x = NSCoder.cgPoint(for: playerLocationDefault ?? "0").x
        let y = NSCoder.cgPoint(for: playerLocationDefault ?? "0").y
        print("reload",x,y)
        mainCharacter.position =  CGPoint(x: x,y: y)
        mainCharacter.image.position = CGPoint(x: x,y: y)
        print("main char pos",mainCharacter.position)
        if enemiesUserDefault.isEmpty{
            while (numRavensPlaced < 25) { //Currently places 25 enemies
                let xPos = Double(Int.random(in: -1616..<1616))
                let yPos = Double(Int.random(in: -1616..<1616))
                spawnRaven(positionX: xPos, positionY: yPos)
                numRavensPlaced = numRavensPlaced + 1
            }
        }
        
        else{
            for item in enemiesUserDefault {
                var currItemPoint = NSCoder.cgPoint(for: item)
                spawnRaven(positionX: Double(currItemPoint.x), positionY: Double(currItemPoint.y))
            }
        }
        
       
        //print("position",pX,pY)
        //spawnRaven(positionX: pX, positionY: pY)
        UserDefaults.standard.set(enemiesArray, forKey: "enemiesUserDefault")
        //let tempRavenArray = UserDefaults.standard.stringArray(forKey: "enemiesUserDefault")
        
        
        //print("pringing raven locations:")
//        for location in tempRavenArray!{
//            //print(location)
//        }
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
        
        qyeAttackAtlas = SKTextureAtlas(named: "QyeAttack");
        for i in 0...qyeAttackAtlas.textureNames.count - 1 {
            let name = "qye_attack_\(i).png";
            qyeAttackArray.append(SKTexture(imageNamed: name));
        }
        
        qyeDeathAtlas = SKTextureAtlas(named: "QyeDeath");
        for i in 0...qyeAttackAtlas.textureNames.count - 1 {
            let name = "qye_death_\(i).png";
            qyeDeathArray.append(SKTexture(imageNamed: name));
        }
        
        //mainCharacter.image = SKSpriteNode(imageNamed: "qye_idle_1.png")
        mainCharacter.image.size = CGSize(width: 70, height: 64)
        mainCharacter.image.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        mainCharacter.image.physicsBody!.affectedByGravity = false;
        mainCharacter.image.physicsBody!.isDynamic = true
        mainCharacter.image.physicsBody!.categoryBitMask = 1;
        self.addChild(mainCharacter.image)
        mainCharacter.image.run(SKAction.repeatForever(SKAction.animate(with: qyeIdleArray, timePerFrame: 0.2)), withKey: "idle")
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
        print("move player to new location")
       
        let touch = touches.first
        if let location = touch?.location(in: self){
            startTouch = location
            nodePosition = mainCharacter.image.position
           // print("node position:")
            print(nodePosition)
        }
         //store player location in player user default
        
        mainCharacter.image.run(SKAction.repeatForever(SKAction.animate(with: qyeWalkArray, timePerFrame: 0.08)), withKey: "walk")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("CONTACT")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        let positionInScene = pos
        let touchedNode = self.atPoint(positionInScene)
        if touchedNode.name == "raven" {
            //mainCharacter.health -= 10
          
            let mcPos = mainCharacter.position
            let maxSwordDistance = 100.0 //Minimum distance for hand to hand combat.
            let maxGunDistance = 300.0 //Minimum distance for gunshot.
            let dx = mcPos.x - touchedNode.position.x
            let dy = mcPos.y - touchedNode.position.y
            let distance = sqrt(dx*dx + dy*dy)
            var isAttack = false;
            
            if let rav = touchedNode as? Raven {
                print("fuck me")
                print(distance);
                print(mainCharacter.hasGun);
                print(mainCharacter.hasSword);
                // within max hit distance and player only has a gun
                if distance <= CGFloat(maxGunDistance) && mainCharacter.hasGun {
                    print("gun distance gun damage")
                    rav.takeDamage(damage:35) //Gun damage is 35
                    //print(mainCharacter.health)
                    isAttack = true;
                } else if distance <= CGFloat(maxSwordDistance) && !mainCharacter.hasGun && mainCharacter.hasSword {
                    print("sword distance sword damage")
                    rav.takeDamage(damage:20) //Fist damage is 20
                    isAttack = true;
                    // within sword range and player has sword
                } else if distance <= CGFloat(maxGunDistance) && mainCharacter.hasSword && !mainCharacter.hasGun {
                    // within max hit distance and player only has sword
                    // nothing should happen
                    print("241")
                } else if distance <= CGFloat(maxSwordDistance) && !mainCharacter.hasSword && !mainCharacter.hasGun {
                     print("242");
                    // within sword range and player has has nothing
                    // nothing should happen
                } else {
                    print("246")
                    // within max distance and player has nothing
                    // nothing should happen
                }
                
                if (rav.health <= 0) {
                    if let index = enemiesArray.firstIndex(of: NSCoder.string(for: rav.position)) {
                        enemiesArray.remove(at: index)
                    }
                    UserDefaults.standard.set(enemiesArray, forKey: "enemiesUserDefault")
                    rav.removeFromParent()
                }
            }
            
            if(isAttack) {
                mainCharacter.image.run(SKAction.animate(with: qyeAttackArray, timePerFrame: 0.08), withKey: "attack")
            }
            return //We attacked the raven instead of moving.
        }
        
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
            let adjustedX = ((xToRun / 1616)*64) + 63
            let adjustedY = ((yToRun / 1616)*64) + 63
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
        mainCharacter.position = mainCharacter.image.position
        
        var damage = stats.integer(forKey: "damage")
        var health = stats.double(forKey: "health")
        damage = 20
        if mainCharacter.image.physicsBody?.allContactedBodies().count ?? 0 > 0 {
            //print(mainCharacter.image.physicsBody?.allContactedBodies())
            let firstBody = mainCharacter.image.physicsBody?.allContactedBodies()[0]
            let touchedItem = firstBody?.node
            UserDefaults.standard.set(damage, forKey: "damage")
            if let tI = touchedItem{
                if tI.name == "sword" {
                    damage = 50
                    UserDefaults.standard.set(damage, forKey: "damage")
                    if !itemsCollected.contains("sword"){
                         itemsCollected.append("sword")
                    }
                    UserDefaults.standard.set(itemsCollected, forKey: "playerItems")
                    mainCharacter.hasSword = true
                    tI.removeFromParent()
                }
            }
            if let tI = touchedItem{
                if tI.name == "shotgun" {
                    damage = 35
                    UserDefaults.standard.set(damage, forKey: "damage")
                    if !itemsCollected.contains("shotgun"){
                         itemsCollected.append("shotgun")
                    }
                    UserDefaults.standard.set(itemsCollected, forKey: "playerItems")
                    mainCharacter.hasGun = true
                    tI.removeFromParent()
                }
            }
            if let tI = touchedItem{
                if tI.name == "compass" {
                    if !itemsCollected.contains("compass"){
                         itemsCollected.append("compasss")
                    }
                    UserDefaults.standard.set(itemsCollected, forKey: "playerItems")
                    //This is where compass code gets implemented. Display text on a crown location somewhere.
                    tI.removeFromParent()
                }
            }
            if let tI = touchedItem{
                if tI.name == "crown" {
                    print("touched a crown")
                    var crowns = stats.integer(forKey: "crowns")
        
                    if(crowns == 4){
                        
                        let label = UILabel(frame: CGRect(x: 0 , y:0, width: (self.view?.frame.width)!, height: (self.view?.frame.height)!))
                        label.center = CGPoint(x: (self.view?.center.x)!, y: (self.view?.center.y)! )
                        label.backgroundColor = UIColor.black
                        label.textAlignment = .center
                        label.text = "You Win"
                        label.textColor = UIColor.white

                        self.view?.addSubview(label)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
                        
                            for view in self.view!.subviews {
                                if (view.isKind(of: UILabel.self)) {
                                    view.removeFromSuperview()
                                }
                            }
                            
                        }
                        
                        
                        UserDefaults.standard.set(0, forKey: "crowns")
                        UserDefaults.standard.set(100, forKey: "health")
                        UserDefaults.standard.set([], forKey: "playerItems")
                        UserDefaults.standard.set([], forKey:"enemiesUserDefault")
                        
                      
                    }
                    else{
                        crowns += 1
                        UserDefaults.standard.set(crowns, forKey: "crowns")
                    }
                    
                   // This is where compass code gets implemented. Display text on a crown location somewhere.
                    tI.removeFromParent()
                }
            }
        
            if let tI = touchedItem{
                if tI.name == "raven" {
                    mainCharacter.ravensTouched += 1
                    if (health > 0) {
                        health -= 0.5
                    }
                    else {
                        UserDefaults.standard.set(0, forKey: "crowns")
                        UserDefaults.standard.set(100, forKey: "health")
                        UserDefaults.standard.set([], forKey: "playerItems")
                    }

                    //mainCharacter.position.
                    UserDefaults.standard.set(health, forKey: "health")
                    //print(health)
                    
                    
               }
            }
        }
        //print(health)
        if (health <= 0) {
            
            //mainCharacter.image.run(SKAction.animate(with: qyeDeathArray, timePerFrame: 0.08), withKey: "death")
             DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {

             let label = UILabel(frame: CGRect(x: 0 , y:0, width: (self.view?.frame.width)!, height: (self.view?.frame.height)!))
             label.center = CGPoint(x: (self.view?.center.x)!, y: (self.view?.center.y)! )
             label.backgroundColor = UIColor.black
             label.textAlignment = .center
             label.text = "You Lost :("
             label.textColor = UIColor.white

             self.view?.addSubview(label)





            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.

                for view in self.view!.subviews {
                    if (view.isKind(of: UILabel.self)) {
                        view.removeFromSuperview()
                    }
                }

            }

            UserDefaults.standard.set(0, forKey: "crowns")
            UserDefaults.standard.set(100, forKey: "health")
            UserDefaults.standard.set([], forKey: "playerItems")
            UserDefaults.standard.set([], forKey:"enemiesUserDefault")
            UserDefaults.standard.set("0.0,0.0", forKey:"playerLocationDefault")
                self.mainCharacter.position = CGPoint(x:0.0,y:0.0)
                self.mainCharacter.image.position = CGPoint(x:0.0,y:0.0)
                UserDefaults.standard.set(NSCoder.string(for: self.mainCharacter.image.position), forKey: "playerLocationDefault")
               
            }

        }
        UserDefaults.standard.set(NSCoder.string(for: mainCharacter.image.position), forKey: "playerLocationDefault")
        //print(array)
        
    }
    
    func spawnItems() {
        var numCrownsPlaced = 0
        while (numCrownsPlaced < 5 - UserDefaults.standard.integer(forKey: "crowns")) { //Currently places 5 crowns
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
                crown.name = "crown";
                crown.physicsBody = SKPhysicsBody(circleOfRadius: 15.0)
                crown.physicsBody!.affectedByGravity = false;
                crown.physicsBody!.categoryBitMask = 1;
                crown.position = positionToSpawn
                self.addChild(crown)
                numCrownsPlaced = numCrownsPlaced + 1
            }
        }
        
        //Removed feature.
        var numCompassPlaced = 0
        while (numCompassPlaced < 0) {
            let xPos = Double(Int.random(in: -1616..<1616))
            let yPos = Double(Int.random(in: -1616..<1616))
            let adjustedX = ((xPos / 1616)*64) + 64
            let adjustedY = ((yPos / 1616)*64) + 64
            let location = vector2(Int32(adjustedY), Int32(adjustedX))
            let terrHeight = mainNoiseMap.value(at: location)
            if terrHeight > 0 {
                let positionToSpawn = CGPoint(x:xPos, y:yPos);
                let comp = SKSpriteNode(imageNamed: "black_garden_compass_1.png")
                comp.name = "compass";
                comp.physicsBody = SKPhysicsBody(circleOfRadius: 15.0)
                comp.physicsBody!.affectedByGravity = false;
                comp.physicsBody!.categoryBitMask = 1;
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
                sg.name = "shotgun";
                sg.physicsBody = SKPhysicsBody(circleOfRadius: 15.0)
                sg.physicsBody!.affectedByGravity = false;
                sg.physicsBody!.categoryBitMask = 1;
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
                sword.name = "sword";
                sword.physicsBody = SKPhysicsBody(circleOfRadius: 15.0)
                sword.physicsBody!.affectedByGravity = false;
                sword.physicsBody!.categoryBitMask = 1;
                sword.position = positionToSpawn
                self.addChild(sword)
                numSwordPlaced = numSwordPlaced + 1
            }
        }
    }
    
    func spawnRaven(positionX: Double, positionY: Double) {
        /*
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
        ravenOne.image = Raven(imageNamed: "raven_missionary_idle_1.png")
        let u = Raven(imageNamed: "raven_missionary_idle_1.png")
        u.test()
        ravenOne.image.name = "raven";
        ravenOne.image.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        ravenOne.image.physicsBody!.affectedByGravity = false;
        ravenOne.image.physicsBody!.categoryBitMask = 1;
        ravenOne.image.size = CGSize(width: 60, height: 90)
        ravenOne.image.position = ravenOne.position;
        print(ravenOne.image.position)
        // append to map
        self.addChild(ravenOne.image);
        // animate idle animation
        ravenOne.image.run(SKAction.repeatForever(SKAction.animate(with: ravenOne.array, timePerFrame: 0.2)), withKey: "idle")
        */
        
        // instantiate raven object
        let positionToSpawn = CGPoint(x:positionX, y:positionY);
        let ravenAtlas = SKTextureAtlas(named: "ravenMissionaryIdle")
        var frames = [SKTexture]()
        for i in 0...ravenAtlas.textureNames.count-1 {
            let name = "raven_missionary_idle_\(i).png";
            frames.append(SKTexture(imageNamed: name))
        }
        let rav2spawn = Raven(imageNamed: "raven_missionary_idle_1.png")
        rav2spawn.name = "raven";
        rav2spawn.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        rav2spawn.physicsBody!.affectedByGravity = false;
        rav2spawn.physicsBody!.categoryBitMask = 1;
        rav2spawn.size = CGSize(width: 60, height: 90)
        rav2spawn.position = positionToSpawn;
        rav2spawn.zPosition = 2
        self.addChild(rav2spawn);
        enemiesArray.append(NSCoder.string(for: rav2spawn.position))
        rav2spawn.run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 0.2)), withKey: "idle")
    }
    
}


