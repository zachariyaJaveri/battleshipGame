//
//  Square.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation
import UIKit

class Square {
    enum squareState:String {
        case nothing
        case ship
        case hit
        case miss
    }
    
    var state:squareState = .nothing
    
    var X:CGFloat
    var Y:CGFloat
    var size:CGFloat
    var isClickable:Bool
    
    //Check if point is inside the square
    func hasPoint(X:CGFloat, Y:CGFloat)->Bool{
        return (X>self.X && X<self.X+size && Y>self.Y && Y<self.Y+size)
    }
    
    //draw a square
    func draw(){
        let path = UIBezierPath()
        path.move(to: CGPoint(x:X,y:Y))
        path.addLine(to: CGPoint(x:X,y:Y+size))
        path.addLine(to: CGPoint(x:X+size,y:Y+size))
        path.addLine(to: CGPoint(x:X+size,y:Y))
        path.close()
        path.stroke()
    }
    
    init(X:CGFloat,Y:CGFloat,size:CGFloat,isClickable:Bool){
        self.X = X
        self.Y = Y
        self.size = size
        self.isClickable = isClickable
    }
}
