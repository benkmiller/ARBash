//
//  Plane.swift
//  ARBash
//
//  Created by Ben Miller on 2017-11-28.
//  Copyright © 2017 Ben Miller. All rights reserved.
//

import Foundation
import SceneKit
import ARKit


class Plane: SCNNode{

    var anchor: ARPlaneAnchor?
    var planeActual: SCNBox?
    
    //called in render:didadd:node
    func initPlane(anchor: ARPlaneAnchor, isHidden: Bool){
        self.anchor = anchor
        let width = anchor.extent.x
        let length = anchor.extent.x
        let planeHeight = 0.1
        
        let transparentMaterial = SCNMaterial()
        transparentMaterial.diffuse.contents = UIColor(white: 1.0, alpha: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        planeActual = SCNBox(width: CGFloat(width), height: CGFloat(planeHeight), length: CGFloat(length), chamferRadius: 0)
        planeActual!.materials = [transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, material, transparentMaterial]
        
        let planeNode = SCNNode(geometry: planeActual)
        planeNode.position = SCNVector3Make(0, Float(-planeHeight/2), 0)
        planeNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: planeActual!, options: nil))
        
        addChildNode(planeNode)
        
    }
    
    func update(anchor: ARPlaneAnchor){
        planeActual!.width = CGFloat(anchor.extent.x)
        planeActual!.height = CGFloat(anchor.extent.z)
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        let node = childNodes.first
        node?.physicsBody = SCNPhysicsBody(type:SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape(geometry: planeActual!, options: nil))
    }
    
}
