//
//  TasoClubFilter.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 26/12/2017.
//

import Foundation

class TasoClubFilter {
    /**
     * Get categories from a Taso club.
     *
     * - Parameter club: Club to filter.
     * - Parameter teams (Optional): Team IDs which are included in the filter.
     * - Parameter competitionsIncluding (Optional): Include only categories whose competitions
     * contain one of the listed strings.
     * - Returns: A list of categories.
     */
    static func getCategories(club: TasoClub, teams: [String]? = nil, competitionsIncluding: [String]? = nil) -> [TasoCategory] {
        log.debug("Filtering categories from club: \(club.name ?? "")")
        
        // Select teams
        var selectedTeams: [TasoTeam]?
        if let teams = teams {
            log.debug("Including only teams: \(teams)")
            selectedTeams = club.teams?.filter {teams.contains($0.team_id)}
        } else {
            log.debug("Include all teams")
            selectedTeams = club.teams
        }
        
        // Select categories from teams
        var selectedCategories = [TasoCategory]()
        if let selectedTeams = selectedTeams {
            if let competitionsIncluding = competitionsIncluding {
                log.debug("Include only categories whose competitions contain one of: \(competitionsIncluding)")
                selectedTeams.forEach {
                    $0.categories?.forEach { category in
                        competitionsIncluding.forEach { competitionString in
                            if let competition = category.competition_name,
                                competition.contains(competitionString) {
                                log.debug("Found a category '\(category.category_id)' with a competition match '\(competitionString)'")
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
    
    /**
     * Get teams and categories from a Taso club.
     *
     * - Parameter club: Club to filter.
     * - Parameter teams: Team IDs to include.
     * - Parameter competitionsIncluding: Include only categories whose competitions
     * contain one of the listed strings.
     * - Returns: A dictionary where the key is a Taso team and values are selected
     * Taso categories of the team.
     */
    static func getTeamsAndCategories(club: TasoClub,
                                      teams: [String] = Constants.Settings.selectedTeams,
                                      competitionsIncluding: [String] = Constants.Settings.selectedCompetitions)
        -> [TasoTeam: [TasoCategory]] {
            
            log.debug("Filtering teams and categories from club: \(club.name ?? "")")
            
            var result = [TasoTeam: [TasoCategory]]()
            if let selectedTeams = club.teams?.filter({teams.contains($0.team_id)}) {
                log.debug("Got teams: \(selectedTeams)")
                selectedTeams.forEach { team in
                    result[team] = team.categories?.filter { category in
                        if let competition = category.competition_name {
                            for competitionFilter in competitionsIncluding {
                                if competition.contains(competitionFilter) {
                                    log.debug("Found category: \(category.category_id)")
                                    return true
                                }
                            }
                        }
                        return false
                    }
                }
            }
            
            log.debug("Result:")
            result.keys.forEach {
                if let matchingCategories = result[$0]  {
                    log.debug("Team: \($0) with categories: \(matchingCategories)")
                } else {
                    log.debug("Team: \($0) with no categories")
                }
            }
            return result
    }
}
