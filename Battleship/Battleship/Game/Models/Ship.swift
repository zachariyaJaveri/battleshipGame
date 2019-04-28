//
//  Ship.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-09.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation

class Ship{
    //VARIABLES
    var myShip:[Square] = [Square]()
    
    //========================================================================
    // Is Sunk?
    // returns true if all squares are hit
    //========================================================================
    func isSunk()->Bool{
        var count = 0
        for square in myShip{
            if square.state == .hit {
                count += 1
            }
        }
        return count == myShip.count
    }
    //========================================================================
    // INIT, passed the squares that represent the ship
    //========================================================================
    init(squares myShip:[Square]) {
        self.myShip = myShip
    }
}
