//
//  GameViewController.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-17.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameServerViewDelegate {
    
    var gameServer:GameServerController = GameServerController()
    
    @IBOutlet weak var playerLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var enemyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameServer.gameServerViewDelegate = self
    }
    
    // ----------------------------------------------------
    // any error, so bail
    // ----------------------------------------------------
    func gameServerErrorReceived() {
        dismiss(animated: true, completion: nil)
    }

    func newUserDataRecieved(type: String, data: [String]) {
        //TODO
    }

    func gameServerConnectionRecieved(player: String) {
        playerLabel.text = player
    }

    // ----------------------------------------------------
    // update the view when number of players changes
    // ----------------------------------------------------
    func numPlayersChangedUpdateView() {
        if gameServer.numberOfPlayers == 2 {
            statusLabel.text = ""
            playerLabel.text = "\(gameServer.battleshipGame.me)"
            enemyLabel.text = "\(gameServer.battleshipGame.you)"
        }
        else {
            statusLabel.text = "waiting for another player to connect"
            playerLabel.text = "\(gameServer.battleshipGame.me)"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
