//
//  ChartView.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 21.10.23.
//

import SwiftUI
import Charts

// MARK: - Data

enum ChartData {
    static let last30Days: [Series] = [
        .init(name: "Cupertino", points: [
            .init(date: date(year: 2022, month: 5, day: 1), value: 54),
            .init(date: date(year: 2022, month: 5, day: 2), value: 42),
            .init(date: date(year: 2022, month: 5, day: 3), value: 88),
            .init(date: date(year: 2022, month: 5, day: 4), value: 49),
            .init(date: date(year: 2022, month: 5, day: 5), value: 42),
            .init(date: date(year: 2022, month: 5, day: 6), value: 61),
            .init(date: date(year: 2022, month: 5, day: 7), value: 67),
            .init(date: date(year: 2022, month: 5, day: 8), value: 54),
            .init(date: date(year: 2022, month: 5, day: 9), value: 47),
            .init(date: date(year: 2022, month: 5, day: 10), value: 42),
            .init(date: date(year: 2022, month: 5, day: 11), value: 71),
            .init(date: date(year: 2022, month: 5, day: 12), value: 56),
            .init(date: date(year: 2022, month: 5, day: 13), value: 81),
            .init(date: date(year: 2022, month: 5, day: 14), value: 40),
            .init(date: date(year: 2022, month: 5, day: 15), value: 49),
            .init(date: date(year: 2022, month: 5, day: 16), value: 42),
            .init(date: date(year: 2022, month: 5, day: 17), value: 58),
            .init(date: date(year: 2022, month: 5, day: 18), value: 66),
            .init(date: date(year: 2022, month: 5, day: 19), value: 62),
            .init(date: date(year: 2022, month: 5, day: 20), value: 77),
            .init(date: date(year: 2022, month: 5, day: 21), value: 55),
            .init(date: date(year: 2022, month: 5, day: 22), value: 52),
            .init(date: date(year: 2022, month: 5, day: 23), value: 42),
            .init(date: date(year: 2022, month: 5, day: 24), value: 49),
            .init(date: date(year: 2022, month: 5, day: 25), value: 58),
            .init(date: date(year: 2022, month: 5, day: 26), value: 61),
            .init(date: date(year: 2022, month: 5, day: 27), value: 68),
            .init(date: date(year: 2022, month: 5, day: 28), value: 43),
            .init(date: date(year: 2022, month: 5, day: 29), value: 49),
            .init(date: date(year: 2022, month: 5, day: 30), value: 125)
        ]),
        .init(name: "San Francisco", points: [
            .init(date: date(year: 2022, month: 5, day: 1), value: 81),
            .init(date: date(year: 2022, month: 5, day: 2), value: 90),
            .init(date: date(year: 2022, month: 5, day: 3), value: 52),
            .init(date: date(year: 2022, month: 5, day: 4), value: 72),
            .init(date: date(year: 2022, month: 5, day: 5), value: 84),
            .init(date: date(year: 2022, month: 5, day: 6), value: 84),
            .init(date: date(year: 2022, month: 5, day: 7), value: 137),
            .init(date: date(year: 2022, month: 5, day: 8), value: 99),
            .init(date: date(year: 2022, month: 5, day: 9), value: 81),
            .init(date: date(year: 2022, month: 5, day: 10), value: 52),
            .init(date: date(year: 2022, month: 5, day: 11), value: 66),
            .init(date: date(year: 2022, month: 5, day: 12), value: 84),
            .init(date: date(year: 2022, month: 5, day: 13), value: 84),
            .init(date: date(year: 2022, month: 5, day: 14), value: 122),
            .init(date: date(year: 2022, month: 5, day: 15), value: 147),
            .init(date: date(year: 2022, month: 5, day: 16), value: 66),
            .init(date: date(year: 2022, month: 5, day: 17), value: 72),
            .init(date: date(year: 2022, month: 5, day: 18), value: 62),
            .init(date: date(year: 2022, month: 5, day: 19), value: 55),
            .init(date: date(year: 2022, month: 5, day: 20), value: 84),
            .init(date: date(year: 2022, month: 5, day: 21), value: 122),
            .init(date: date(year: 2022, month: 5, day: 22), value: 81),
            .init(date: date(year: 2022, month: 5, day: 23), value: 95),
            .init(date: date(year: 2022, month: 5, day: 24), value: 63),
            .init(date: date(year: 2022, month: 5, day: 25), value: 72),
            .init(date: date(year: 2022, month: 5, day: 26), value: 74),
            .init(date: date(year: 2022, month: 5, day: 27), value: 79),
            .init(date: date(year: 2022, month: 5, day: 28), value: 93),
            .init(date: date(year: 2022, month: 5, day: 29), value: 84),
            .init(date: date(year: 2022, month: 5, day: 30), value: 87)
        ])
    ]
    
    static func date(year: Int,
                     month: Int,
                     day: Int = 1,
                     hour: Int = 0,
                     minutes: Int = 0,
                     seconds: Int = 0) -> Date {
        Calendar.current.date(from: DateComponents(year: year,
                                                   month: month,
                                                   day: day,
                                                   hour: hour,
                                                   minute: minutes,
                                                   second: seconds)) ?? Date()
    }
}

// MARK: - Models

struct DataPoint: Decodable {
    let date: Date
    let value: Int
    
    init(date: Date, value: Int) {
        self.date = date
        self.value = value
    }
    
    enum CodingKeys: CodingKey {
        case date
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        self.date = dateFormatter.date(from: dateString)!
        let floatingValue = try container.decode(Double.self, forKey: .value)
        self.value = Int(floatingValue)
    }
}

struct Series: Identifiable {
    let name: String
    let points: [DataPoint]
    var id: String { name }
}

// MARK: - Views

struct AreaChart: View {
    var data: [DataPoint]
    
    private let startColor = Color.accentColor
    private let endColor = Color.turquoise.opacity(0)
    private var gradient: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: startColor, location: 0),
                Gradient.Stop(color: endColor, location: 1),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0.2),
            endPoint: UnitPoint(x: 0.5, y: 1.1)
        )
    }
    
    var body: some View {
        Chart(data, id: \.date) {
            AreaMark(
                x: .value("Date", $0.date),
                y: .value("Value", $0.value)
            )
            .foregroundStyle(gradient)
            .interpolationMethod(.cardinal)

            LineMark(
                x: .value("Date", $0.date),
                y: .value("Value", $0.value)
            )
            .lineStyle(StrokeStyle(lineWidth: 2.0))
            .interpolationMethod(.cardinal)
            .foregroundStyle(Color.accentColor)
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
    }
}

struct LineChart: View {
    var data: [Series]
    
    init(data: [Series]) {
        self.data = data
    }
    
    init(data: [DataPoint]) {
        self.data = [Series(name: "Chart", points: data)]
    }
    
    private var styleDomain: [String] {
        return data.map { $0.name }
    }
    
    private var styleRange: [Color] {
        return [Color.accentColor, Color.coral, Color.turquoise]
    }
    
    var body: some View {
        Chart(data) { series in
            ForEach(series.points, id: \.date) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Value", point.value)
                )
                .interpolationMethod(.cardinal)
                .foregroundStyle(by: .value("Name", series.name))
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
//        .chartLegend(.hidden)
        .chartLegend(position: .bottomLeading, alignment: .bottom)
        .chartForegroundStyleScale(domain: styleDomain, range: styleRange)
    }
}
