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
    //========================================================================
    // Static variables
    //========================================================================
    static let delimiter:Character = ";"
    //========================================================================
    // Squares can be compared to see if they are the same
    // based off their coordinate
    //========================================================================
    static func == (lhs: Square, rhs: Square) -> Bool {
        return lhs.coordinate.index == rhs.coordinate.index && lhs.coordinate.letter == rhs.coordinate.letter
    }
    //VARIABLES
    var state:squareState = .nothing
    var coordinate:Coordinate
    //========================================================================
    // Create a square with the specified coordinate
    //========================================================================
    init(coordinate:Coordinate) {
        self.coordinate = coordinate
    }
    //========================================================================
    // Creates a string representation of a square for the server
    //========================================================================
    func toString()->String {
        return coordinate.toString() + String(Square.delimiter) + state.toString()
    }
    //========================================================================
    // Creates a square from its string representation
    //========================================================================
    static func fromString(textSquare:String)-> Square {
        //Parse the square into a coordinate string and a state string
        let parsedSquare = textSquare.split(separator: Square.delimiter)
        
        //Create the square based off the coordinate string
        let squareToReturn = Square(coordinate: Coordinate.fromString(coordinateString: String(parsedSquare[0])))
        
        //Set the state
        squareToReturn.state = squareState.fromString(state:String(parsedSquare[1]))
        
        return squareToReturn
    }
}
//========================================================================
// A structure that represents a square's location in a grid
//========================================================================
struct Coordinate {
    //VARIABLES
    var letter:String
    var index:Int
    static let delimiter:Character = ","
    
    //========================================================================
    // Init, letter and Coordinate MUST be set
    //========================================================================
    init(letter:String, index:Int) {
        self.letter = letter
        self.index = index
    }
    //========================================================================
    // creates a string representation of a coordinate
    //========================================================================
    func toString()->String {
        return letter + String(Coordinate.delimiter) + String(index)
    }
    //========================================================================
    // creates a coordinate from its string format
    //========================================================================
    static func fromString(coordinateString:String)-> Coordinate {
        let parsedCoordinate = coordinateString.split(separator: Coordinate.delimiter)
        
        return Coordinate(letter: String(parsedCoordinate[0]), index: Int(parsedCoordinate[1])!)
    }
}
//========================================================================
// Enum that represents the state of a square
//========================================================================
enum squareState:String {
    //========================================================================
    // All the possible states for a square
    //========================================================================
    case nothing
    case ship
    case hit
    case miss
    case selected
    //========================================================================
    // returns the string version of a state
    //========================================================================
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
    //========================================================================
    // returns a state from its string representation
    //========================================================================
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
