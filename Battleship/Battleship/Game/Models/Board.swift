//
//  Board.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation
import UIKit

class Board {
    //========================================================================
    // Global variables
    //========================================================================
    var squareBoard = [String:[Square]]()
    static let letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var numRows:Int
    var numCols:Int
    //========================================================================
    // Prints the current board (For debug purposes)
    //========================================================================
    func dumpBoard() {
        print(squareBoard)
    }
    //========================================================================
    // Given a coordinate, finds the associated square and updates its state
    //      depending on what it was before
    // --Returns: The new state of the square
    //========================================================================
    func fireAt(coordinate:Coordinate) -> squareState {
        //Find the square in the board
        if let square = findSquareFromCoordinate(coord: coordinate) {
            //Only change the state if it's nothing or a ship
            switch square.state {
            case .nothing:
                square.state = .miss
                break
            case .ship:
                square.state = .hit
                break
            default:
                break
            }
            
            return square.state
        }
        
        return .miss
    }
    //========================================================================
    // Goes through the board and finds the square for the coordinate
    //========================================================================
    func findSquareFromCoordinate(coord:Coordinate) -> Square? {
        //This is not the best implementation, but I don't have time to modify it
        // The best implementation would just use the coordinate letter and index
        let dummySquare = Square(coordinate: coord)
        
        for key in squareBoard.keys {
            let squares = squareBoard[key]
            for square in squares! {
                if square == dummySquare {
                    return square
                }
            }
        }
        
        return nil
    }
    //========================================================================
    // Creates a board based on the provided size
    //========================================================================
    init(rows:Int, cols:Int) {
        numRows = rows
        numCols = cols
        for row in 0...rows - 1 {
            //Make a row
            squareBoard[Board.letters[row]] = [Square]()
            
            for col in 0...cols - 1 {
                //Add columns
                squareBoard[Board.letters[row]]?.append(Square(coordinate: Coordinate(letter: Board.letters[row], index: col)))
            }
        }
    }
}
