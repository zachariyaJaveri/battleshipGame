//
//  Board.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import UIKit

class GridView: UIView, drawsBoards {
    func drawSquare(x:Double, y:Double, squareToDraw:Square) {
        //not sure how to draw squares for a plain grid, just return
        return
    }
    
    //Global variables
    var currentlySelectedSquare:Square?
    var curSelectedSquarePreviousState:squareState = .nothing
    var squareLen:Double = 0
    var squareHeight:Double = 0
    var boardLen:Double = 0
    var boardHeight:Double = 0
    var hasDrawnLettersAndNumbers:Bool = false
    //When the board is set, reset the widths and heights and redraw the grid
    var myBoard:Board? {
        didSet {
            // +1 because we need a "square" to show a letter and number on the board
            print("THIS IS THE HEIGHT OF BOUNDS: \(self.bounds.height)")
            print("THIS IS THE WIDTH OF BOUNDS: \(self.bounds.width)")
            squareLen = Double(self.frame.width) / Double(myBoard!.numRows + 1)
            squareHeight = Double(self.frame.height) / Double(myBoard!.numCols + 1)
            print("THIS IS SQUARE LENGTH: \(squareLen)")
            print("THIS IS SQUARE HEIGHT: \(squareHeight)")
            boardLen = squareLen * Double((myBoard?.numCols)! + 1)
            boardHeight = squareHeight * Double((myBoard?.numRows)! + 1)
            setNeedsDisplay()
        }
    }
    //========================================================================
    // DRAW BOARD
    // --Draw a board as a grid
    //========================================================================
    func drawBoard(rect:CGRect) {
        //Handle lettering and numbering
        //Only have to do it if it hasn't been done before
        if !hasDrawnLettersAndNumbers {
            drawLettersAndNumbers(rect:rect)
        }
        
        //Go through our board and draw it as a grid
        for key in (myBoard?.squareBoard.keys)! {
            //make a "square"
            //The keys are not in order, so determine where they belong based on where they appear in "letters"
            let rowIndex = Board.letters.firstIndex(of: key)!
            //Go through all the squares for the row
            for col in (myBoard?.squareBoard[key]!.indices)! {
                //get the square from the board
                if let squareToDraw = myBoard?.squareBoard[key]![col] {
                    drawSquare(x: squareLen * Double(col + 1), y: squareLen * Double(rowIndex + 1), squareToDraw: squareToDraw)
                }
            }
        }
    }
    //========================================================================
    // DRAW LETTERS AND NUMBERS
    // Adds the letters and the numbers on the side of the grid
    //========================================================================
    private func drawLettersAndNumbers(rect:CGRect) {
        //These should be set, but to make life easier...
        if let boardRows = myBoard?.numRows, let boardCols = myBoard?.numCols {
            //draw numbers
            for row in 1...boardRows {
                //Make the "Square" that the label is drawn into
                //SquareLen / 3 centres the number well
                let squareForLabel = CGRect(x: (squareLen * Double(row)) + (squareLen / 3), y: 0.0, width: squareLen, height: squareHeight)
                let labelToAdd = UILabel(frame: squareForLabel)
                //TODO: MAKE NICE
                labelToAdd.text = String(row - 1)
                //
                self.addSubview(labelToAdd)
            }
            
            //draw letters
            for col in 1...boardCols {
                //Create the rectangle where the label will go
                let squareForLabel = CGRect(x: 0, y: squareLen * Double(col), width: squareLen, height: squareHeight)
                let labelToAdd = UILabel(frame: squareForLabel)
                //TODO: MAKE PRETTY
                labelToAdd.text = Board.letters[col - 1]
                //
                self.addSubview(labelToAdd)
            }
        }
        hasDrawnLettersAndNumbers = true
    }
    //========================================================================
    // DRAW
    // --just calls drawBoard
    //========================================================================
    override func draw(_ rect: CGRect) {
        drawBoard(rect: rect)
    }
    //========================================================================
    // FIND SQUARE IN BOARD
    // --Finds a Square in a board depending on where you clicked
    // --Returns: the square that was clicked
    //========================================================================
    func findSquareInBoard(spot:CGPoint) -> Square? {
        //Find out which square it's in
        let xSquare = Double(spot.x) / squareLen
        let ySquare = Double(spot.y) / squareHeight
//        print("THIS IS THE X COORDINATE \(xSquare)")
//        print("THIS IS THE Y COORDINATE \(ySquare)")
        
        //Account for the edges
        //Edges are on the left and the top
        if xSquare < 1 || ySquare < 1 || Double(spot.y) > boardHeight || Double(spot.x) > boardLen{
            print("NOT IN GRID")
            return nil
        }
        
        let letter = Board.letters[Int(ySquare - 1)]
//        print("THIS IS THE LETTER \(letter)")
        //Coordinates on the board are inverted
        let squareIndex = Int(xSquare - 1)
//        print("THIS IS THE INDEX \(squareIndex)")
        //Return the square associated with this coordinate
        return myBoard?.squareBoard[letter]![squareIndex]
    }
}
//========================================================================
// PROTOCOL THAT SAYS THAT IT DRAWS BOARDS
//========================================================================
protocol drawsBoards {
    func drawSquare(x:Double, y:Double, squareToDraw:Square)
}
