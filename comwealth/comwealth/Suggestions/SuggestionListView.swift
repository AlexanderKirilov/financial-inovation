//
//  SuggestionListView.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import SwiftUI

struct SuggestionListView: View {
    @State private var suggestions: [Ticker]
    @State private var isLoading: Bool = false
    
    init(suggestions: [Ticker] = []) {
        self.suggestions = suggestions
    }
    
    var body: some View {
        VStack {
            Text("Suggestions")
                .bold()
                .padding(EdgeInsets(top: 24, leading: 0, bottom: 8, trailing: 0))
            
            Spacer()
            
            if isLoading {
                ProgressView()
                Spacer()
                    .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    ForEach(suggestions) {
                        SuggestionView(ticker: $0)
                            .frame(height: 320) // TODO: - Adjust this height
                    }
                }
            }
            
            Button(action: { self.continueTapped() }) {
                Text("PROCEED TO BEING RICH")
                    .bold()
                    .padding(15)
            }
            .buttonStyle(CustomButtonStyle(bgColor: Color.accentColor))
            .padding()
        }
        .onAppear {
            guard suggestions.isEmpty else {
                return
            }
            
            print("🛜 Gotta do the fetching n shit")
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isLoading = false
                suggestions = [Ticker.sample, Ticker.sample, Ticker.sample]
            }
        }
    }
    
    private func continueTapped() {
        
    }
}

struct SuggestionListView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionListView(suggestions: [Ticker.sample, Ticker.sample])
            .preferredColorScheme(.light)
    }
}
