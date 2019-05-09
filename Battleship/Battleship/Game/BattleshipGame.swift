//
//  BattleshipGame.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-09.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation

class BattleshipGame{
    
    var me = "Me"
    var you = "You"
    var myFleet:[Ship]
    var yourFleet:[Ship]
    var myBoard:[String:[String]] //TODO:Change second string to Square
    var yourBoard:[String:[String]] //TODO:Change second string to Square
    
    var myPlayerNumber = 0
    var currentPlayer = 0
    var myTurn:Bool {return myPlayerNumber == currentPlayer}
    
    // Update Board
    // - Updates the state of a square on the board
    func updateBoard(at:String, newState:String){
        //TODO
    }
    
    // Check State
    // - returns the state of a particular square
    func checkState(at:String)->String{ //TODO should return a Square.state
        //TODO
        return "state" //TODO so this line doesn't complain for now
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
    
    init(myFleet:[Ship], yourFleet:[Ship], myBoard:[String:[String]], yourBoard:[String:[String]]){
        self.myFleet = myFleet
        self.yourFleet = yourFleet
        self.myBoard = myBoard
        self.yourBoard = yourBoard
    }
}
