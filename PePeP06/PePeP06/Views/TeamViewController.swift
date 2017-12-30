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

class TeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataServiceDelegate {
    // MARK: - Properties
    
    var id = "TeamViewController"
    var dataService: DataService!
    var players = [TasoPlayer]() {
        didSet {
            log.debug("Players updated, refresh UI")
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
        tableView.delegate = self
        
        dataService = AppDelegate.dataService
        dataService.populateTeams()
        
        // Pull-up refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(update), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataService.addDelegate(delegate: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dataService.removeDelegate(delegate: self)
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
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - DataServiceDelegate
    
    func clubPopulated(club: TasoClub?, error: Error?) {}
    
    func teamsPopulated(teams: [TasoTeam]?, error: Error?) {
        log.debug("Teams populated")
        tableView.refreshControl?.endRefreshing()
        
        if let error = error {
            log.error(error)
            // TODO: error dialog
        } else {
            if let teams = teams {
                var newPlayers = Set<TasoPlayer>()
                teams.forEach {
                    if let players = $0.players {
                        newPlayers.formUnion(players)
                    }
                }
                players = Array(newPlayers)
            }
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
    
    
    // MARK: - Private methods
    
    @objc private func update() {
        dataService.populateTeams()
    }
}

