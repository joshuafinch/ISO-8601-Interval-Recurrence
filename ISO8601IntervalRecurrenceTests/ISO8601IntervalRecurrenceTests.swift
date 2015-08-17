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
        let period = "P3DT3S"
        let seconds = ISO8601StringParser.parsePeriod(period)

        let mySeconds: Float = (24*60*60*3)+3
        XCTAssertEqual(seconds, mySeconds, "seconds don't match")
    }

    func testWeekPeriod()
    {
        let period = "P1W"
        let seconds = ISO8601StringParser.parsePeriod(period)

        let mySeconds: Float = (24*60*60*7)
        XCTAssertEqual(seconds, mySeconds, "seconds don't match")
    }

    func testAllPeriodValuesUsed()
    {
        let aPeriod = "P2Y2M2W2DT2H2M2S"
        let aSeconds = ISO8601StringParser.parsePeriod(aPeriod)

        let seconds: Float = 2
        let minutes: Float = 2
        let hours: Float = 2
        let days: Float = 2
        let weeks: Float = 2
        let months: Float = 2
        let years: Float = 2

        let secondsInSec = seconds
        let minuteInSec = minutes * 60
        let hourInSec = hours * 60 * 60

        let mhsInSec = secondsInSec + minuteInSec + hourInSec

        let yearsInMonths = years * 12
        let yearsAndMonthsInYears = (yearsInMonths + months) / 12.0
        let yearsAndMonthsInDays = (yearsAndMonthsInYears * 14097.0) / 400.0

        let weeksInDays = weeks * 7
        let yearsAndMonthsAndWeeksAndDaysInDays = yearsAndMonthsInDays + weeksInDays + days

        let mySeconds: Float = (yearsAndMonthsAndWeeksAndDaysInDays * 24 * 60 * 60) + mhsInSec

        XCTAssertEqual(aSeconds, mySeconds, "seconds don't match")
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
