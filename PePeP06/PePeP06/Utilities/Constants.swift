//
//  Constants.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 26/12/2017.
//

import Foundation

struct Constants {
    /// Default app settings
    struct Settings {
        static let selectedTeams = [Constants.Taso.pepeFutsalID, Constants.Taso.pepeFootballID]
        static let selectedCompetitions = ["Jalkapallo", "Futsal"]
    }
    
    /// Taso related constants
    struct Taso {
        static let pepeFutsalID = "141460"
        static let pepeFootballID = "109887"
    }
}
