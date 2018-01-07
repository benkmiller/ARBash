//
//  GameModel.swift
//  ARBash
//
//  Created by Ben Miller on 2018-01-06.
//  Copyright © 2018 Ben Miller. All rights reserved.
//

import Foundation

class GameModel {
    
    var enemyCount = 0
    var spawnNum = 0
    let spawnNew = 100
    let maxEnemies = 3
    
    var deadFlag = false
    
    func isTimeToSpawn() -> Bool {
        guard enemyCount <= maxEnemies else { return false }
        
        if(spawnNum >= spawnNew){
            spawnNum = 0
            return true
        }
        
        return false
    }
    
    func incSpawn(){
        spawnNum += 1;
    }
    
    func removeEnemy(){
        if(enemyCount <= 0){
            print("shouldnt be removing an enemy..")
        }
        enemyCount -= 1
    }
    
    func addEnemy(){
        if(enemyCount >= maxEnemies){
            print("shouldnt be adding an enemy..")
        }
        enemyCount += 1
    }
    
}
