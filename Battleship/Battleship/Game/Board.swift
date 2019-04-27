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
    
    var squareBoard = [String:[Square]]()
    static let letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var numRows:Int
    var numCols:Int
    
    func dumpBoard() {
        print(squareBoard)
    }
    
    func fireAt(coordinate:Coordinate) -> squareState {
        if let square = findSquareFromCoordinate(coord: coordinate) {
            switch square.state {
            case .nothing, .selected:
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
    
    func findSquareFromCoordinate(coord:Coordinate) -> Square? {
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
