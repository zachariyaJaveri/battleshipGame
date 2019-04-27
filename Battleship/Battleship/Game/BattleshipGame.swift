//
//  BattleshipGame.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-09.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation

class BattleshipGame{
    
    let BOARD_LEN = 8
    let BOARD_WID = 8
    var me = "Me"
    var you = "You"
    var myFleet:[Ship] = []
    var yourFleet:[Ship] = [] //Are we even keeping this?
    var myBoard:Board?
    var yourBoard:Board?
    
    var myPlayerNumber = 0
    var currentPlayer = 0
    var myTurn:Bool {return myPlayerNumber == currentPlayer}
    
    // Update Board
    // - Updates the state of a square on the board
    func updateBoard(at:Coordinate, newState:squareState){
        
        if myTurn {
            
        }
        else {
            
        }
    }
    
    // Check State
    // - returns the state of a particular square
    func checkState(at:Coordinate)->squareState {
        return (myBoard?.squareBoard[at.letter]![at.index].state)!
    }
    
    // Is Fleet Exhausted ?
    // - returns true if all your ships have been destroyed
    func isFleetExhausted()->Bool{
        for ship in myFleet{
            if !ship.isSunk(){
                //You still have ships that are alive
                return false
            }
        }
        //All your ships have been destroyed
        return true
    }
}
