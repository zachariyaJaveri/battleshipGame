//
//  Board.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation

class Board:drawableBoard {
    
    var squareBoard = [String:[Square]]()
    private let letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    func drawBoard() {
        return;
    }
    
    func dumpBoard() {
        print(squareBoard)
    }
    
    init(boardLength len:Int, boardWidth wid:Int) {
        
        for row in 0...len {
            //Make a row
            squareBoard[letters[row]] = [Square]()
            
            for _ in 0...wid {
                //Add columns
                squareBoard[letters[row]]?.append(Square())
            }
        }
    }
}
