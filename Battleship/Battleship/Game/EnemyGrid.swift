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
