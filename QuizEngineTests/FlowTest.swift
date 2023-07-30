//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Javier Gutiérrez on 29/7/23.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    
    let router = RouterSpy()
    
    func test_start_givenNoQuestions_doesNotRouteToQuestion() {
        let sut = givenSUT(questions: [])
        sut.start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_givenOneQuestions_routesToCorrectQuestion() {
        let sut = givenSUT(questions: ["Q1"])
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_givenOneQuestions_routesToCorrectQuestion_2() {
        let sut = givenSUT(questions: ["Q2"])
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_givenTwoQuestions_routesToFirstQuestion() {
        let sut = givenSUT(questions: ["Q1", "Q2"])
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_givenTwoQuestions_routesToFirstQuestionTwice() {
        let sut = givenSUT(questions: ["Q1", "Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_givenThreeQuestions_routesToSecondAndThirdQuestions() {
        let sut = givenSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_givenOneQuestions_doesNotRouteToAnotherQuestion() {
        let sut = givenSUT(questions: ["Q1"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_givenNoQuestions_routeToResult() {
        let sut = givenSUT(questions: [])
        sut.start()
        XCTAssertEqual(router.routedResult, [:])
    }
    
    func test_start_givenOneQuestion_doesNotRouteToResult() {
        let sut = givenSUT(questions: ["Q1"])
        sut.start()
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstQuestion_givenTwoQuestion_doesNotRouteToResult() {
        let sut = givenSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_givenTwoQuestion_routeToResult() {
        let sut = givenSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedResult, ["Q1":"A1", "Q2":"A2"])
    }
    
    // MARK: Helpers
    
    func givenSUT(questions: [String]) -> Flow {
        Flow(questions: questions, router: router)
    }

    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var routedResult: [String:String]? = nil
        var answerCallback: ((String) -> Void) = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping Router.AnswerCallback) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: [String:String]) {
            routedResult = result
        }
    }
    
}
