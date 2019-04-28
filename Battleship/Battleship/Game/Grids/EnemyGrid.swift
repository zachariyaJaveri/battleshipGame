//
//  enemyBoard.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation
import UIKit

class EnemyGrid:GridView {
    //========================================================================
    // Handle what happens when the grid is touched
    //========================================================================
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let spot = touches.first
        let location = spot!.location(in: self)
        
        //All this does is update what square was clicked
        if let currentSquare = findSquareInBoard(spot: location) {
            //The coordinate is in the grid on the board
            switch currentSquare.state {
            case .nothing:
                //Is something selected already?
                if let curSquare = currentlySelectedSquare {
                    //It's possible that the square has been modified since its selection
                    if curSquare.state == .selected {
                        curSquare.state = .nothing
                    }
                }
                //Select this square
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
    //========================================================================
    // Draws a single square
    //========================================================================
    override func drawSquare(x:Double, y:Double, squareToDraw:Square) {
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
            //Don't show the enemy ships
            UIColor.white.setFill()
            break
        case .nothing:
            UIColor.white.setFill()
            break
        case .selected:
            UIColor.lightGray.setFill()
            break
        }
        path.fill()
        path.stroke()
    }
}
