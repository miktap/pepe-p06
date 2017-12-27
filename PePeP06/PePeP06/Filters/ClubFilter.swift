//
//  TasoObjectListFilter.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 26/12/2017.
//

import Foundation

class ClubFilter {
    /**
     * Get categories from a club.
     *
     * - Parameter club: Club to filter.
     * - Parameter teams (Optional): Team IDs which are included in the filter.
     * - Parameter competitionsIncluding (Optional): Include only categories whose competitions
     * contain one of the listed strings.
     * - Returns: A list of categories.
     */
    static func getCategories(club: Club, teams: [String]? = nil, competitionsIncluding: [String]? = nil) -> [Category] {
        log.debug("Filtering categories from club: \(club.name ?? "")")
        
        // Select teams
        var selectedTeams: [Team]?
        if let teams = teams {
            log.debug("Including only teams: \(teams)")
            selectedTeams = club.teams?.filter {teams.contains($0.team_id)}
        } else {
            log.debug("Include all teams")
            selectedTeams = club.teams
        }
        
        // Select categories from teams
        var selectedCategories = [Category]()
        if let selectedTeams = selectedTeams {
            if let competitionsIncluding = competitionsIncluding {
                log.debug("Include only categories whose competitions contain one of: \(competitionsIncluding)")
                selectedTeams.forEach {
                    $0.categories?.forEach { category in
                        competitionsIncluding.forEach { competitionString in
                            if let competition = category.competition_name,
                                competition.contains(competitionString) {
                                log.debug("Found a category '\(category.category_id ?? "")' with a competition match '\(competitionString)'")
                                selectedCategories.append(category)
                                return
                            }
                        }
                    }
                }
            } else {
                log.debug("Include all categories from the selected teams")
                selectedTeams.forEach {
                    if let categories = $0.categories {
                        selectedCategories.append(contentsOf: categories)
                    }
                }
            }
        } else {
            log.debug("No teams found, means no categories")
        }
        
        return selectedCategories
    }
}
