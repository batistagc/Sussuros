//
//  GameViewController.swift
//  Oregano
//
//  Created by Gabriel Batista Cristiano on 16/09/21.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = NewGameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            
            view.presentScene(scene)
        }

    }
    



}
