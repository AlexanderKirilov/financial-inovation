//
//  ContentView.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import SwiftUI

class SurveyDelegate: SurveyViewDelegate {
    func surveyCompleted(with survey: Survey) {
        let randomId = String(Int.random(in: 0...100))
        let surveyPath = "survey_filled_\(randomId).json"
        let jsonUrl = URL.documentsDirectory.appendingPathComponent(surveyPath)
        try? Survey.saveToFile(survey: survey, url: jsonUrl)
        print("Saved survey to: \n" , jsonUrl.path)
    }
    
    func surveyDeclined() {
        // NO-OP
    }
    
    func surveyRemindMeLater() {
        // NO-OP
    }
}

struct ContentView: View {
    let delegate = SurveyDelegate()
    var survey: Survey = SurveyQuestions().sampleSurvey
    
    init() {
        let jsonUrl = URL.documentsDirectory.appendingPathComponent("sample_survey.json")
        try? Survey.saveToFile(survey: survey, url: jsonUrl)
        print("Saved survey to:\n", jsonUrl.path)
 
        if let loadedSurvey = try? Survey.loadFromFile(url: jsonUrl) {
            print("Loaded survey from:\n ", jsonUrl)
            survey = loadedSurvey
        }
    }
    
    var body: some View {
        SurveyView(survey: survey, delegate: delegate)
            .preferredColorScheme(.light)
    }
}
