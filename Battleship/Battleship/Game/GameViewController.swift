//
//  GameViewController.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-17.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameServerViewDelegate {
    //FOR CORE
    private(set) var data = [battleshipScoreAndName]()
    let SCORE_SCREEN_SEGUE_NAME = "topScoresSegue"
    
    //VARIABLES
    var gameServer:GameServerController = GameServerController()
    var client:Client = Client()
    var playerBoard:Board?
    var playerShips:[Ship]?
    var me:String = "Me"
    var myPlayerNumber = 0
    
    // OUTLETS
    @IBOutlet weak var enemyGrid: EnemyGrid!
    @IBOutlet weak var playerGrid: PlayerGrid!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var enemyLabel: UILabel!
    @IBOutlet weak var fireBtn: UIButton!
    
    @IBAction func fireBtnClick(_ sender: UIButton) {
        if let squareToFireAt = enemyGrid!.currentlySelectedSquare {
            print("I AM FIRING")
            gameServer.fireAt(coord: squareToFireAt.coordinate)
        }
        else {
            self.showToast(message: "No square selected!")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup for core
        data = battleshipScoreAndName.getAll()
        
        //Setup for the game
        gameServer.gameServerViewDelegate = self
        gameServer.client = client
        gameServer.battleshipGame.me = me
        gameServer.battleshipGame.myBoard = playerBoard!
        gameServer.battleshipGame.myFleet = playerShips!
        gameServer.battleshipGame.yourBoard = Board(rows: (playerBoard?.numRows)!, cols: (playerBoard?.numCols)!)
        enemyGrid.myBoard = Board(rows: (playerBoard?.numRows)!, cols: (playerBoard?.numCols)!)
        playerGrid.myBoard = playerBoard!
        
    }
    
    // ----------------------------------------------------
    // any error, so bail
    // ----------------------------------------------------
    func gameServerErrorReceived() {
        dismiss(animated: true, completion: nil)
    }

    func newUserDataRecieved(type: ServerReceivedData.receivedDataType, data: [String]) {
        
        switch type {
        case .iam:
            //update labels
            playerLabel.text = data[0]
            enemyLabel.text = data[1]
            
            if gameServer.battleshipGame.myTurn {
                statusLabel.text = "It's my turn to fire!"
                fireBtn.isEnabled = true
            }
            else {
                statusLabel.text = "I have to wait my turn."
                fireBtn.isEnabled = false
            }
            break
        case .fireAt:
            playerGrid.myBoard = gameServer.battleshipGame.myBoard
            
            break
        case .gameOver:
            statusLabel.text = "\(data[0]) is the winner!"
            break
        case .newState:
            //it's our turn, so update the enemy grid
            if gameServer.battleshipGame.myTurn {
                enemyGrid.myBoard = gameServer.battleshipGame.yourBoard
                //No longer our turn
                fireBtn.isEnabled = false
                statusLabel.text = "I have to wait my turn."
            }
            else {
                //It's our turn now!
                fireBtn.isEnabled = true
                statusLabel.text = "It's my turn to fire!"
            }
            
            
            break
        }
        
    }

    func gameServerConnectionRecieved(player: String) {
        playerLabel.text = player
    }

    // ----------------------------------------------------
    // update the view when number of players changes
    // ----------------------------------------------------
    func numPlayersChangedUpdateView() {
        if gameServer.numberOfPlayers == 2 {
            showToast(message: "THERE ARE 2 PLAYERS")
            statusLabel.text = ""
            playerLabel.text = "\(gameServer.battleshipGame.me)"
            enemyLabel.text = "\(gameServer.battleshipGame.you)"
        }
        else {
            showToast(message: "Only 1 player")
            statusLabel.text = "waiting for another player to connect"
            playerLabel.text = "\(gameServer.battleshipGame.me)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == SCORE_SCREEN_SEGUE_NAME {
            
        }
    }
 

}
