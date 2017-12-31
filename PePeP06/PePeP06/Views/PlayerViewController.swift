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
    var player: TasoPlayer?
    var teamCategories = [TasoTeam: [TasoCategory]]() {
        didSet {
            log.debug("Teams and categories defined")
            categoryList = teamCategories.values.flatMap {$0}
        }
    }
    var categoryList = [TasoCategory]() {
        didSet {
            if currentCategory == nil {
                log.debug("Setting first active category as the current one")
                currentCategory = categoryList.first(where: {$0.competition_active == "1"})
            }
        }
    }
    var currentCategory: TasoCategory? {
        didSet {
            tableView.reloadData()
            getPlayerStats()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = player?.first_name
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
        
        //        nameLabel.text      = playerFullName(player: player)
        //        gamesLabel.text     = player.matches
        //        goalsLabel.text     = player.goals
        //        passesLabel.text    = player.assists
        //        yellowsLabel.text   = player.warnings
        //        redsLabel.text      = player.suspensions
    }
    
    
    // MARK: - DataServiceDelegate
    
    func clubPopulated(club: TasoClub?, error: Error?) {
        log.debug("Club populated")
        
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
        tableView.reloadData()
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
    }
    
    private func getPlayerStats() {
        guard let currentCategory = currentCategory else {
            log.debug("Current category not set")
            return
        }
        
        log.debug("Category changed to \(currentCategory), find out into which team this category belongs")
        if let team = teamCategories.first(where: {$0.value.contains(currentCategory)}) {
            log.debug("Category is included to team: \(team.key), get team")
            dataService.populateTeamWithCategory(team_id: team.key.team_id, category_id: currentCategory.category_id)
        }
    }
}

class PlayerInfoCell: UITableViewCell {
    
}
