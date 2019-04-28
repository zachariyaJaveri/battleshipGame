//
//  GameServerController.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-17.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation

class GameServerController: ClientServerListenerDelegate {
    
    var client:Client? { didSet { client?.listenerDelegate = self } }
    var gameServerViewDelegate:GameServerViewDelegate?
    var battleshipGame:BattleshipGame = BattleshipGame()
    var numberOfPlayers = 0 {didSet { gameServerViewDelegate?.numPlayersChangedUpdateView()}}
    let serverData = ServerReceivedData()
    
    init() {
        print ("boo")
    }
    // ----------------------------------------------------
    // somebody connected
    // ----------------------------------------------------
    func someBodyConnected (userData data:ClientReceivedData) {
        print("SOMEBODY CONNECTED")
        print("THIS IS MYPLAYER NUMBER: \(battleshipGame.myPlayerNumber)")
        if battleshipGame.myPlayerNumber != data.player {
            battleshipGame.you = data.username
            client?.addToOutputQueue(thisData: "iam:\(battleshipGame.me)")
        }
    }
    
    // ----------------------------------------------------
    // any error, so just bail
    // ----------------------------------------------------
    func clientListenerReceived(errorString error: String) {
        client?.closeSocket()
        gameServerViewDelegate?.gameServerErrorReceived()
    }
    
    // ----------------------------------------------------
    // we got data from the server
    // ----------------------------------------------------
    func clientListenerReceived(rawData data: String) {
        let receivedData = ClientReceivedData(rawData: data)
        
        switch receivedData.dataType {
        case .listenerConnectionNumbers:
            print("UPDATING NUMBER OF PLAYERS")
            numberOfPlayers = Int(receivedData.userData) ?? 0
        case .listenerDisconnection: break
        case .connectionOrListenerError:
            clientListenerReceived(errorString: receivedData.userData)
        case .listenerSomeoneConnected: someBodyConnected(userData: receivedData)
            
        case .listenerUserdata:
            processUserData(userData: receivedData)
        default:
            break
        }
    }
    
    // ----------------------------------------------------
    // process the data we received
    // ----------------------------------------------------
    func processUserData(userData data: ClientReceivedData) {
        //Figure out what data we got from the server
        serverData.processData(data: data)
        
        switch serverData.dataType {
        case .iam:
            //Ah, introductions I see
            //Set up the first turn now that both players are here
            battleshipGame.currentPlayer = 1
            if battleshipGame.myPlayerNumber != data.player {
                battleshipGame.you = serverData.serverData
            }
            else {
                battleshipGame.me = serverData.serverData
            }
            gameServerViewDelegate?.newUserDataRecieved(type:serverData.dataType,data:[battleshipGame.me,battleshipGame.you])
            break
        case .gameOver:
            //someone has won, the server will tell us who
            print("INVOKED GAME OVER")
            gameServerViewDelegate?.newUserDataRecieved(type: serverData.dataType, data: [serverData.serverData])
            break
        case .newState:
            //Invoked after fireAt, please look there first
            //  Server is telling us the newState of a square on our board.
            //  If it's our turn, then the "newState" we get is the state of the square
            //  we fired at.
            //  If not, then we already know the state of our board and it doesn't need
            //  any update
            print("INVOKED NEW STATE")
            //Is it our turn?
            if battleshipGame.myTurn {
                //We fired at a square -> this is new state of that square (an enemy square)
                let modifiedSquare = Square.fromString(textSquare: serverData.serverData)
                battleshipGame.updateEnemyBoard(at: modifiedSquare.coordinate, newState: modifiedSquare.state)
            }
            //Now update the view
            gameServerViewDelegate?.newUserDataRecieved(type: serverData.dataType, data: [serverData.serverData])
            
            //Switch who's turn it is
            battleshipGame.currentPlayer = battleshipGame.currentPlayer%2 + 1
            break
        case .fireAt:
            //THE FLOW FOR THE GAME
            // if it's our turn, fireAt is something that WE sent
            //   so we can ignore the server data that we're passed
            //   our enemy, on the other hand, has to pass us the "newState" of the
            //   square we fired at
            // If it's the enemies turn, we fire at our board and output the "newState"
            //   of the square that was fired at
            print("INVOKED FIRE AT")
            // Is it our turn?
            if !battleshipGame.myTurn {
                //We are being fired at
                let coord = Coordinate.fromString(coordinateString: serverData.serverData)
                let newState = battleshipGame.fire(at: coord)
                //Did they sink the last piece of our last ship?
                if battleshipGame.isFleetExhausted() {
                    //We lost
                    client?.addToOutputQueue(thisData: "gameOver:\(battleshipGame.you)")
                }
                else {
                    //Game is still afoot, update the view
                    gameServerViewDelegate?.newUserDataRecieved(type: serverData.dataType, data: [serverData.serverData])
                    
                    //We need to tell our enemies the new state of the square they attacked
                    let squareToReturn = Square(coordinate: coord)
                    squareToReturn.state = newState
                    client?.addToOutputQueue(thisData: "newState:" + squareToReturn.toString())
                }
            }
            
            break
        }
    }
    //========================================================================
    // fireAt
    // --If it's our turn, tell our enemy where we would like to attack
    //========================================================================
    func fireAt(coord:Coordinate) {
        print("THIS IS THE CURRENT PLAYER: \(battleshipGame.myPlayerNumber)")
        print("THIS IS WHO'S TURN IT IS: \(battleshipGame.currentPlayer)")
        //Are we supposed to be firing?
        if battleshipGame.myTurn {
            //MISSILES LOCKED -- FIRE!
            print("ABOUT TO SEND")
            print("THIS IS THE COORDINATE \(coord.toString())")
            client?.addToOutputQueue(thisData: "fireAt:\(coord.toString())")
            print("SENT")
        }
    }
    
    // -----------------------------------------------------------
    // client (me) has connected
    // -----------------------------------------------------------
    func clientListenerDidConnect(asPlayer num: Int, andName name: String) {
        gameServerViewDelegate?.gameServerConnectionRecieved(player:battleshipGame.me)
        battleshipGame.myPlayerNumber = num
    }
    
    
}
