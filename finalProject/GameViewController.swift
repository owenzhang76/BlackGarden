//
//  GameViewController.swift
//  finalProject
//
//  Created by Tory F on 11/19/20.
//  Copyright © 2020 Tory Farmer. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        
    
    }

    //function that pushes on win view controller
    
    func pushWinView() {
        print("hi")
      
        //let winVC = WinViewController()
 //       navigationController?.pushViewController(winVC, animated: true)
        //let winVC = WinViewController()
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WinViewController") as? WinViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
      
        self.performSegue(withIdentifier: "win", sender: nil)
       // self.present(winVC, animated: true, completion: nil)

        
    }
    
//    override func show(_ vc: UIViewController, sender: Any?) {
//         self.remove()
//         contentViewController = vc
//         add(vc)
//     }
    
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
