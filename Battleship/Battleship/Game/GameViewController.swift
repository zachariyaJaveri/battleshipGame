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
    @IBOutlet weak var enemyScore: UILabel!
    @IBOutlet weak var playerScore: UILabel!
    
    //========================================================================
    // "Fires" at a selected square if there is one
    //========================================================================
    @IBAction func fireBtnClick(_ sender: UIButton) {
        //We can only select squares on the enemyGrid
        if let squareToFireAt = enemyGrid!.currentlySelectedSquare {
//            print("I AM FIRING")
            //Tell the server this is where we want to fire at
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
    //========================================================================
    // Handle what happens when we get data from the server
    //========================================================================
    func newUserDataRecieved(type: ServerReceivedData.receivedDataType, data: [String]) {
        
        switch type {
        case .iam:
            //We're just learning who our opponent is
            //update labels
            playerLabel.text = data[0]
            enemyLabel.text = data[1]
            
            //Set up for the game :)
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
            //We were fired at! update the board
            playerGrid.myBoard = gameServer.battleshipGame.myBoard
            
            break
        case .gameOver:
            //One person has lost all their ships
            statusLabel.text = "\(data[0]) is the winner!"
            fireBtn.isEnabled = false
            break
        case .newState:
            
            //it's our turn, so we got the "newState" for an enemy piece
            //We switch turns after this, so the logic will seem backwards
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
    //========================================================================
    // We connected
    //========================================================================
    func gameServerConnectionRecieved(player: String) {
        playerLabel.text = player
    }

    // ----------------------------------------------------
    // update the view when number of players changes
    // ----------------------------------------------------
    func numPlayersChangedUpdateView() {
        //Are we alone?
        if gameServer.numberOfPlayers == 2 {
            //We have a friend, that we must now annihilate :(
            showToast(message: "THERE ARE 2 PLAYERS")
            statusLabel.text = ""
            playerLabel.text = "\(gameServer.battleshipGame.me)"
            enemyLabel.text = "\(gameServer.battleshipGame.you)"
        }
        else {
            //I'm all alone
            showToast(message: "Only 1 player")
            statusLabel.text = "waiting for another player to connect"
            playerLabel.text = "\(gameServer.battleshipGame.me)"
        }
    }
    //========================================================================
    // Update the scores on screen
    //========================================================================
    func updateScores(myScore: Int, enemyScore: Int) {
        //update the scores
        playerScore.text = String(myScore)
        self.enemyScore.text = String(enemyScore)
    }
    //========================================================================
    // Game is over, add the score to the leaderboard
    //========================================================================
    func gameOverScore(finalScore: Int, forPlayer player: String) {
        data.append(battleshipScoreAndName(nameOfPerson: player, scoreOfPerson: finalScore))
        
        performSegue(withIdentifier: SCORE_SCREEN_SEGUE_NAME, sender: self)
    }
}
