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
        //TODO
    }
    
    // -----------------------------------------------------------
    // client (me) has connected
    // -----------------------------------------------------------
    func clientListenerDidConnect(asPlayer num: Int, andName name: String) {
        gameServerViewDelegate?.gameServerConnectionRecieved(player:battleshipGame.me)
        battleshipGame.myPlayerNumber = num
    }
    
}
