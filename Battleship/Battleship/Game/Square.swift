//
//  Square.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation
import UIKit

class Square {
    enum squareState:String {
        case nothing
        case ship
        case hit
        case miss
        case selected
    }
    
    var state:squareState = .nothing
    var coordinate:Coordinate
    init(coordinate:Coordinate) {
        self.coordinate = coordinate
    }
}

struct Coordinate {
    var letter:String
    var index:Int
    
    init(letter:String, index:Int) {
        self.letter = letter
        self.index = index
    }
}
