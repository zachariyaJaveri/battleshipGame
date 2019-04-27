//
//  ViewControllerTopScores.swift
//  Battleship
//
//  Created by Zachariya Javeri on 2019-04-27.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import UIKit

class ViewControllerTopScores: UIViewController {

    private(set) var data = [battleshipScoreAndName]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        data = battleshipScoreAndName.getAll()
        
        //Data isn't stored in order
        data.sort { return $0.score > $1.score }
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
