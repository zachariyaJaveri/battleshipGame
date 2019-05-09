//
//  Ship.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-09.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation

class Ship{
    
    //TODO: change this to squares instead of strings
    var myShip:[String]
    
    // Is Sunk?
    // returns true if ship is sunk (all square states are hit)
    func isSunk()->Bool{
        var count = 0
        for square in myShip{
            //TODO: if square.state == Square.state.hit
            // count ++
        }
        return count == myShip.count
    }
    
    init(length:Int){
        myShip = []
        for _ in 1...length{
            myShip.append("square") //TODO: actually append Squares
        }
    }
}
