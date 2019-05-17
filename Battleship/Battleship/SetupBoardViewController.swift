//
//  SetupBoardViewController.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-17.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import UIKit

class SetupBoardViewController: UIViewController {

    let shipsLeftMsg = "Ships left to place: "
    let currentShipSizeMsg = "Current ship size to place: "
    let CONNECTION_SEGUE_NAME = "serverConnectionSegue"
    let NUM_ROWS = 9
    let NUM_COLS = 9
    
    var shipLengthsToPlace = [2, 3, 4, 5]
    var shipLengthIndex = 0
    var myFleet:[Ship] = [Ship]()
    
    @IBOutlet weak var shipsLeftLbl: UILabel!
    @IBOutlet weak var curShipSizeLbl: UILabel!
    @IBOutlet weak var grid: CreationGrid!
    @IBOutlet weak var addShipBtn: UIButton!
    @IBOutlet weak var readyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        grid.myBoard = Board(rows: NUM_ROWS, cols: NUM_COLS)
        
        updateLabels()
        readyBtn.isEnabled = false
    }

    @IBAction func addShipClick(_ sender: UIButton) {
        let squares = grid.selectedSquares
        if squares.count != shipLengthsToPlace[shipLengthIndex] {
            showToast(message: "Your ship is the wrong size!")
        }
        else {
            for square in squares {
                square.state = .ship
            }
            grid.selectedSquares.removeAll()
            myFleet.append(Ship(squares: squares))
            shipLengthIndex += 1
            updateLabels()
        }
    }
    @IBAction func resetGrid(_ sender: UIButton) {
        //Start with a fresh board
        grid.myBoard = Board(rows: NUM_ROWS, cols: NUM_COLS)
        
        shipLengthIndex = 0
        addShipBtn.isEnabled = true
        readyBtn.isEnabled = false
        
        updateLabels()
    }
    
    func updateLabels() {
        //Update ships left
        shipsLeftLbl.text = shipsLeftMsg + String(shipLengthsToPlace.count - shipLengthIndex)
        
        //Update current ship size label
        if shipLengthIndex < shipLengthsToPlace.count {
            curShipSizeLbl.text = currentShipSizeMsg + String(shipLengthsToPlace[shipLengthIndex])

        }
        else {
            curShipSizeLbl.text = "All ships placed!"
            addShipBtn.isEnabled = false
            readyBtn.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("I WAS PREPARED")
        
        if segue.identifier == CONNECTION_SEGUE_NAME {
            let connectionScreen = segue.destination as! ViewControllerConnectToServer
            connectionScreen.playerBoard = grid.myBoard
            connectionScreen.playerShips = myFleet
        }
    }
}







//TAKEN FROM STACK OVERFLOW :p
//https://stackoverflow.com/questions/31540375/how-to-toast-message-in-swift
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/3 - 50, y: self.view.frame.size.height-100, width: 250, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
