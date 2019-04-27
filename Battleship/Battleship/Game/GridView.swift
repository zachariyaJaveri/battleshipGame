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
        //not sure how to draw squares, just return
        return
    }
    
    
    var currentlySelectedSquare:Square?
    var curSelectedSquarePreviousState:Square.squareState = .nothing
    var squareLen:Double = 0
    var squareHeight:Double = 0
    var hasDrawnLettersAndNumbers:Bool = false
    var myBoard:Board? {
        didSet {
            // +1 because we need a "square" to show a letter and number on the board
            squareLen = Double(self.bounds.width) / Double(myBoard!.numRows + 1)
            squareHeight = Double(self.bounds.height) / Double(myBoard!.numCols + 1)
            print("THIS IS SQUARE LENGTH: \(squareLen)")
            print("THIS IS SQUARE HEIGHT: \(squareHeight)")
            setNeedsDisplay()
        }
    }
    func drawBoard(rect:CGRect) {
        //Handle lettering and numbering
        //Only have to do it if it hasn't been done before? (I'll find out soon enough)
        if !hasDrawnLettersAndNumbers {
            drawLettersAndNumbers(rect:rect)
            
        }
        
        //Draw the board as a grid
        for key in (myBoard?.squareBoard.keys)! {
            //make a "square"
            let rowIndex = Board.letters.firstIndex(of: key)!
            for col in (myBoard?.squareBoard[key]!.indices)! {
                //get the square from the board
                let squareToDraw = myBoard?.squareBoard[key]![col] ?? Square()
                drawSquare(x: squareLen * Double(col + 1), y: squareLen * Double(rowIndex + 1), squareToDraw: squareToDraw)
            }
        }
    }
    
    private func drawLettersAndNumbers(rect:CGRect) {
        
        if let boardRows = myBoard?.numRows, let boardCols = myBoard?.numCols {
            //draw letters
            for row in 1...boardRows {
                let squareForLabel = CGRect(x: squareLen * Double(row), y: 0.0, width: squareLen, height: squareHeight)
                let labelToAdd = UILabel(frame: squareForLabel)
                labelToAdd.text = String(row - 1)
                self.addSubview(labelToAdd)
            }
            
            //draw letters
            for col in 1...boardCols {
                let squareForLabel = CGRect(x: 0, y: squareLen * Double(col), width: squareLen, height: squareHeight)
                let labelToAdd = UILabel(frame: squareForLabel)
                labelToAdd.text = Board.letters[col - 1]
                self.addSubview(labelToAdd)
            }
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        drawBoard(rect: rect)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let spot = touches.first
        let location = spot!.location(in: self)
        
        //All this does is update what square was clicked
        if let currentSquare = findSquareInBoard(spot: location) {
            //The coordinate is in the grid on the board
            switch currentSquare.state {
            case .nothing:
                //You can only select on nothing, so previous square is set back to nothing
                if let previouslySelected = currentlySelectedSquare {
                    previouslySelected.state = .nothing
                }
                currentSquare.state = .selected
                currentlySelectedSquare = currentSquare
                break
            default:
                print("Selected a square that is not nothing")
                break
            }
        }
        setNeedsDisplay()
    }
    
    private func findSquareInBoard(spot:CGPoint) -> Square? {
        //Find out which square it's in
        let xSquare = Double(spot.x) / squareLen
        let ySquare = Double(spot.y) / squareHeight
        print("THIS IS THE X COORDINATE \(xSquare)")
        print("THIS IS THE Y COORDINATE \(ySquare)")
        
        //Account for the edges
        //Edges are on the left and the top
        if xSquare < 1 || ySquare < 1 {
            print("NOT IN GRID")
            return nil
        }
        
        let letter = Board.letters[Int(ySquare - 1)]
        print("THIS IS THE LETTER \(letter)")
        //Coordinates on the board are inverted
        let squareIndex = Int(xSquare - 1)
        print("THIS IS THE INDEX \(squareIndex)")
        //Return the square associated with this coordinate
        return myBoard?.squareBoard[letter]![squareIndex]
    }
}

protocol drawsBoards {
    func drawSquare(x:Double, y:Double, squareToDraw:Square)
}
