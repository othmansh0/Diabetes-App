//
//  CustomChartFormatter.swift
//  TestCharts
//
//  Created by othman shahrouri on 2/23/22.
//  Copyright © 2022 aiwiguna. All rights reserved.
//

import Foundation
import Charts
import UIKit

public class CustomChartFormatter: NSObject, IAxisValueFormatter {

    var days  = ["SUN", "MON", "TUES", "WED", "THU", "FRI", "SAT"]

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return days[Int(value)]
    }

}
