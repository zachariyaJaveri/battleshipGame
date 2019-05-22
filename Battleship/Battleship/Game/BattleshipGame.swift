//
//  BattleshipGame.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-09.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation

class BattleshipGame{
    //constants
    let BOARD_LEN = 8
    let BOARD_WID = 8
    //For scoring
    let SHIP_HIT_SCORE = 5
    //We add this negative
    let SHIP_MISS_SCORE = -1
    //variables
    var me = "Me"
    var you = "You"
    var myFleet:[Ship] = []
    var myBoard:Board?
    var yourBoard:Board?
    
    var myScore:Int = 0
    var enemyScore:Int = 0
    var myPlayerNumber = 0
    var currentPlayer = 0
    var myTurn:Bool {return myPlayerNumber == currentPlayer}
    
    //========================================================================
    // Update Enemy Board
    // --Updates the state of a square on the enemy board
    // --This is called after we get the "newState" of a tile
    //========================================================================
    func updateEnemyBoard(at:Coordinate, newState:squareState){
        //Handle score
        if newState == .hit {
            myScore += SHIP_HIT_SCORE
        }
        else if newState == .miss {
            myScore += SHIP_MISS_SCORE
        }
        
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
    //========================================================================
    // FIRE!!!!!!
    // --"Attacks" a square on our board, this is only called when WE are fired at
    //========================================================================
    func fire(at: Coordinate)->squareState {
        if let board = myBoard {
            let newState = board.fireAt(coordinate:at)
            //Scoring
            if newState == .hit {
                enemyScore += SHIP_HIT_SCORE
            }
            else if newState == .miss {
                enemyScore += SHIP_MISS_SCORE
            }
            
            return newState
        }
        else {
            return .miss
        }
    }
    //========================================================================
    // Check state
    // --Returns the state of a particular square
    //========================================================================
    func checkState(at:Coordinate)->squareState {
        return (myBoard?.squareBoard[at.letter]![at.index].state)!
    }
    
    //========================================================================
    // isFleetExhausted
    // --Checks if all our ships are sunk or not
    //========================================================================
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
