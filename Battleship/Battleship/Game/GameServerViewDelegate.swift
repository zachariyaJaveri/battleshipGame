//
//  GameServerViewDelegate.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-17.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation

// =====================================================
// So that the view can be updated based off of
// game server updates
// =====================================================
protocol GameServerViewDelegate:class{
    func gameServerErrorReceived()
    func newUserDataRecieved(type:ServerReceivedData.receivedDataType,data:[String])
    func gameServerConnectionRecieved(player:String)
    func numPlayersChangedUpdateView()
    func updateScores(myScore:Int, enemyScore:Int)
    func gameOverScore(finalScore:Int, forPlayer player:String)
}
