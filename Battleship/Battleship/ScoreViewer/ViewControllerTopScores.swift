//
//  ViewControllerTopScores.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import UIKit

class ViewControllerTopScores: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //GLOBALS
    private var topScore = 0
    private(set) var data = [battleshipScoreAndName]()
    
    //CONSTANTS
    private let NORMAL_CELL_NAME = "normalCell"
    private let WINNER_CELL_NAME = "winnerCell"
    
    private let WINNER_CELL_HEIGHT:CGFloat = 70
    private let NORMAL_CELL_HEIGHT:CGFloat = 40
    //OUTLETS
    @IBOutlet weak var scoresTable: UITableView!
    //========================================================================
    // View did load
    //========================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = battleshipScoreAndName.getAll()
        
        if data.count > 0 {
            //Data isn't stored in order
            data.sort { return $0.score > $1.score }
            topScore = data[0].score
        }
        else {
            topScore = 0
        }
        
        scoresTable.delegate = self
        scoresTable.dataSource = self
        scoresTable.reloadData()
    }
    //========================================================================
    // Goes back to the previous page
    //========================================================================
    @IBAction func goBackToPreviousPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //========================================================================
    // Get the amount of rows that we need
    //========================================================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //========================================================================
    // Get the cell for the current row
    //========================================================================
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Find out if we are a winner or not
        let currentScoreAndName = data[indexPath.row]
        
        if currentScoreAndName.score == topScore {
            //winning cell
            let cell = tableView.dequeueReusableCell(withIdentifier: WINNER_CELL_NAME, for: indexPath) as! TableViewCellWinnerCell
            cell.nameLabel.text = currentScoreAndName.name
            cell.scoreLabel.text = String(currentScoreAndName.score)
            return cell
        }
        else {
            //regular cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NORMAL_CELL_NAME, for: indexPath) as! TableViewCellNormalCell
            cell.nameLabel.text = currentScoreAndName.name
            cell.scoreLabel.text = String(currentScoreAndName.score)
            return cell
        }
    }
    //========================================================================
    // Get the height for the current row
    //========================================================================
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let score = data[indexPath.row].score
        if score == topScore {
            return WINNER_CELL_HEIGHT
        }
        else {
            return NORMAL_CELL_HEIGHT
        }
    }

    

}
