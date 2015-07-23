//
//  ISO8601IntervalRecurrenceTests.swift
//  ISO8601IntervalRecurrenceTests
//
//  Created by Joshua Finch on 23/07/2015.
//  Copyright (c) 2015 Joshua Finch. All rights reserved.
//

import UIKit
import XCTest

import ISO8601IntervalRecurrence

class ISO8601IntervalRecurrenceTests: XCTestCase
{
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }

    func testPeriod()
    {
        let period = "PT1S"
        let milliseconds = ISO8601StringParser.parsePeriod(period)

        XCTAssertEqual(milliseconds, 1000, "milliseconds don't match")
    }

    // MARK: -

    func testRecurrenceStartTimeEndTime()
    {
        assertPartsMatchString("R12/19850412T232050/19850625T103000", parts: (reccurence: "R12", startDateTime: "19850412T232050", endDateTime: "19850625T103000", interval: nil))
    }

    func testRecurrencePeriod()
    {
        assertPartsMatchString("R12/P2Y10M15DT10H30M20S", parts: (reccurence: "R12", startDateTime: nil, endDateTime: nil, interval: "P2Y10M15DT10H30M20S"))
    }

    func testRecurrenceStartTimePeriod()
    {
        assertPartsMatchString("R12/19850412T232050/P1Y2M15DT12H30M0S", parts: (reccurence: "R12", startDateTime: "19850412T232050", endDateTime: nil,  interval: "P1Y2M15DT12H30M0S"))
    }

    func testRecurrencePeriodEndTime()
    {
        assertPartsMatchString("R12/P1Y2M15DT12H30M0S/19850412T232050", parts: (reccurence: "R12", startDateTime: nil, endDateTime: "19850412T232050", interval: "P1Y2M15DT12H30M0S"))
    }

    func assertPartsMatchString(string: String, parts: (reccurence: String?, startDateTime: String?, endDateTime: String?, interval: String?))
    {
        let newParts = ISO8601StringParser.parseISO8601StringIntoParts(string)

        if (parts.reccurence != nil)
        {
            XCTAssert(parts.reccurence == newParts.reccurence)
        }
        else
        {
            XCTAssertNil(newParts.reccurence)
        }


        if (parts.startDateTime != nil)
        {
            XCTAssert(parts.startDateTime == newParts.startDateTime)
        }
        else
        {
            XCTAssertNil(newParts.startDateTime)
        }


        if (parts.endDateTime != nil)
        {
            XCTAssert(parts.endDateTime == newParts.endDateTime)
        }
        else
        {
            XCTAssertNil(newParts.endDateTime)
        }

        if (parts.interval != nil)
        {
            XCTAssert(parts.interval == newParts.interval)
        }
        else
        {
            XCTAssertNil(newParts.interval)
        }
    }
}
