//
//  PlayerViewController.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 25/12/2017.
//

import UIKit

class PlayerViewController: UIViewController {
    // MARK: - Properties
    
    var player: Player?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gamesLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var passesLabel: UILabel!
    @IBOutlet weak var yellowsLabel: UILabel!
    @IBOutlet weak var redsLabel: UILabel!
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let player = player {
            navigationItem.title = player.first_name
            
            nameLabel.text = playerFullName(player: player)
            
        }
    }
}
