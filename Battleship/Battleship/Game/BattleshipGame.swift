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
    var myBoard:Board?
    var yourBoard:Board?
    
    var myPlayerNumber = 0
    var currentPlayer = 0
    var myTurn:Bool {return myPlayerNumber == currentPlayer}
    
    // Update Enemy Board
    // - Updates the state of a square on the board
    func updateEnemyBoard(at:Coordinate, newState:squareState){
        let dummySquare = Square(coordinate: at)
        for key in yourBoard!.squareBoard.keys {
            let squares = yourBoard!.squareBoard[key]
            for square in squares! {
                if dummySquare == square {
                    square.state = newState
                    return
                }
            }
        }
    }
    
    func fire(at: Coordinate)->squareState {
        if let board = myBoard {
            return board.fireAt(coordinate:at)
        }
        else {
            return .miss
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
