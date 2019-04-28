//
//  playerBoard.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation
import UIKit

class PlayerGrid:GridView {
    //========================================================================
    // Draws a single square
    //========================================================================
    override func drawSquare(x:Double, y:Double, squareToDraw:Square) {
        //Create the box
        let box = CGRect(x: x, y: y, width: squareLen, height: squareHeight)
        //Using the UIBezierPath to draw is easier
        let path = UIBezierPath(rect: box)
        
        //Determine the color filling
        //We want to show our ships
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
}
