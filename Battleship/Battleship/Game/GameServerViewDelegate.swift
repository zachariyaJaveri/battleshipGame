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
    func newUserDataRecieved(type:String,data:[String])
    func gameServerConnectionRecieved(player:String)
    func numPlayersChangedUpdateView()
}
