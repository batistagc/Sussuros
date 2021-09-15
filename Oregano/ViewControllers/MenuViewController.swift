//
//  MenuViewController.swift
//  Oregano
//
//  Created by Gabriel Batista Cristiano on 14/09/21.
//

import UIKit
import SpriteKit

class MenuViewController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            
            view.presentScene(scene)
        }
    
    }

}
