//
//  UtilityFunctions.swift
//  PePeP06
//
//  Created by Mikko Tapaninen on 23/12/2017.
//

import Foundation

/**
 * Compare two optionals. Optionals are equal if both are nil
 * or if unwrapped optionals are equal.
 *
 * - Parameter lhs: Left hand side object
 * - Parameter rhs: Right hand side object
 * - Returns: `true` if both are nil or equal, `false` otherwise
 */
func optionalsAreEqual<T: Equatable>(lhs: T?, rhs: T?) -> Bool {
    if let lhs = lhs, let rhs = rhs {
        return lhs == rhs
    } else {
        return lhs == nil && rhs == nil
    }
}

/**
 * Compare two optional arrays. Optional arrays are equal if both are nil
 * or if unwrapped optional arrays have same elements in same order.
 *
 * - Parameter lhs: Left hand side object
 * - Parameter rhs: Right hand side object
 * - Returns: `true` if both are nil or equal, `false` otherwise
 */
func optionalArraysAreEqual<T: Equatable>(lhs: [T?]?, rhs: [T?]?) -> Bool {
    if let lhs = lhs, let rhs = rhs {
        return lhs.elementsEqual(rhs, by: {return optionalsAreEqual(lhs: $0, rhs: $1)} )
    } else {
        return lhs == nil && rhs == nil
    }
}

/**
 * Player full name.
 *
 * - Parameter player: Current player
 * - Returns: Players fullname
 */
func playerFullName(player: TasoPlayer) -> String {
    var result = ""
    if let firstName = player.first_name {
        result = firstName
    }
    
    if let lastName = player.last_name {
        if result.isEmpty {
            result = lastName
        } else {
            result += " " + lastName
        }
    }
    
    return result
}
