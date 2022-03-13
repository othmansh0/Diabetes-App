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
        axis?.entries = [0, 1, 2, 3, 4, 5, 6]
    }

}
