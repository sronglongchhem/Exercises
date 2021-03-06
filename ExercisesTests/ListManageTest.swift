//
//  MusclesListManageTest.swift
//  ExercisesTests
//
//  Created by Dumbo on 20/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import XCTest
@testable import Exercises
import Moya

class ListManageTest: XCTestCase {

    var fakeNetwork : FakeNetwork!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
         fakeNetwork = FakeNetwork()
    }
    
    
    func testCategoryListManger() throws{
        let exp = expectation(description: "CategoryListManager loadfinish")
        let categoListManger = CategoryListManager.init(network: fakeNetwork)
        categoListManger.handler = { result in
            exp.fulfill()
        }
        categoListManger.load()
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertNotNil(categoListManger.list)
             XCTAssertNotNil(categoListManger.dictionary)
            
            let dictionary = MockData.categoryList().toDictionary()
            XCTAssertEqual(dictionary.count, categoListManger.list?.toDictionary().count)
            
        }
    }
    
    func testMusclesListManager() throws{
        let exp = expectation(description: "MusclesListManager loadfinish")
        let musclesListManager = MusclesListManager.init(network: fakeNetwork)
        musclesListManager.handler = { result in
            exp.fulfill()
        }
        musclesListManager.load()
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertNotNil(musclesListManager.list)
             XCTAssertNotNil(musclesListManager.dictionary)
            
            let dictionary = MockData.muscleList().toDictionary()
            XCTAssertEqual(dictionary.count, musclesListManager.dictionary?.count)
            
        }
    }
    
    func testEquipmentListManager() throws{
        let exp = expectation(description: "EquipmentListManager loadfinish")
        let equipmentListManager = EquipmentListManager.init(network: fakeNetwork)
        equipmentListManager.handler = { result in
            exp.fulfill()
        }
        equipmentListManager.load()
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertNotNil(equipmentListManager.list)
             XCTAssertNotNil(equipmentListManager.dictionary)
            
            let dictionary = MockData.muscleList().toDictionary()
            XCTAssertEqual(dictionary.count, equipmentListManager.dictionary?.count)
            
        }
    }
    
    func testExerciseListManagerand() throws{
        let exp = expectation(description: "ExerciseListManager loadfinish")
        exp.expectedFulfillmentCount = 2
        
        let exerciseListManager = ExerciseListManager.init(network: fakeNetwork)
        exerciseListManager.handler = { result in
            XCTAssertNotNil(exerciseListManager.list)
             XCTAssertNil(exerciseListManager.dictionary)
            
            if exerciseListManager.pageIndex == 1 {
                 XCTAssertEqual(2, exerciseListManager.list?.list?.count)
                XCTAssertEqual(false, exerciseListManager.isAllLoaded)
            }else if exerciseListManager.pageIndex == 2 {
                XCTAssertEqual(4, exerciseListManager.list?.list?.count)
                XCTAssertEqual(true, exerciseListManager.isAllLoaded)
            }
            
            exerciseListManager.loadMore(filter: nil)
            exp.fulfill()
        }
        exerciseListManager.loadMore(filter: nil)
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [exp], timeout: 10.0)
    }
    
    
    func testExerciseListManagerFilterByBodyPart() throws{
        let exp = expectation(description: "ExerciseListManagerFilter loadfinish")
        exp.expectedFulfillmentCount = 1
        
        //filter by category Id = 1 expected 2 item
        let filter = MockData.mockFilter
        
        let exerciseListManager = ExerciseListManager.init(network: fakeNetwork)
        exerciseListManager.handler = { result in
            XCTAssertNotNil(exerciseListManager.list)
            XCTAssertEqual(true, exerciseListManager.isAllLoaded)
            exp.fulfill()
        }
        exerciseListManager.reload(filter: filter)
        // testing reset all the proper
        XCTAssertNotNil(exerciseListManager.filter)
        XCTAssertFalse(exerciseListManager.isAllLoaded)
        XCTAssertNil(exerciseListManager.list)
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [exp], timeout: 10.0)
    }

    func testExerciseImageListManager() throws{
        let exp = expectation(description: "ExerciseImageListManager loadfinish")
        exp.expectedFulfillmentCount = 1
        
        let exerciseImageListManager = ExerciseImageListManager.init(network: fakeNetwork)
        exerciseImageListManager.handler = { result in
            XCTAssertNotNil(exerciseImageListManager.list)
            exp.fulfill()
        }
        exerciseImageListManager.loadImageFor(id: 1)
        // testing reset all the proper
        XCTAssertNil(exerciseImageListManager.list)
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [exp], timeout: 10.0)
    }
    
    func testSearchManager() throws{
        let exp = expectation(description: "SearchManager loadfinish")
        exp.expectedFulfillmentCount = 1
        let searchString = "Cable"
        
        let searchManager = SearchManager.init(network: fakeNetwork)
        searchManager.handler = { result in
            XCTAssertNotNil(searchManager.list)
            exp.fulfill()
        }
        searchManager.search(term: searchString)
        XCTAssertNotNil(searchManager.term)
        XCTAssertEqual(searchString, searchManager.term)
        // testing reset all the proper
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [exp], timeout: 10.0)
    }
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
