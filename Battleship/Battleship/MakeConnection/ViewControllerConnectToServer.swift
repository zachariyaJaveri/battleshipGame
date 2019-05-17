//
//  ViewControllerConnectToServer.swift
//  Battleship
//
//  Created by Lister, Julia on 2019-05-17.
//  Copyright © 2019 Lister, Julia. All rights reserved.
//

import UIKit

class ViewControllerConnectToServer: UIViewController, ClientConnectionDelegate {
    
    // ===================================================================
    // initialization
    // ===================================================================
    var username = "unknown"
    var client = Client()
    var playerNumber = 0
    var playerBoard:Board?
    var playerShips:[Ship] = [Ship]()
    
    var port:Int { return Int(PortTextField.text!) ?? 8080}
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var PortTextField: UITextField!
    
    // ===================================================================
    // 📝 set some defaults,
    // 🔗 set ourselves as the connectionDelegate
    // ... once we are connected, the client will call our funcs
    // ===================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        URLTextField.text = "localhost"
        PortTextField.text = "8080"
        client.connectionDelegate = self
    }
    
    // ===================================================================
    // 📞 please connect me to the server
    // ===================================================================
    @IBAction func ConnectTap(_ sender: UIButton) {
        let name = UsernameTextField?.text ?? ""
        StatusLabel.text = "Connecting ..."
        if name.count > 0 {
            client.connect(toURL: URLTextField.text!, viaPort: port, as: name)
        }
        else {
            StatusLabel.text = "You must specify a username"
        }
    }
    
    // ===================================================================
    // 💘 the client has connected to server, but now is exchanging
    // names
    // ===================================================================
    func clientConnectionInProgress(asPlayer num:Int, andName name:String) {
        StatusLabel.text = "... verifying"
        playerNumber = num
        username = name
        print ("CONNECTION DELEGATE: is performing handshake")
        performSegue(withIdentifier: "toEchoAppSegue", sender: self)
    }
    
    // ===================================================================
    // ❤️ the client has successfully connected to the server, segue
    // to next page
    // ===================================================================
    func clientDidConnect(asPlayer num:Int, andName name:String) {
        print ("CONNECTION DELEGATE: client did connect")
        StatusLabel.text = ""
    }
    
    // ===================================================================
    // 😡 we had an error.  Note that the client kicks us out if there
    // was an error
    // ===================================================================
    func clientReceived(errorString error: String) {
        StatusLabel.text = error
    }
    
    // ===================================================================
    // 💔 we were disconnected, is there something that we need to do?
    // ===================================================================
    func clientDisconnected() {
    }
    
    // ===================================================================
    // 🚀 we are about to segue to other page, set the client object on
    // that page to be the client that we connected to
    // ===================================================================
    
}
