//
//  Cube.swift
//  ARBash
//
//  Created by Ben Miller on 2017-11-28.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import Foundation
import SceneKit

class Cube: SCNNode{
    
  func placeAtPosition(position:SCNVector3){
      let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))

      //cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)


      cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
      //cubeNode.physicsBody?.isAffectedByGravity = false
      cubeNode.physicsBody!.mass = 2.0
      //cubeNode.physicsBody!.categoryBitMask = SCNPhysicsCollisionCategory.

      cubeNode.position = position // SceneKit/AR coordinates are in meters



      //cubeNode.physicsBody = [SCNPhysicsBodybodyWithType:SCNPhysicsBodyTypeDynamic shape:nil];
      //cubeNode.physicsBody.mass = 2.0;
      //cubeNode.physicsBody.categoryBitMask = CollisionCategoryCube;
      //cubeNode.position = position;



      self.addChildNode(cubeNode)
  }
  
  
  
  
  
  func throwCube(position:SCNVector3, direction: SCNVector3){
    let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
    
    //cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
    
    
    cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
    cubeNode.physicsBody!.isAffectedByGravity = false
    //cubeNode.physicsBody!.mass = 2.0
    
    //cubeNode.physicsBody!.categoryBitMask = SCNPhysicsCollisionCategory.
    //cubeNode.physicsBody!.applyForce(SCNVector3Make(0, 0, 5), asImpulse: true)
    cubeNode.position = position
    cubeNode.physicsBody!.applyForce(direction, asImpulse: true)
    
    // SceneKit/AR coordinates are in meters
    
    
    
    //cubeNode.physicsBody = [SCNPhysicsBodybodyWithType:SCNPhysicsBodyTypeDynamic shape:nil];
    //cubeNode.physicsBody.mass = 2.0;
    //cubeNode.physicsBody.categoryBitMask = CollisionCategoryCube;
    //cubeNode.position = position;
    
    
    
    self.addChildNode(cubeNode)
  }
  
  func remove(){
    
  }
    
}
