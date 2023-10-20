//
//  SurveyQuestions.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import Foundation

struct SurveyQuestions {
    private class ImportanceQuestion: MultipleChoiceQuestion {
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
        
        init(_ title: String) {
            let importanceAnswers = ["Not Important" , "Somewhat Important", "Very Important"]
            super.init(title: title, answers: importanceAnswers, tag: titleToTag(title))
        }
    }
    
    private let primaryUse = MultipleChoiceQuestion(title: "What are you primarily using our app for?",
                                            items: [
                                              "Work",
                                              "Fun",
                                              "Just trying it out",
                                              MultipleChoiceResponse("Other", allowsCustomTextEntry: true)
                                            ],
                                            multiSelect: true,
                                            tag: "what-using-for")
    private let newFeatures = InlineMultipleChoiceQuestionGroup(title: "What new features are important to you?",
                                                        questions: [
                                                          ImportanceQuestion("Faster load times"),
                                                          ImportanceQuestion("Dark mode support"),
                                                          ImportanceQuestion("Lasers"),
                                                        ],
                                                        tag: "importance-what-improvements")
    private let contactUs = BinaryQuestion(title: "Would you like to be contacted about new features?" ,
                                        answers: ["Yes", "No"],
                                        tag: "contact-us")
    private let contactForm = ContactFormQuestion(title: "Please share your contact info and we will reach out",
                                           tag: "contact-form")
    private let comments = BinaryQuestion(title: "Do you have any feedback or feature ideas for us?",
                                      answers: ["Yes", "No"],
                                      autoAdvanceOnChoice: true,
                                      tag: "do-you-have-feedback")
    private let commentsForm = CommentsFormQuestion(title: "Tell us your feedback or feature requests",
                                             subtitle: "Optionally leave your email",
                                             tag: "feedback-comments-form")
    
    var sampleSurvey: Survey {
        return Survey(
            questions: [
                contactUs,
                primaryUse,
                newFeatures,
                contactForm.setVisibleWhenSelected(contactUs.choices.first!),
                comments,
                commentsForm.setVisibleWhenSelected(comments.choices.first!),
            ],
            version: "001"
        )
    }
}
