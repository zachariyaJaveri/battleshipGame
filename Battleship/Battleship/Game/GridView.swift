//
//  Board.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import UIKit

class GridView: UIView, drawsBoards {
    
    var myBoard:Board?
    var currentlySelectedSquare:Square?
    
    func drawBoard(rect:CGRect) {
        //Not sure what type of board I'm drawing, so just exit
        return
    }
    
    override func draw(_ rect: CGRect) {
        drawBoard(rect: rect)
    }
 
}

protocol drawsBoards {
    func drawBoard(rect:CGRect)
}
