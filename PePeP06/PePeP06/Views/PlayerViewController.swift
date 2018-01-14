//
//  PlayerViewController.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 25/12/2017.
//

import UIKit

class PlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataServiceDelegate, CategorySelectionProtocol {
    // MARK: - Properties
    
    var id = "PlayerViewController"
    var dataService: DataService!
    /// Player whose stats are shown
    var currentPlayer: TasoPlayer?
    /// Teams and categories tied up, used when the final team data (which contains player stats) is fetched
    var teamCategories = [TasoTeam: [TasoCategory]]() {
        didSet {
            log.debug("Teams and categories defined")
            categoryList = teamCategories.values.flatMap {$0}
        }
    }
    /// Used to populate the categories in the CategorySelection view
    var categoryList = [TasoCategory]() {
        didSet {
            if currentCategory == nil {
                log.debug("Setting first active category as the current one")
                currentCategory = categoryList.first(where: {$0.competition_active == "1"})
            }
        }
    }
    /// Currently selected category, used when the final team data (which contains player stats) is fetched
    var currentCategory: TasoCategory? {
        didSet {
            tableView.reloadData()
            getPlayerStats()
        }
    }
    /// This is the final team data containing player stats
    var currentTeam: TasoTeam? {
        didSet {
            if let player = currentTeam?.players?.first(where: {$0.player_id == currentPlayer?.player_id}) {
                currentPlayer = player
                log.debug("Player set to: \(currentPlayer!), update UI")
                tableView.reloadData()
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = currentPlayer?.first_name
        tableView.dataSource = self
        tableView.delegate = self
        
        dataService = AppDelegate.dataService
        
        // Pull-up refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(update), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataService.addDelegate(delegate: self)
        dataService.populateClub()
        getPlayerStats()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dataService.removeDelegate(delegate: self)
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
            cell.textLabel?.text = currentCategory?.category_name
            cell.detailTextLabel?.text = currentCategory?.competition_season
        }
        
        if indexPath.section == 1 {
            let playerCell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerInfoCell
            playerCell.buildFrom(player: currentPlayer)
            cell = playerCell
        }
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - DataServiceDelegate
    
    func clubPopulated(club: TasoClub?, error: Error?) {
        log.debug("Club populated")
        tableView.refreshControl?.endRefreshing()
        
        if let error = error {
            log.error(error)
            // TODO: error dialog
        } else {
            if let club = club {
                teamCategories = TasoClubFilter.getTeamsAndCategories(club: club)
            }
        }
    }
    
    func teamsPopulated(teams: [TasoTeam]?, error: Error?) {}
    
    func teamWithCategoryPopulated(team: TasoTeam?, error: Error?) {
        log.debug("Team with category populated")
        tableView.refreshControl?.endRefreshing()
        
        if let error = error {
            log.error(error)
            // TODO: error dialog
        } else {
            currentTeam = team
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CategorySelectionViewController {
            vc.delegate = self
            vc.categories = categoryList
            vc.currentCategory = currentCategory
        }
    }
    
    
    // MARK: - CategorySelectionProtocol
    
    func categorySelected(category: TasoCategory) {
        currentCategory = category
    }
    
    
    // MARK: - Private methods
    
    @objc private func update() {
        dataService.populateClub()
        getPlayerStats()
    }
    
    private func getPlayerStats() {
        guard let currentCategory = currentCategory else {
            log.debug("Current category not set")
            return
        }
        
        log.debug("Current category \(currentCategory), find out into which team this category belongs")
        if let team = teamCategories.first(where: {$0.value.contains(currentCategory)}) {
            log.debug("Category is included to team: \(team.key), get team")
            dataService.populateTeamWithCategory(team_id: team.key.team_id, competition_id: currentCategory.competition_id, category_id: currentCategory.category_id)
        }
    }
}

class PlayerInfoCell: UITableViewCell {
    // MARK: - Properties
    
    @IBOutlet weak var gamesLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var passesLabel: UILabel!
    @IBOutlet weak var yellowsLabel: UILabel!
    @IBOutlet weak var redsLabel: UILabel!
    
    
    // MARK: - Methods
    
    func buildFrom(player: TasoPlayer?) {
        guard let player = player else {
            return
        }
        
        gamesLabel.text = player.matches
        goalsLabel.text = player.goals
        passesLabel.text = player.assists
        yellowsLabel.text = player.warnings
        redsLabel.text = player.suspensions
    }
}
