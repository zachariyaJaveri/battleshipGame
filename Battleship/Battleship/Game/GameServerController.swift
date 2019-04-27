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
    
    // ----------------------------------------------------
    // somebody connected
    // ----------------------------------------------------
    func someBodyConnected (userData data:ClientReceivedData) {
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
    
    func processUserData(userData data: ClientReceivedData) {
        serverData.processData(data: data)
        
        switch serverData.dataType {
        case .iam:
            break
        case .gameOver:
            break
        case .newState:
            break
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
