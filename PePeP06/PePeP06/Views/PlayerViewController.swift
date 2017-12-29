//
//  PlayerViewController.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 25/12/2017.
//

import UIKit

class PlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    
    var player: TasoPlayer?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gamesLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var passesLabel: UILabel!
    @IBOutlet weak var yellowsLabel: UILabel!
    @IBOutlet weak var redsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = player?.first_name
        tableView.dataSource = self
        tableView.delegate = self
        
        updateStats()
    }
    
    
    // MARK: - UITableViewDataSource
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Methods
    
    func updateStats() {
        guard let player = player else {
            log.warning("No player data to update")
            return
        }
        
        nameLabel.text      = playerFullName(player: player)
        gamesLabel.text     = player.matches
        goalsLabel.text     = player.goals
        passesLabel.text    = player.assists
        yellowsLabel.text   = player.warnings
        redsLabel.text      = player.suspensions
    }
}
