//
//  ClientListenerProtocol.swift
//  Battleship
//
//  Created by Sandy on 2019-04-09.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation

// =====================================================
// Anyone who wants to use the Client, should also be
// a client "listener" delegate
// =====================================================
protocol ClientServerListenerDelegate:class {
    func clientListenerReceived(errorString error:String)
    func clientListenerReceived(rawData data:String)
    func clientListenerDidConnect(asPlayer num:Int, andName name:String)
}
