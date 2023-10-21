//
//  SurveyQuestions.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 20.10.23.
//

import Foundation

struct SurveyQuestions {
    static let shared = SurveyQuestions()
    
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
    
    var preferencesSurvey: Survey {
        return Survey(
            questions: [
                MultipleChoiceQuestion(title: "What is your primary investment goal?",
                                       items: [
                                        "Preserve capital",
                                        "Balanced growth",
                                        "Build wealth"
                                       ],
                                       tag: "primary-goal"),
                MultipleChoiceQuestion(title: "What is your age?",
                                       items: [
                                        "18-29",
                                        "30-50",
                                        "51-65",
                                        "Beyond 65"
                                       ],
                                       tag: "age"),
                MultipleChoiceQuestion(title: "What is your investment horizon?",
                                       items: [
                                        "Up to 2 years",
                                        "2-5 years",
                                        "6-10 years",
                                        "More than 10 years"
                                       ],
                                       tag: "investment-horizon"),
                MultipleChoiceQuestion(title: "How would you describe your approach to decision-making?",
                                       items: [
                                        "I avoid making decisions",
                                        "I reluctantly make decisions",
                                        "I am confident in my decision-making"
                                       ],
                                       tag: "decision-making"),
                MultipleChoiceQuestion(title: "When you hear the word \"risk\" in relation to your finances, what comes to mind?",
                                       items: [
                                        "I am afraid of losing my finances",
                                        "I understand that it's part of the process",
                                        "Where there is risk, there is reward",
                                        "I get excited"
                                       ],
                                       tag: "finance-risk"),
                MultipleChoiceQuestion(title: "How familiar are you with investing in financial instruments?",
                                       items: [
                                        "Not familiar at all",
                                        "Relatively familiar",
                                        "Very familiar"
                                       ],
                                       tag: "proficiency"),
                MultipleChoiceQuestion(title: "What would you do if your portfolio loses more than 20% of its value in a single year?",
                                       items: [
                                        "Do nothing",
                                        "Invest more",
                                        "Sell everything",
                                        "Sell some of my investments"
                                       ],
                                       tag: "20-percent-loss"),
                MultipleChoiceQuestion(title: "What is your expected annual return for your investment portfolio?",
                                       items: [
                                        "3-5%",
                                        "5-7%",
                                        "7-9%",
                                        "Above 10%"
                                       ],
                                       tag: "expected-return"),
                BinaryQuestion(title: "Is it important for you to make investments in environmentally sustainable companies?",
                               answers: ["No", "Yes"],
                               autoAdvanceOnChoice: true,
                               tag: "sustainability")
            ],
            version: "001"
        )
    }
}
