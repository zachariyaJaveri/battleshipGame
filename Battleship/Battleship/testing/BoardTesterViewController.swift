//
//  BoardTesterViewController.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import UIKit

class BoardTesterViewController: UIViewController {

    var testBoard:Board?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        testBoard = Board(rows: 4, cols: 4)
        testingGrid.myBoard = testBoard!
    }
    

    @IBOutlet weak var testingGrid: PlayerGrid!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
