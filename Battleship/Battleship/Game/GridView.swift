//
//  Board.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import UIKit

class GridView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func drawGrid() {
        //I don't know what type of board this is so don't draw it
        return
    }
}

protocol drawableBoard {
    func drawBoard()
}
