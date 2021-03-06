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

      cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
      cubeNode.physicsBody?.isAffectedByGravity = false
      cubeNode.physicsBody!.mass = 2.0
  

      cubeNode.position = position // SceneKit/AR coordinates are in meters

  }
  
  func throwCube(position:SCNVector3, direction: SCNVector3){
    let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
 
    cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
    cubeNode.physicsBody!.isAffectedByGravity = true

    print("x= " ,direction.x*2)
    print("y= " , direction.y*2)
    print("z= " , direction.z*2)
    print("pos")
    print("x= " ,position.x)
    print("y= " , position.y)
    print("z= " , position.z)

    let vect = SCNVector3Make(direction.x*10, direction.y*10, direction.z*10)
    cubeNode.position = position
    cubeNode.physicsBody!.applyForce(vect, asImpulse: true)
    
    self.addChildNode(cubeNode)
  }
    
}
