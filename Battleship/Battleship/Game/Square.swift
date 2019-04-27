//
//  Square.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation
import UIKit

class Square:Equatable {
    static let delimiter:Character = ";"
    
    static func == (lhs: Square, rhs: Square) -> Bool {
        return lhs.coordinate.index == rhs.coordinate.index && lhs.coordinate.letter == rhs.coordinate.letter
    }
    
    var state:squareState = .nothing
    var coordinate:Coordinate
    init(coordinate:Coordinate) {
        self.coordinate = coordinate
    }
    
    func toString()->String {
        return coordinate.toString() + String(Square.delimiter) + state.toString()
    }
    
    static func fromString(textSquare:String)-> Square {
        let parsedSquare = textSquare.split(separator: Square.delimiter)
        
        let squareToReturn = Square(coordinate: Coordinate.fromString(coordinateString: String(parsedSquare[0])))
        
        squareToReturn.state = squareState.fromString(state:String(parsedSquare[1]))
        
        return squareToReturn
    }
}

struct Coordinate {
    var letter:String
    var index:Int
    static let delimiter:Character = ","
    
    init(letter:String, index:Int) {
        self.letter = letter
        self.index = index
    }
    
    func toString()->String {
        return letter + String(Coordinate.delimiter) + String(index)
    }
    
    static func fromString(coordinateString:String)-> Coordinate {
        let parsedCoordinate = coordinateString.split(separator: Coordinate.delimiter)
        
        return Coordinate(letter: String(parsedCoordinate[0]), index: Int(parsedCoordinate[1])!)
    }
}

enum squareState:String {
    case nothing
    case ship
    case hit
    case miss
    case selected
    
    func toString() -> String {
        switch self {
        case .nothing:
            return "nothing"
        case .hit:
            return "hit"
        case .miss:
            return "miss"
        case .selected:
            return "selected"
        case .ship:
            return "ship"
        }
    }
    
    static func fromString(state:String) -> squareState {
        switch state {
        case "nothing":
            return .nothing
        case "hit":
            return .hit
        case "miss":
            return .miss
        case "selected":
            return .selected
        case "ship":
            return .ship
        default:
            return .nothing
        }
    }
}
