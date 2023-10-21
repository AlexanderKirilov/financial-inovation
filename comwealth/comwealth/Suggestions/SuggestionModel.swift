//
//  SuggestionModel.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 21.10.23.
//

import SwiftUI

enum Sector: String {
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
        var imageName: String
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
}

struct Ticker: Identifiable {
    let symbol: String
    let longName: String?
    let sector: Sector
    let shortSummary: String?
    let longSummary: String
    let performancePercentage: Double
    let chartPoints: [DataPoint]
    
    var id: String { UUID().uuidString }
    var image: Image { sector.image }
    var displayName: String { longName ?? symbol }
    var displayPerformance: String { "+\(String(format: "%.2f", performancePercentage))%" }
    var description: String { shortSummary ?? longSummary }
    
    static let sample = Ticker(symbol: "DJUSRE",
                               longName: "Dow Jones U.S. Real Estate Index",
                               sector: .realEstate,
                               shortSummary: "Non-homeless index",
                               longSummary: "For all the people in the US who don't live on the streets",
                               performancePercentage: 1.02,
                               chartPoints: ChartData.last30Days.first!.points)
}

//struct SuggestionResponse: Codable {
//    struct ResponseData {
//        let etfs: [Ticker]
//    }
//    
//    let status: String
//    let data: ResponseData
//    
//    init(from decoder: Decoder) throws {
//        // add parsing here
//        self.status = "success"
//        self.data = ResponseData(etfs: [])
//    }
//}
