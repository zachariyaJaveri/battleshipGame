//
//  userReceivedData.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation
class ServerReceivedData {
    var dataType:receivedDataType = .iam
    var serverData:String = ""
    
    enum receivedDataType:String {
        case iam
        case fireAt
        case newState
        case gameOver
    }
    // ----------------------------------------------------
    // break the user Data into two parts
    // ----------------------------------------------------
    func getTwoComponents(str:String)->[String] {
        var results = [String]()
        let components = str.split(separator: ":", maxSplits: 1)
        for index in components.indices {
            results.append(String(components[index]))
        }
        
        return results
    }
    
    // ----------------------------------------------------
    // process the client data from the server
    // ----------------------------------------------------
    func processData(data:ClientReceivedData) {
        let parts = getTwoComponents(str: data.userData)
        
        switch parts[0] {
        case "iam":
            dataType = .iam
        case "fireAt":
            dataType = .fireAt
        case "newState":
            dataType = .newState
        case "gameOver":
            dataType = .gameOver
        default:
            break
        }
        
        serverData = parts[1]
    }
}
