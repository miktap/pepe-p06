//
//  DataService.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 27/12/2017.
//

import Foundation

protocol DataServiceDelegate {
    var id: String {get}
    
    /**
     * Categories have been populated.
     *
     * - Parameter categories: Populated categories
     * - Paramter error: Error or nil if operation was successfull
     */
    func categoriesPopulated(categories: [Category], error: Error?)
}

enum DataServiceError: Error {
    case responseError(String)
    case parseError(String)
    case unknownError(String)
}

class DataService {
    // MARK: - Properties
    
    var dataClient: TasoClient
    var delegates = [DataServiceDelegate]()
    
    
    // MARK: - Initialization
    
    init(client: TasoClient) {
        dataClient = client
    }
    
    
    
    // MARK: - Add/remove delegates
    
    func addDelegate(delegate: DataServiceDelegate) {
        if !delegates.contains(where: { $0.id == delegate.id } ) {
            log.debug("Add new DataServiceDelegate with id: '\(delegate.id)'")
            delegates.append(delegate)
        }
    }
    
    func removeDelegate(delegate: DataServiceDelegate) {
        if let index = delegates.index(where: { $0.id == delegate.id} ) {
            log.debug("Remove DataServiceDelegate with id: '\(delegate.id)'")
            delegates.remove(at: index)
        }
    }
    
    
    // MARK: - Methods
    
    @objc func populateCategories() {
        dataClient.getClub()?
            .then { response -> Void in
                log.debug("Status code: \(response.statusCode)")
                if let data = response.data, let message = String(data: data, encoding: .utf8) {
                    log.debug("Message: \(message)")
                    if let clubListing = ClubListing(JSONString: message), let club = clubListing.club {
                        log.debug("Got club: \(club.name ?? "")")
                        let categories = ClubFilter.getCategories(club: club,
                                                                   teams: Constants.Settings.selectedTeams,
                                                                   competitionsIncluding: Constants.Settings.selectedCompetitions)
                        self.delegates.forEach {$0.categoriesPopulated(categories: categories, error: nil)}
                    } else {
                        self.delegates.forEach {$0.categoriesPopulated(categories: [Category](), error: DataServiceError.parseError("Problems parsing Taso response to a club"))}
                    }
                } else {
                    self.delegates.forEach {$0.categoriesPopulated(categories: [Category](), error: DataServiceError.responseError("Problems with Taso response data"))}
                }
            }.catch { error in
                self.delegates.forEach {$0.categoriesPopulated(categories: [Category](), error: DataServiceError.unknownError(error.localizedDescription))}
        }
    }
}
