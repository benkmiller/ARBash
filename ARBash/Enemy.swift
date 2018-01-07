//
//  Enemy.swift
//  ARBash
//
//  Created by Ben Miller on 2018-01-03.
//  Copyright © 2018 Ben Miller. All rights reserved.
//

import Foundation
import SceneKit

class Enemy:SCNNode {
    
    func placeAtPosition(position:SCNVector3){
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        cubeNode.physicsBody?.isAffectedByGravity = false
        cubeNode.physicsBody!.mass = 2.0
        
        cubeNode.position = position // SceneKit/AR coordinates are in meters
        self.addChildNode(cubeNode)
    }
    
}

