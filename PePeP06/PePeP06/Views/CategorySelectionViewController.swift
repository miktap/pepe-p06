//
//  CategorySelectionViewController.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 31/12/2017.
//

import UIKit

protocol CategorySelectionProtocol {
    /**
     * A category has been selected.
     *
     * - Parameter category: Selected category
     */
    func categorySelected(category: TasoCategory)
}

class CategorySelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    
    var categories = [TasoCategory]()
    var currentCategory: TasoCategory?
    var delegate: CategorySelectionProtocol?
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
            cell.textLabel?.text = categories[indexPath.row].category_name
            cell.detailTextLabel?.text = categories[indexPath.row].competition_season
            
            if categories[indexPath.row] != currentCategory {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.categorySelected(category: categories[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
