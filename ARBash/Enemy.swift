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
    
    //var cubeNode: SCNNode
    //init() {
        //cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
    //}

    func placeAtPosition(position:SCNVector3){
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        
        
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        cubeNode.physicsBody?.isAffectedByGravity = false
        cubeNode.physicsBody!.mass = 2.0
        //cubeNode.physicsBody!.categoryBitMask = SCNPhysicsCollisionCategory.
        
        cubeNode.position = position // SceneKit/AR coordinates are in meters
        
        //cubeNode.physicsBody = [SCNPhysicsBodybodyWithType:SCNPhysicsBodyTypeDynamic shape:nil];
        //cubeNode.physicsBody.mass = 2.0;
        //cubeNode.physicsBody.categoryBitMask = CollisionCategoryCube;
        //cubeNode.position = position;
        
        
        
        self.addChildNode(cubeNode)
    }
    
    
    //move enemy towards toPosition, normally towards player
//    func move(toPosition: SCNVector3, ) -> Bool {
//        let deltaPos = (toPosition - node.position)
//        guard deltaPos >= 0.05 else {return false}
//        
//        return false
//    }
}

