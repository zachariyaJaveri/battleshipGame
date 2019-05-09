//
//  ClientRecievedData.swift
//  Battleship
//
//  Created by Sandy on 2019-04-02.
//  Copyright © 2019 Sandy. All rights reserved.
//

import Foundation

// =====================================================
// this is data structure of received data, parsed from
// raw data sent by the server
// ======================================================
class ClientReceivedData {
    
    // ========================================================
    // properties
    // =======================================================
    var IP:String = ""
    var userData:String = ""
    var port:String = ""
    var player:Int = 0
    var username:String = ""
    var dataType:DataType = .listenerUserdata
    
    // =======================================================
    // data type enum (what kind of data did we get?)
    // =======================================================
    // NB: * if it starts with the word connection, then only
    //       the connectionDelegate functions will be called,
    //     * if it starts with the word listener, then only the
    //       listener delegate functions will be called
    //     * if it starts with the word server, then the
    //       client will deal with it
    // =======================================================
    
    enum DataType:String {
        
        // "user data"
        case listenerUserdata
        
        // "you connected"
        case connectionYouConnected
        
        // "connection in progress"
        case connectionInProgress
        
        // "error"
        case connectionOrListenerError
        
        // "other user disconnected"
        case listenerDisconnection
        
        // "a user connected, could be you, could be the other guy"
        case listenerSomeoneConnected
        
        // "asking for username before completing connection"
        case serverNameVerification
        
        // "currently, how many connections?"
        case listenerConnectionNumbers
    }
    
    
    // =======================================================
    // the parsing bit
    // =======================================================
    
    // -------------------------------------------------
    // take raw data sent by the server, and parse IP,
    // port, username, and data
    // -------------------------------------------------
    // **** really lazy programming here,
    //      do not mimic this mess in your own code! *****
    
    init (rawData:String) {
        let components = rawData.split(separator: ":", maxSplits: 5)
        
        IP = String(components[0])
        
        if components.count > 1 {
            port = String(components[1])
        }
        if components.count > 2 {
            player = Int(String(components[2])) ?? 0
        }
        
        if components.count > 3 {
            username = String(components[3])
        }
        
        if components.count > 4 {
            let type = String(components[4])
            if type == "Error" {
                dataType = .connectionOrListenerError
            }
            else if type == "Connected" {
                dataType = .connectionYouConnected
            }
            else if type == "Disconnected" {
                dataType = .listenerDisconnection
            }
            else if type == "NewConnection" {
                dataType = .listenerSomeoneConnected
            }
            else if type == "NameRequest" {
                dataType = .serverNameVerification
            }
            else if type == "NumberConnections" {
                dataType = .listenerConnectionNumbers
            }
            
        }
        
        if components.count > 5 {
            userData = String(components[5])
        }
    }
}
