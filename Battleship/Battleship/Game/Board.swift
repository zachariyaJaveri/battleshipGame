//
//  Board.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation
import UIKit

class Board:UIView, drawableBoard {
    
    var squareBoard = [String:[Square]]()
    private let letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var boardSize:Int
    
    func drawBoard() {
        return;
    }
    
    // Draw all the Squares in the squareBoard hashmap
    override func draw(_ rect: CGRect) {
        for column in squareBoard{
            for square in column.value{
                square.draw()
            }
        }
    }
    
    func dumpBoard() {
        print(squareBoard)
    }
    
    init(boardLength len:Int, boardWidth wid:Int) {
        boardSize = letters.count
        for row in 0...len {
            //Make a row
            squareBoard[letters[row]] = [Square]()
            
            for _ in 0...wid {
                //Add columns
                squareBoard[letters[row]]?.append(Square(X:1,Y:1,size:1,isClickable:false)) //TODO - I put random numbers so it won't complain
            }
        }
    }
}
