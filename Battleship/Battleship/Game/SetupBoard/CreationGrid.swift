//
//  CreationGrid.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-17.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation
import UIKit

class CreationGrid:GridView {
    var selectedSquares:[Square] = [Square]()
    var rowOfSquares:Bool?
    
    override func drawSquare(x: Double, y: Double, squareToDraw: Square) {
        let box = CGRect(x: x, y: y, width: squareLen, height: squareHeight)
        let path = UIBezierPath(rect: box)
        
        //Determine the color filling
        switch squareToDraw.state {
        case .hit:
            UIColor.red.setFill()
            break
        case .miss:
            UIColor.blue.setFill()
            break
        case .ship:
            UIColor.green.setFill()
            break
        case .nothing:
            UIColor.white.setFill()
            break
        case .selected:
            UIColor.lightGray.setFill()
        }
        
        path.fill()
        path.stroke()
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
                //Find out if square is adjacent
                //Append to array?
                //Change state to selected
                print("THIS IS THE COORDINATE OF THE CURRENT SQUARE: \(currentSquare.coordinate)")
                let squareIsAdjacent = determineIfSquareAdjacent(squareToCheck: currentSquare)
                if(squareIsAdjacent) {
                    currentSquare.state = .selected
                    selectedSquares.append(currentSquare)
                }
                else {
                    for square in selectedSquares {
                        square.state = .nothing
                    }
                    selectedSquares.removeAll()
                    rowOfSquares = nil
                    currentSquare.state = .selected
                    selectedSquares.append(currentSquare)
                }
                break
            default:
                print("Selected a square that is not nothing")
                break
            }
        }
        setNeedsDisplay()
    }
    
    func determineIfSquareAdjacent(squareToCheck:Square) -> Bool {
        //Have any other squares been selected?
        if selectedSquares.count > 0 {
            //Check for only 1 square
            if let rows = rowOfSquares {
                print("MORE THAN 1 SQUARE")
                print("IS HORIZONTALLY ADJACENT? \(determineHorizontallyAdjacent(squareToCheck: squareToCheck))")
                print("IS VERTICALLY ADJACENT? \(determineVerticallyAdjacent(squareToCheck: squareToCheck))")
                //more than 1 square
                //Are we working with horizontal or vertical?
                if rows {
                    print("CHECKING ROWS")
                    return determineHorizontallyAdjacent(squareToCheck:squareToCheck)
                }
                else {
                    print("CHECKING COLUMNS")
                    return determineVerticallyAdjacent(squareToCheck:squareToCheck)
                }
            }
            else {
                //Only 1 square
                //Figure out if this is a row of Squares or a column of Squares
                print("ONLY 1 SQUARE")
                print("IS HORIZONTALLY ADJACENT? \(determineHorizontallyAdjacent(squareToCheck: squareToCheck))")
                print("IS VERTICALLY ADJACENT? \(determineVerticallyAdjacent(squareToCheck: squareToCheck))")
                
                let horizontal = determineHorizontallyAdjacent(squareToCheck: squareToCheck)
                let vertical = determineVerticallyAdjacent(squareToCheck: squareToCheck)
                
                if horizontal && vertical {
                    //NO DIAGONALS GODDANG IT
                    rowOfSquares = nil
                    return false
                }
                else if horizontal {
                    //it's a row of squares
                    rowOfSquares = true
                    return true
                }
                else if vertical {
                    rowOfSquares = false
                    return true
                }
                else {
                    return false
                }
                
            }
        }
        else {
            //No Squares have been selected yet
            print("NO SQUARES")
            rowOfSquares = nil
            return true
        }
    }
    
    func determineHorizontallyAdjacent(squareToCheck:Square) -> Bool{
        print("HORIZONTAL")
        var firstSquare:Square?
        var lastSquare:Square?
        
        //Find the "first" and "last" square of the array
        //Squares are not in order in the array
        for square in selectedSquares {
            if let first = firstSquare, let last = lastSquare {
                if square.coordinate.index < first.coordinate.index {
                    firstSquare = square
                }
                else if square.coordinate.index > last.coordinate.index {
                    lastSquare = square
                }
            }
            else {
                firstSquare = square
                lastSquare = square
            }
        }
        print("THIS IS THE FIRST SQUARE: \(firstSquare!.toString())")
        print("THIS IS THE LAST SQUARE: \(lastSquare!.toString())")
        
        if firstSquare!.coordinate.letter != squareToCheck.coordinate.letter {
            return false
        }
        
        //Check if it's next to the first square
        //Check only the left side (the lastSquare handles the right)
        if squareToCheck.coordinate.index + 1 == firstSquare?.coordinate.index {
            return true
        }
        
        //It's not to the left, check if it's to the right
        //Check if it's to the right of the last square
        return squareToCheck.coordinate.index - 1 == lastSquare?.coordinate.index
    }
    
    func determineVerticallyAdjacent(squareToCheck:Square) -> Bool{
        print("VERTICAL")
        var firstSquare:Square?
        var lastSquare:Square?
        
        //Find the "first" and "last" square of the array
        //Squares are not in order in the array
        for square in selectedSquares {
            if let first = firstSquare, let last = lastSquare {
                //We want to compare the indexes of the letters for the squares
                let firstIndex = Board.letters.firstIndex(of: first.coordinate.letter)
                let lastIndex = Board.letters.firstIndex(of: last.coordinate.letter)
                let curIndex = Board.letters.firstIndex(of: square.coordinate.letter)
                
                if curIndex! < firstIndex! {
                    firstSquare = square
                }
                else if curIndex! > lastIndex!{
                    lastSquare = square
                }
            }
            else {
                firstSquare = square
                lastSquare = square
            }
        }
        print("THIS IS THE FIRST SQUARE: \(firstSquare!.toString())")
        print("THIS IS THE LAST SQUARE: \(lastSquare!.toString())")
        //Get the letter of the index for our first, last and current square
        if firstSquare!.coordinate.index != squareToCheck.coordinate.index {
            return false
        }
        
        let firstIndex = Board.letters.firstIndex(of: firstSquare!.coordinate.letter)
        let lastIndex = Board.letters.firstIndex(of: lastSquare!.coordinate.letter)
        let curIndex = Board.letters.firstIndex(of: squareToCheck.coordinate.letter)
        
        //Check if it's next to the first square
        //Check only the left side (the lastSquare handles the right)
        if curIndex! + 1 == firstIndex! {
            return true
        }
        
        //It's not to the left, check if it's to the right
        //Check if it's to the right of the last square
        return curIndex! - 1 == lastIndex!
    }
}


