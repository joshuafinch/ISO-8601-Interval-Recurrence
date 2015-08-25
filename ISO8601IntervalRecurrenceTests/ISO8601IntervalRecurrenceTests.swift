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

    // MARK: -

    func testPeriod()
    {
        let period = "P3W50DT3S"
        let periodComponents = ISO8601StringParser.parsePeriod(period)

        let dateComponents = NSDateComponents()
        dateComponents.year = 0
        dateComponents.month = 0
        dateComponents.day = 50 + (3 * 7)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 3

        XCTAssertEqual(dateComponents, periodComponents, "Components don't match")
    }

    func testWeekPeriod()
    {
        let period = "P1W"
        let periodComponents = ISO8601StringParser.parsePeriod(period)

        let dateComponents = NSDateComponents()
        dateComponents.year = 0
        dateComponents.month = 0
        dateComponents.day = 7
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        XCTAssertEqual(dateComponents, periodComponents, "Components don't match")
    }

    func testMonthPeriod()
    {
        let period = "P1M"
        let periodComponents = ISO8601StringParser.parsePeriod(period)

        let dateComponents = NSDateComponents()
        dateComponents.year = 0
        dateComponents.month = 1
        dateComponents.day = 0
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        XCTAssertEqual(dateComponents, periodComponents, "Components don't match")
    }

    func testAllPeriodValuesUsed()
    {
        let period = "P2Y2M2W2DT2H2M2S"
        let periodComponents = ISO8601StringParser.parsePeriod(period)

        let dateComponents = NSDateComponents()
        dateComponents.year = 2
        dateComponents.month = 2
        dateComponents.day = 2 + (2 * 7)
        dateComponents.hour = 2
        dateComponents.minute = 2
        dateComponents.second = 2

        XCTAssertEqual(dateComponents, periodComponents, "Components don't match")
    }

    func testSignedPeriodValuesUsed()
    {
        let period = "-P2Y2M2W2DT2H2M2S"
        let periodComponents = ISO8601StringParser.parsePeriod(period)

        let dateComponents = NSDateComponents()
        dateComponents.year = -2
        dateComponents.month = -2
        dateComponents.day = -(2 + (2 * 7))
        dateComponents.hour = -2
        dateComponents.minute = -2
        dateComponents.second = -2

        XCTAssertEqual(dateComponents, periodComponents, "Components don't match")
    }

    // MARK: - 

    func testRecurrenceCount()
    {
        let recurrence = "R12"
        let recurrenceCount = ISO8601StringParser.parseRecurrenceCount(recurrence)
        XCTAssertEqual(recurrenceCount!, 12, "Recurrence count does not match")
    }

    func testInfiniteRecurrenceCount()
    {
        let recurrence = "R"
        let recurrenceCount = ISO8601StringParser.parseRecurrenceCount(recurrence)
        XCTAssertEqual(recurrenceCount!, NSNotFound, "Recurrence count does not match")
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

    func testRecurrencePeriodSigned()
    {
        assertPartsMatchString("R12/-P2Y10M15DT10H30M20S", parts: (reccurence: "R12", startDateTime: nil, endDateTime: nil, interval: "-P2Y10M15DT10H30M20S"))
    }

    func testPeriodWithWeek()
    {
        assertPartsMatchString("R12/P1W", parts: (reccurence: "R12", startDateTime: nil, endDateTime: nil, interval: "P1W"))
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
