//
//  SummaryView.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import SwiftUI
import Combine

struct SummaryView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding private var path: NavigationPath
    private let suggestions: [Ticker]
    
    @State private var amount: String = "5000"
    
    private var series: [Series] {
        [
            tenYearAmount,
            Series(name: suggestions.first!.symbol, points: suggestions.first!.chartPoints)
        ]
    }
    
    private var tenYearAmount: Series {
        let points: [DataPoint] = Array(1...30).map {
            .init(date: ChartData.date(year: 2022, month: 3, day: $0 + 1), value: (Int(amount) ?? 0) * $0)
        }
        return Series(name: "Deposits", points: points)
    }
    
    init(path: Binding<NavigationPath>, suggestions: [Ticker]) {
        self._path = path
        self.suggestions = suggestions
    }
    
    var body: some View {
        VStack {
            LineChart(data: series)
                .frame(height: 200)
                .background(.white)
                .cornerRadius(20)
                .padding(16)
                .shadow(radius: 4)
            
            VStack {
                HStack {
                    Text("Enter monthly amount:")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.5))
                        
                    
                    Spacer()
                }
                .padding(16)
                .frame(height: 32)
                
                HStack {
                    Text("EUR")
                        .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.5))
                        .padding()
                        .frame(height: 32)
                        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                        .cornerRadius(8)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.numberPad)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .onReceive(Just(amount)) { newValue in
                            print(series)
                        }
                }
                .padding(16)
                .frame(height: 32)
            }
            .frame(height: 100)
            .foregroundColor(.clear)
            .background(.white)
            .cornerRadius(20)
            .padding(16)
            .shadow(radius: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.5)
                    .stroke(Color.clear, lineWidth: 1)
            )
            
            Spacer()
            
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: "arrow.left")
        })
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(path: .constant(NavigationPath(["SummaryView"])), suggestions: [Ticker.sample])
            .preferredColorScheme(.light)
    }
}
