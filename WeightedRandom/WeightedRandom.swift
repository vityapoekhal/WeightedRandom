//
//  WeightedRandom.swift
//  WeightedRandom
//
//  Created by Victor Hyde on 04/12/2017.
//  Copyright © 2017 Victor Hyde. All rights reserved.
//

import Foundation

///
/// Randomly selects elements from an array,
/// each element has a known probability of selection.
///
public class WeightedRandom<Key: Hashable> {

    // MARK: - Properties

    /// Max possible weight for key
    private let maxWeight: UInt

    /// Min possible weight for key
    private let minWeight: UInt

    /// Calculating everything on set for best `pick()` performance
    private var weightsDict: [Key: UInt] = [:] {
        didSet {
            (self.weightsMap, self.weightsSum) = calc(dict: weightsDict)
        }
    }

    /// Supporting map for random calculation
    private var weightsMap: [(key: Key, weight: Int)] = []

    /// Sum of weights for random calculation
    private var weightsSum = 0

    // MARK: - Initialization

    ///
    /// - parameters:
    ///     - weightsDict: key / weights pairs
    ///     - maxWeight: max possible weight
    ///     - minWeight: min possible weight
    ///
    public init(weightsDict: [Key: UInt],
         maxWeight: UInt = UInt.max, minWeight: UInt = UInt.min) {

        self.maxWeight = maxWeight
        self.minWeight = minWeight
        setWeightsDict(weightsDict)

    }

    ///
    /// - parameters:
    ///     - keys: keys array
    ///     - initialWeight: will be set for every key
    ///     - maxWeight: max possible weight
    ///     - minWeight: min possible weight
    ///
    public convenience init(keys: [Key], initialWeight: UInt,
                     maxWeight: UInt = UInt.max, minWeight: UInt = UInt.min) {

        var weightsDict: [Key: UInt] = [:]

        for key in keys {
            weightsDict[key] = initialWeight
        }

        self.init(weightsDict: weightsDict, maxWeight: maxWeight, minWeight: minWeight)

    }

    // MARK: - Private

    /// Calculates internal state to perform random quickly
    private func calc(dict: [Key: UInt]) -> (map: [(key: Key, weight: Int)], sum: Int) {

        let map = dict.map { (key: $0.key, weight: Int($0.value)) }

        var sum = 0
        for weight in map {
            sum += weight.weight
        }

        return (map, sum)

    }

    /// Checks and sets weights dict
    private func setWeightsDict(_ weightsDict: [Key: UInt]) {

        for weight in weightsDict {
            if weight.value > maxWeight || weight.value < minWeight {
                fatalError("Initial weight does not consider min or max")
            }
        }

        self.weightsDict = weightsDict

    }

    /// Gets weight for key
    private func getWeight(key: Key) -> UInt {

        guard let weight = weightsDict[key] else {
            fatalError("Weight could not be found")
        }
        return weight

    }

    /// Makes random pick based on params
    /// - throws: when all weights are zero
    private func pick(map: [(key: Key, weight: Int)], sum: Int) throws -> Key {

        if sum < 1 {
            throw WeightedRandomError.allWeightsAreZero
        }

        var result = Int(arc4random_uniform(UInt32(sum)))

        var index = 0
        while result >= 0 {
            result -= map[index].weight
            index += 1
        }

        return map[index - 1].key

    }

    // MARK: - Public

    ///
    /// Sets weight for key
    ///
    /// - parameters:
    ///     - weight: weight
    ///     - key: key
    ///
    public func set(weight: UInt, by key: Key) {

        if weight > maxWeight || weight < minWeight {
            fatalError("Weight does not consider min or max")
        }

        self.weightsDict[key] = weight

    }

    ///
    /// Increases weight for a key until max.
    /// Always returns actual weight.
    ///
    /// - parameters:
    ///     - key: key
    ///
    /// - returns: new weight
    ///
    public func increaseWeight(for key: Key) -> UInt {

        let weight = getWeight(key: key)

        let newWeight = weight + 1
        if newWeight <= maxWeight {
            weightsDict[key] = newWeight
            return newWeight
        }

        return weight

    }

    ///
    /// Decreases weight for a key until min.
    /// Always returns actual weight.
    ///
    /// - parameters:
    ///     - key: key
    ///
    /// - returns: new weight
    ///
    public func decreaseWeight(for key: Key) -> UInt {

        let weight = getWeight(key: key)

        if weight == 0 {
            return weight
        }

        let newWeight = weight - 1
        if newWeight >= minWeight {
            weightsDict[key] = newWeight
            return newWeight
        }

        return weight

    }

    /// Returns key set
    /// - returns: set of all keys
    public func getKeys() -> Set<Key> {
        return Set(weightsDict.keys)
    }

    ///
    /// Picks a random key consider keys weights
    ///
    /// - returns: weighted random key
    /// - throws: if all weights are zero
    ///
    public func pick() throws -> Key {
        return try pick(map: weightsMap, sum: weightsSum)
    }

    ///
    /// Picks a random keys consider keys weights
    ///
    /// - parameters:
    ///     - amount: amount of keys needed
    ///
    /// - returns: array of weighted random keys
    /// - throws: if all weights are zero
    ///
    public func pick(amount: Int) throws -> [Key] {

        if amount < 1 {
            fatalError("Amount less than one")
        }

        var result: [Key] = []
        for _ in 1...amount {
            result.append(try pick(map: weightsMap, sum: weightsSum))
        }

        return result

    }

}

public enum WeightedRandomError: Error {

    /// All weights are zero
    case allWeightsAreZero

}
