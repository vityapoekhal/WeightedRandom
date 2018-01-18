//
//  WeightedRandomTests.swift
//  WeightedRandomTests
//
//  Created by Victor Hyde on 17/01/2018.
//  Copyright © 2018 Victor Hyde. All rights reserved.
//

import XCTest
import WeightedRandom

class WeightedRandomTests: XCTestCase {

    func testWeightedRandomInit1() {
        let keys = ["1", "2", "3"]
        let random = WeightedRandom<String>(keys: keys, initialWeight: 5)
        XCTAssert(random.getKeys() == Set(keys))
    }

    func testWeightedRandomInit2() {
        let weightsDict: [String: UInt] = ["1": 1, "2": 2, "3": 3]
        let random = WeightedRandom<String>(weightsDict: weightsDict)
        XCTAssert(random.getKeys() == Set(weightsDict.keys))
    }

    func testMaxWeight() {
        let key = "1"
        let weight: UInt = 5
        let random = WeightedRandom<String>(keys: [key], initialWeight: weight, maxWeight: weight)
        XCTAssert(random.increaseWeight(for: key) == weight)
    }

    func testMinWeight() {
        let key = "1"
        let weight: UInt = 5
        let random = WeightedRandom<String>(keys: [key], initialWeight: weight, minWeight: weight)
        XCTAssert(random.decreaseWeight(for: key) == weight)
    }

    func testIncreaseWeight() {
        let key = "1"
        let weight: UInt = 5
        let random = WeightedRandom<String>(keys: [key], initialWeight: weight)
        XCTAssert(random.increaseWeight(for: key) == weight + 1)
    }

    func testDecreaseWeight() {
        let key = "1"
        let weight: UInt = 5
        let random = WeightedRandom<String>(keys: [key], initialWeight: weight)
        XCTAssert(random.decreaseWeight(for: key) == weight - 1)
    }

    func testSetWeight() {
        let key = "1"
        let initWeight: UInt = 5
        let newWeight: UInt = 10
        let random = WeightedRandom<String>(keys: [key], initialWeight: initWeight)
        random.set(weight: newWeight, by: key)
        XCTAssert(random.decreaseWeight(for: key) == newWeight - 1)
    }

    func testPick() {
        let key = "3"
        let weightsDict: [String: UInt] = ["1": 0, "2": 0, key: 1]
        let random = WeightedRandom<String>(weightsDict: weightsDict)
        XCTAssert(try! random.pick() == key)
    }

}
