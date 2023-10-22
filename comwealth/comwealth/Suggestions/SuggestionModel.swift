//
//  SuggestionModel.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 21.10.23.
//

import SwiftUI

enum Sector: String, Decodable {
    case realEstate = "realestate"
    case cyclical = "consumer_cyclical"
    case defensive = "consumer_defensive"
    case materials = "basic_materials"
    case tech = "technology"
    case communications = "communication_services"
    case financial = "financial_services"
    case utilities
    case industrials
    case energy
    case health = "healthcare"
    
    var image: Image {
        let imageName: String
        switch self {
        case .realEstate:
            imageName = "house.fill"
        case .cyclical:
            imageName = "sparkles"
        case .defensive:
            imageName = "basket.fill"
        case .materials:
            imageName = "square.3.layers.3d.down.backward"
        case .tech:
            imageName = "macbook"
        case .communications:
            imageName = "dot.radiowaves.left.and.right"
        case .financial:
            imageName = "banknote.fill"
        case .utilities:
            imageName = "wrench.and.screwdriver.fill"
        case .industrials:
            imageName = "gearshape.2.fill"
        case .energy:
            imageName = "bolt"
        case .health:
            imageName = "cross.case.fill"
        }
        return Image(systemName: imageName)
    }
    
    var name: String {
        let displayName: String
        switch self {
        case .realEstate:
            displayName = "Real Estate"
        case .cyclical:
            displayName = "Cyclical (Non-essentials)"
        case .defensive:
            displayName = "Defensive (Essentials)"
        case .materials:
            displayName = "Raw Materials"
        case .tech:
            displayName = "Technology"
        case .communications:
            displayName = "Communications"
        case .financial:
            displayName = "Finance"
        case .utilities:
            displayName = "Utility"
        case .industrials:
            displayName = "Industrials"
        case .energy:
            displayName = "Energy"
        case .health:
            displayName = "Healthcare"
        }
        return displayName
    }
}

struct Ticker: Identifiable, Decodable {
    let id: Int
    let symbol: String
    let longName: String?
    let sector: Sector
    let shortSummary: String?
    let longSummary: String
    let performancePercentage: Double
    let chartPoints: [DataPoint]
    
    var image: Image { sector.image }
    var displayName: String { longName ?? symbol }
    var displayPerformance: String { "+\(String(format: "%.2f", performancePercentage))%" }
    var description: String { shortSummary ?? longSummary }
    
    static let sample = Ticker(id: 1,
                               symbol: "DJUSRE",
                               longName: "Dow Jones U.S. Real Estate Index",
                               sector: .realEstate,
                               shortSummary: "Non-homeless index",
                               longSummary: "For all the people in the US who don't live on the streets",
                               performancePercentage: 1.02,
                               chartPoints: ChartData.last30Days.first!.points)
}

struct SuggestionResponse: Decodable {
    let success: Bool
    let data: [Ticker]
}
