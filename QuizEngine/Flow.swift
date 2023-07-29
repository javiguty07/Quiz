//
//  Flow.swift
//  QuizEngine
//
//  Created by Javier Gutiérrez on 29/7/23.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping AnswerCallback)
}

class Flow {
    private let questions: [String]
    private let router: Router
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion,
                           answerCallback: routeNext(from: firstQuestion)
            )
        }
    }
    
    private func routeNext(from question: String) -> Router.AnswerCallback {
        { [weak self] _ in
            guard let self,
                  let currentQuestionIndex = self.questions.firstIndex(of: question),
                  currentQuestionIndex+1 < self.questions.count
            else { return }
            let nextQuestion = self.questions[currentQuestionIndex+1]
            self.router.routeTo(question: nextQuestion,
                                answerCallback: self.routeNext(from: nextQuestion)
            )
        }
        
    }
}
