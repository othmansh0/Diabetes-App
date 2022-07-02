//
//  XAxisWeekRenderer.swift
//  TestCharts
//
//  Created by othman shahrouri on 2/22/22.
//  Copyright © 2022 aiwiguna. All rights reserved.
//

import Foundation
import UIKit
import Charts
class XAxisWeekRenderer: XAxisRenderer {

    override func computeAxis(min: Double, max: Double, inverted: Bool) {
        axis?.entries = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
    }

}
