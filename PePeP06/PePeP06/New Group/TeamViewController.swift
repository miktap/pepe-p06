//
//  TeamViewController.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 22/04/2017.
//
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var playerNumber: UILabel!
    @IBOutlet weak var playerName: UILabel!
}

class TeamViewController: UIViewController, UITableViewDataSource {
    // MARK: - Properties
    
    /// PePe team ID in Taso
    let pepeTeamID = 141460
    var players = [Player]() {
        didSet {
            if let tableView = tableView {
                tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = ""
        tableView.dataSource = self
        populatePlayers()
    }

    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell
        cell.playerNumber.text = players[indexPath.row].shirt_number
        cell.playerName.text = playerFullName(player: players[indexPath.row])
        
        return cell
    }
    
    
    // MARK: - Methods
    
    func populatePlayers() {
        let tasoClient = TasoClient()
        tasoClient.getTeam(id: pepeTeamID)?
            .then { response -> Void in
                log.debug("Status code: \(response.statusCode)")
                if let data = response.data, let message = String(data: data, encoding: .utf8) {
                    log.debug("Message: \(message)")
                    if let teamListing = TeamListing(JSONString: message) {
                        log.debug("Got team: \(teamListing.team.team_name ?? "")")
                        self.navigationItem.title = teamListing.team.team_name
                        if let teamPlayers = teamListing.team.players {
                            self.players = teamPlayers
                        } else {
                            log.warning("No players in the team")
                        }
                    } else {
                        log.warning("Unable to parse team")
                    }
                }
            }.catch { error in
                log.error(error)
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? PlayerViewController,
            let cellIndex = tableView.indexPathForSelectedRow {
            vc.player = players[cellIndex.row]
        }
    }
}

