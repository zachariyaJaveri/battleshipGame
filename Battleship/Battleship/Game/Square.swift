//
//  Square.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation

class Square {
    enum squareState:String {
        case nothing
        case ship
        case hit
        case miss
    }
    
    var state:squareState = .nothing
}
