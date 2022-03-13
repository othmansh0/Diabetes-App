//
//  CustomValueFormatter.swift
//  TestCharts
//
//  Created by Antoni Wiguna on 06/07/20.
//  Copyright © 2020 aiwiguna. All rights reserved.
//

import Foundation
import Charts

import Foundation
import Charts

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd  "
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
