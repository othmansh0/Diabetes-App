//
//  baseVC.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 2/17/22.
//
class Patient {
    static let sharedInstance = Patient()
    var doctorID: String!
    var weeksCount:Int!
    var beforeReadings = [String]()
    var beforeTimes = [String]()
    var deltaBeforeTimes = [String]() //stores timeInterval of each reading to be plotted on chart
    var afterReadings = [String]()
    var afterTimes = [String]()
    var deltaAfterTimes = [String]() //stores timeInterval of each reading to be plotted on chart
}
