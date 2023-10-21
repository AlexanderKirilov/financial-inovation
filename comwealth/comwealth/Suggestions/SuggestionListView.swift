//
//  SuggestionListView.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import SwiftUI

struct SuggestionListView: View {
    private let survey: Survey
    @State private var suggestions: [Ticker]
    @State private var isLoading: Bool = false
    
    init(survey: Survey = SurveyQuestions.shared.preferencesSurvey, suggestions: [Ticker] = []) {
        self.survey = survey
        self.suggestions = suggestions
        print(survey)
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
                
                Button(action: { self.continueTapped() }) {
                    Text("PROCEED TO BEING RICH")
                        .bold()
                        .padding(15)
                }
                .buttonStyle(CustomButtonStyle(bgColor: Color.accentColor))
                .padding()
            }
        }
        .onAppear {
            guard suggestions.isEmpty else {
                return
            }
            
            print("🛜 Gotta do the fetching n shit")
            isLoading = true
            API.fetchSuggestions(for: survey) { result in
                isLoading = false
                switch result {
                case .success(let tickers):
                    print("✅ OPAAAAAAA")
                    suggestions = tickers
                case .failure(let error):
                    print("❌ OPAAAAAAA", error.localizedDescription)
                    suggestions = []
                }
            }
        }
    }
    
    private func continueTapped() {
        print("✅ Show detail screen")
    }
}

struct SuggestionListView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionListView(suggestions: [Ticker.sample, Ticker.sample])
            .preferredColorScheme(.light)
    }
}
