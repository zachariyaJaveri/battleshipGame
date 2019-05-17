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
