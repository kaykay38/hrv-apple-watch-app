//
//  HRVCalculatorTests.swift
//  HRV Monitor WatchKit ExtensionTests
//
//  Created by Mia Hunt on 4/27/22.
//

import XCTest
@testable import HRV_Monitor_WatchKit_Extension

class HRVCalculatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_addSample_givenValidParams() throws {
        // Arrange
        let hrvCalculator: HRVCalculator = HRVCalculator()

        let firstTime: Date = Date.now
        let secondTime: Date = firstTime.addingTimeInterval(1.7)
        let milliSecDiff: Double = 1700

        let firstHR: Double = 97/60
        let secondHR: Double = 100/60

        let secondHRBeats: Double = secondHR/1000 * milliSecDiff
        let secondAverageIBI: Double = milliSecDiff/secondHRBeats

        // Act
        hrvCalculator.addSample(firstTime, firstTime, firstHR)
        hrvCalculator.addSample(secondTime, firstTime, secondHR)


        // Assert
        let actualTable = hrvCalculator.HRSampleTable
        let expectedTable = [
        HRSample(date: firstTime, timeDiffMilliSec: 0, currentHRPerMilliSec: firstHR/1000, averageIBI: 0, IBIdiff: 0, accuracy: 0),
        HRSample(date: secondTime, timeDiffMilliSec: milliSecDiff, currentHRPerMilliSec: secondHR/1000, averageIBI: secondAverageIBI, IBIdiff: secondAverageIBI, accuracy: 0)
        ]


        XCTAssertEqual(actualTable, expectedTable)
    }


    //    func test_updateHRV_givenEmptyList() throws {
    //        XCTAssert(<#T##expression: Bool##Bool#>)
    //    }
    //
    //    func test_RMSSD_givenEmptyList() throws {
    //        XCTAssert(<#T##expression: Bool##Bool#>)
    //    }
    //
    //    func test_RMSSD_givenOneItemList() throws {
    //        XCTAssert(<#T##expression: Bool##Bool#>)
    //    }
    //
    //    func test_RMSSD_givenNull() throws {
    //        XCTAssert(<#T##expression: Bool##Bool#>)
    //    }
    //
    //    func test_RMSSD_givenEmptyList() throws {
    //        XCTAssert(<#T##expression: Bool##Bool#>)
    //    }
    //
    //    func test_RMSSD_givenOneItemList() throws {
    //        XCTAssert(<#T##expression: Bool##Bool#>)
    //    }
    //
    //    func test_RMSSD_givenNull() throws {
    //        XCTAssert(<#T##expression: Bool##Bool#>)
    //    }
    //
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}