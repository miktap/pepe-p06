//
//  SecondViewController.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 22/04/2017.
//
//

import UIKit

class StandingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataServiceDelegate, CategorySelectionProtocol {
    // MARK: - Properties
    
    var id = "StandingsViewController"
    var dataService: DataService!
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
            log.debug("Category changed to \(currentCategory?.category_name ?? ""), time to change statistics view")
            tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sarjataulukko"
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
    
    
    // MARK: - DataServiceDelegate
    
    func dataServiceReady() {
        dataService.populateClub()
    }
    
    func clubPopulated(club: TasoClub?, error: Error?) {
        log.debug("Club populated")
        tableView.refreshControl?.endRefreshing()
        
        if let error = error {
            log.error(error)
            // TODO: error dialog
        } else {
            if let club = club {
                categoryList = TasoClubFilter.getCategories(
                    club: club,
                    teams: Constants.Settings.selectedTeams,
                    competitionsIncluding: Constants.Settings.selectedCompetitions
                )
            }
        }
    }
    
    func teamsPopulated(teams: [TasoTeam]?, error: Error?) {}
    func teamWithCategoryPopulated(team: TasoTeam?, error: Error?) {}
    
    
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
}

