//
//  GameViewController.swift
//  eggCatcher
//
//  Created by user169480 on 4/15/20.
//  Copyright © 2020 user169480. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButtonAction(_ sender: Any) {
        playClick()
        playButton.isHidden = true
        logoLabel.isHidden = true
        backgroundImg.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        
        
    
    public func playClick(){
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
