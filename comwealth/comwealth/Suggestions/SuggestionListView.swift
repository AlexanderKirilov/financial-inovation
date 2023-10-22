//
//  SuggestionListView.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import SwiftUI

struct SuggestionListView: View {
    @Binding private var path: NavigationPath
    private let survey: Survey
    @State private var suggestions: [Ticker] = []
    @State private var isLoading: Bool = false
    
    init(path: Binding<NavigationPath>,
         survey: Survey = SurveyQuestions.shared.preferencesSurvey,
         suggestions: [Ticker] = []) {
        self._path = path
        self.survey = survey
        self.suggestions = suggestions
    }
    
    var body: some View {
        VStack {
            if isLoading {
                Spacer()
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
                
                Button(action: continueTapped) {
                    Text("PROCEED TO BEING RICH")
                        .bold()
                        .padding(15)
                }
                .buttonStyle(CustomButtonStyle(bgColor: Color.accentColor))
                .padding()
            }
        }
        .onAppear(perform: fetchData)
        .navigationTitle("Suggestions")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: String.self) { view in
            switch view {
            case "SummaryView":
                SummaryView(path: $path, suggestions: suggestions)
            default:
                Text("Unknown")
            }
        }
    }
    
    private func fetchData() {
//        guard suggestions.isEmpty else { return }
        print("🛜 Fetching...")
        isLoading = true
        API.fetchSuggestions(for: survey) { result in
            isLoading = false
            switch result {
            case .success(let tickers):
                print("✅ OPAAAAAAA")
                suggestions = tickers
            case .failure(let error):
                print("❌ OPAAAAAAA", error.localizedDescription)
                suggestions = [Ticker.sample, Ticker.sample, Ticker.sample]
            }
        }
    }
    
    private func continueTapped() {
        print("🟰 Show summary screen")
        path.append("SummaryView")
    }
}

struct SuggestionListView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionListView(path: .constant(NavigationPath()), suggestions: [Ticker.sample, Ticker.sample])
            .preferredColorScheme(.light)
    }
}
