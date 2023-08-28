//
//  StatsModelResponse.swift
//  Gespage
//
//  Created by duy.pham on 27/08/2023.
//

import Foundation

struct StatsModelResponse: Codable {
    var generatedCo2: Double
    var savedCo2: Double
    var consumedTrees: Double
    var savedTrees: Double
    var consumedWater: Double
    var savedWater: Double
    var totalExpense: Double
    var savedMoney: Double
    var ecologicalTrend: Double
    var copies: Double
    var prints: Double
    var scans: Double
}
