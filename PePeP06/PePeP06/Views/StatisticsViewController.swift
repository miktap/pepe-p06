//
//  SecondViewController.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 22/04/2017.
//
//

import UIKit

class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataServiceDelegate {
    // MARK: - Properties
    
    var id = "StatisticsViewController"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
        
        dataService = appDelegate.dataService
        
        // Pull-up refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(dataService, action: #selector(dataService.populateCategories), for: .valueChanged)
        tableView.refreshControl = refreshControl

        dataService.populateCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataService.addDelegate(delegate: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
            return 0
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
    
    func categoriesPopulated(categories: [TasoCategory], error: Error?) {
        tableView.refreshControl?.endRefreshing()
        categoryList = categories
    }
}

