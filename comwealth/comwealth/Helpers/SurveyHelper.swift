//
//  SurveyHelper.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import Foundation

extension Survey {
    static func loadFromFile(url: URL) throws -> Survey {
        let jsonData = try Data(contentsOf: url)
        let survey = try JSONDecoder().decode(Survey.self, from: jsonData)
        return survey
    }
    
    static func saveToFile(survey: Survey, url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(survey)
        try jsonData.write(to: url, options: [.atomic])
    }
}


func titleToTag( _ tag : String ) -> String {
    let invalidCharacters = CharacterSet(charactersIn: "\\/:*?\"<>|")
        .union(.newlines)
        .union(.illegalCharacters)
        .union(.controlCharacters)
    
    return tag
        .components(separatedBy: invalidCharacters)
        .joined(separator: "")
        .components(separatedBy: .whitespacesAndNewlines)
        .filter { !$0.isEmpty }
        .joined(separator: "-")
    
}

extension Bundle {
    var releaseVersionNumber: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    var buildVersionNumber: String {
        return (infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
}

