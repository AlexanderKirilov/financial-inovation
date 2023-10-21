//
//  SuggestionListView.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import SwiftUI
import Charts

struct SuggestionListView: View {
    struct DataPoint {
        let date: Date
        let value: Int
    }
    
    struct Series: Identifiable {
        let name: String
        let points: [DataPoint]
        var id: String { name }
    }
    
    static func date(year: Int, month: Int, day: Int = 1, hour: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        Calendar.current.date(from: DateComponents(year: year,
                                                   month: month,
                                                   day: day,
                                                   hour: hour,
                                                   minute: minutes,
                                                   second: seconds)) ?? Date()
    }
    
    let last30Days: [Series] = [
        .init(name: "Cupertino", points: [
            DataPoint(date: date(year: 2022, month: 5, day: 1), value: 54),
            DataPoint(date: date(year: 2022, month: 5, day: 2), value: 42),
            DataPoint(date: date(year: 2022, month: 5, day: 3), value: 88),
            DataPoint(date: date(year: 2022, month: 5, day: 4), value: 49),
            DataPoint(date: date(year: 2022, month: 5, day: 5), value: 42),
            DataPoint(date: date(year: 2022, month: 5, day: 6), value: 61),
            DataPoint(date: date(year: 2022, month: 5, day: 7), value: 67),
            DataPoint(date: date(year: 2022, month: 5, day: 8), value: 54),
            DataPoint(date: date(year: 2022, month: 5, day: 9), value: 47),
            DataPoint(date: date(year: 2022, month: 5, day: 10), value: 42),
            DataPoint(date: date(year: 2022, month: 5, day: 11), value: 71),
            DataPoint(date: date(year: 2022, month: 5, day: 12), value: 56),
            DataPoint(date: date(year: 2022, month: 5, day: 13), value: 81),
            DataPoint(date: date(year: 2022, month: 5, day: 14), value: 40),
            DataPoint(date: date(year: 2022, month: 5, day: 15), value: 49),
            DataPoint(date: date(year: 2022, month: 5, day: 16), value: 42),
            DataPoint(date: date(year: 2022, month: 5, day: 17), value: 58),
            DataPoint(date: date(year: 2022, month: 5, day: 18), value: 66),
            DataPoint(date: date(year: 2022, month: 5, day: 19), value: 62),
            DataPoint(date: date(year: 2022, month: 5, day: 20), value: 77),
            DataPoint(date: date(year: 2022, month: 5, day: 21), value: 55),
            DataPoint(date: date(year: 2022, month: 5, day: 22), value: 52),
            DataPoint(date: date(year: 2022, month: 5, day: 23), value: 42),
            DataPoint(date: date(year: 2022, month: 5, day: 24), value: 49),
            DataPoint(date: date(year: 2022, month: 5, day: 25), value: 58),
            DataPoint(date: date(year: 2022, month: 5, day: 26), value: 61),
            DataPoint(date: date(year: 2022, month: 5, day: 27), value: 68),
            DataPoint(date: date(year: 2022, month: 5, day: 28), value: 43),
            DataPoint(date: date(year: 2022, month: 5, day: 29), value: 49),
            DataPoint(date: date(year: 2022, month: 5, day: 30), value: 125)
        ]),
        .init(name: "San Francisco", points: [
            DataPoint(date: date(year: 2022, month: 5, day: 1), value: 81),
            DataPoint(date: date(year: 2022, month: 5, day: 2), value: 90),
            DataPoint(date: date(year: 2022, month: 5, day: 3), value: 52),
            DataPoint(date: date(year: 2022, month: 5, day: 4), value: 72),
            DataPoint(date: date(year: 2022, month: 5, day: 5), value: 84),
            DataPoint(date: date(year: 2022, month: 5, day: 6), value: 84),
            DataPoint(date: date(year: 2022, month: 5, day: 7), value: 137),
            DataPoint(date: date(year: 2022, month: 5, day: 8), value: 99),
            DataPoint(date: date(year: 2022, month: 5, day: 9), value: 81),
            DataPoint(date: date(year: 2022, month: 5, day: 10), value: 52),
            DataPoint(date: date(year: 2022, month: 5, day: 11), value: 66),
            DataPoint(date: date(year: 2022, month: 5, day: 12), value: 84),
            DataPoint(date: date(year: 2022, month: 5, day: 13), value: 84),
            DataPoint(date: date(year: 2022, month: 5, day: 14), value: 122),
            DataPoint(date: date(year: 2022, month: 5, day: 15), value: 147),
            DataPoint(date: date(year: 2022, month: 5, day: 16), value: 66),
            DataPoint(date: date(year: 2022, month: 5, day: 17), value: 72),
            DataPoint(date: date(year: 2022, month: 5, day: 18), value: 62),
            DataPoint(date: date(year: 2022, month: 5, day: 19), value: 55),
            DataPoint(date: date(year: 2022, month: 5, day: 20), value: 84),
            DataPoint(date: date(year: 2022, month: 5, day: 21), value: 122),
            DataPoint(date: date(year: 2022, month: 5, day: 22), value: 81),
            DataPoint(date: date(year: 2022, month: 5, day: 23), value: 95),
            DataPoint(date: date(year: 2022, month: 5, day: 24), value: 63),
            DataPoint(date: date(year: 2022, month: 5, day: 25), value: 72),
            DataPoint(date: date(year: 2022, month: 5, day: 26), value: 74),
            DataPoint(date: date(year: 2022, month: 5, day: 27), value: 79),
            DataPoint(date: date(year: 2022, month: 5, day: 28), value: 93),
            DataPoint(date: date(year: 2022, month: 5, day: 29), value: 84),
            DataPoint(date: date(year: 2022, month: 5, day: 30), value: 87)
        ])
    ]
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 24)
            
            Text("Suggestions")
                .bold()
            
            Spacer()
                .frame(height: 24)
            
            lineChart(for: last30Days)
                .background(.white)
                .cornerRadius(20)
                .padding()
                .shadow(radius: 4)
            
            Spacer()
                .frame(height: 24)
            
            areaChart(for: last30Days.first!.points)
                .background(.white)
                .cornerRadius(20)
                .padding()
                .shadow(radius: 4)
        }
//        .background(.lightGray)
    }
    
    private func lineChart(for data: [Series]) -> some View {
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
        .chartForegroundStyleScale(domain: [data.first!.name, data.last!.name], range: [Color.accentColor, Color.coral])
        .frame(height: 300)
    }
    
    private func areaChart(for data: [DataPoint]) -> some View {
        let startColor = Color.accentColor
        let endColor = Color.turquoise.opacity(0)
        let gradient = LinearGradient(
            stops: [
                Gradient.Stop(color: startColor, location: 0),
                Gradient.Stop(color: endColor, location: 1),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0.2),
            endPoint: UnitPoint(x: 0.5, y: 1.1)
        )
        
        return Chart(data, id: \.date) {
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
        .frame(height: 300)
    }
}
