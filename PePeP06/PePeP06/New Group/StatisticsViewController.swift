//
//  SecondViewController.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 22/04/2017.
//
//

import UIKit

class StatisticsViewController: UIViewController, UITableViewDataSource {
    // MARK: - Properties
    
    var categories = [Category]()
    var currentCategory: Category? {
        didSet {
            log.debug("Category changed to \(currentCategory?.category_name), time to change statistics view")
        }
    }
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sarjataulukko"
        populateCategories()
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        }
        
        return cell
    }
    

    
    // MARK: - Methods
    
    func populateCategories() {
        let tasoClient = TasoClient()
        tasoClient.getClub()?
            .then { response -> Void in
                log.debug("Status code: \(response.statusCode)")
                if let data = response.data, let message = String(data: data, encoding: .utf8) {
                    log.debug("Message: \(message)")
                    if let clubListing = ClubListing(JSONString: message), let club = clubListing.club {
                        log.debug("Got club: \(club.name ?? "")")
                        self.categories = ClubFilter.getCategories(club: club, teams: Constants.Settings.selectedTeams, competitionsIncluding: Constants.Settings.selectedCompetitions)
                    }
                }
            }.catch { error in
                // TODO: AlertDialog
                log.error(error)
        }
    }
}

