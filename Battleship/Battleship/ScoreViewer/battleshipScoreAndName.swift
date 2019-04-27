//
//  battleshipScoreAndName.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol battleshipScoreAndNameProtocol {
    var name:String {get}
    var score:Int {get}
}

struct battleshipScoreAndName:battleshipScoreAndNameProtocol {
    //what we are using to manage the core data
    var battleshipScoreAndNameManaged:BattleshipScoresEntity
    
    //Complying with protocol -- Name
    var name:String {
        if let name = battleshipScoreAndNameManaged.name {
            return name
        }
        else {
            return "This person has no name"
        }
    }
    
    //Complying with protocol -- Score
    var score:Int {
        return Int(battleshipScoreAndNameManaged.score)
    }
    
    //DATABASE INTERACTION
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static var DBContext = appDelegate.persistentContainer.viewContext
    
    //========================================================================
    // Retrieve all names and scores from the database
    //========================================================================
    static func getAll() -> [battleshipScoreAndName] {
        var allScores = [battleshipScoreAndName]()
        
        //Fetch everything from the DB
        let fetchRequest:NSFetchRequest<BattleshipScoresEntity> = BattleshipScoresEntity.fetchRequest()
        
        do {
            //go through all the scores and append to array
            for singleScore in try DBContext.fetch(fetchRequest) {
                allScores.append(battleshipScoreAndName(newBattleshipScore: singleScore))
            }
        }
        catch {
            print("Error while fetching: \(error.localizedDescription)")
        }
        
        return allScores
    }
    
    //========================================================================
    // INIT -- New score, not from DB
    //========================================================================
    init(nameOfPerson:String, scoreOfPerson:Int) {
        battleshipScoreAndNameManaged = BattleshipScoresEntity(context: battleshipScoreAndName.DBContext)
        battleshipScoreAndNameManaged.name = nameOfPerson
        battleshipScoreAndNameManaged.score = Int32(scoreOfPerson)
        saveChanges()
    }
    
    //========================================================================
    // INIT -- Score from DB
    //========================================================================
    init(newBattleshipScore:BattleshipScoresEntity) {
        battleshipScoreAndNameManaged = newBattleshipScore
    }
    
    //========================================================================
    // Save changes to DB
    //========================================================================
    func saveChanges() {
        do {
            try battleshipScoreAndName.DBContext.save()
        }
        catch {
            print("Error saving BattleshipScore data: \(error.localizedDescription)")
        }
    }
    
    //========================================================================
    // Delete a battleship score from the database
    //========================================================================
    func delete() {
        //Deletes from database, but the entity still exists
        battleshipScoreAndName.DBContext.delete(battleshipScoreAndNameManaged)
        saveChanges()
    }
}
