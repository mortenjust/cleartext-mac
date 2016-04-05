//
//  ParkBenchTimer.swift
//  Simpler
//
//  Created by Morten Just Petersen on 12/5/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import CoreFoundation

class ParkBenchTimer {

    private let startTime: CFAbsoluteTime
    private var endTime: CFAbsoluteTime?

    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        return duration
    }

    var duration: CFAbsoluteTime {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return CFAbsoluteTimeGetCurrent() - startTime
        }
    }
}
