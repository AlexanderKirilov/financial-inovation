//
//  SummaryView.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import SwiftUI

struct SummaryView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding private var path: NavigationPath
    private let suggestions: [Ticker]
    private var series: [Series] {
        suggestions.map { Series(name: $0.symbol, points: $0.chartPoints) }
    }
    
    init(path: Binding<NavigationPath>, suggestions: [Ticker]) {
        self._path = path
        self.suggestions = suggestions
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            LineChart(data: series)
                .frame(height: 200)
                .background(.white)
                .cornerRadius(20)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .shadow(radius: 4)
            
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
