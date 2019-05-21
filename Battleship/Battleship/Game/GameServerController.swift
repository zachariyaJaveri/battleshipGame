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
        serverData.processData(data: data)
        
        switch serverData.dataType {
        case .iam:
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
            print("INVOKED GAME OVER")
            gameServerViewDelegate?.newUserDataRecieved(type: serverData.dataType, data: [serverData.serverData])
            break
        case .newState:
            print("INVOKED NEW STATE")
            if battleshipGame.myTurn {
                let modifiedSquare = Square.fromString(textSquare: serverData.serverData)
                battleshipGame.updateEnemyBoard(at: modifiedSquare.coordinate, newState: modifiedSquare.state)
            }
            gameServerViewDelegate?.newUserDataRecieved(type: serverData.dataType, data: [serverData.serverData])
            
            //Switch who's turn it is
            battleshipGame.currentPlayer = battleshipGame.currentPlayer%2 + 1
            break
        case .fireAt:
            print("INVOKED FIRE AT")
            
            if !battleshipGame.myTurn {
                //We are being fired at
                let coord = Coordinate.fromString(coordinateString: serverData.serverData)
                let newState = battleshipGame.fire(at: coord)
                if battleshipGame.isFleetExhausted() {
                    //We lost
                    client?.addToOutputQueue(thisData: "gameOver:\(battleshipGame.you)")
                }
                else {
                    //Game is still afoot
                    gameServerViewDelegate?.newUserDataRecieved(type: serverData.dataType, data: [serverData.serverData])
                    
                    //Send the new square back
                    let squareToReturn = Square(coordinate: coord)
                    squareToReturn.state = newState
                    client?.addToOutputQueue(thisData: "newState:" + squareToReturn.toString())
                }
            }
            
            break
        }
    }
    
    func fireAt(coord:Coordinate) {
        print("THIS IS THE CURRENT PLAYER: \(battleshipGame.myPlayerNumber)")
        print("THIS IS WHO'S TURN IT IS: \(battleshipGame.currentPlayer)")
        if battleshipGame.myTurn {
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
