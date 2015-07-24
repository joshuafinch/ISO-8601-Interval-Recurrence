//
//  ISO8601StringParser.swift
//  ISO8601IntervalRecurrence
//
//  Created by Joshua Finch on 23/07/2015.
//  Copyright (c) 2015 Joshua Finch. All rights reserved.
//

import Foundation

public class ISO8601StringParser
{
    public static func parseISO8601StringIntoParts(iso8601string: String) -> (reccurence: String?, startDateTime: String?, endDateTime: String?, interval: String?)
    {
        var recurrence: String?
        var interval: String?
        var startDateTime: String?
        var endDateTime: String?

        let parts: [String] = iso8601string.componentsSeparatedByString("/")

        for (index, part) in enumerate(parts)
        {
            let scanner = NSScanner(string: part)

            if (scanner.scanString("R", intoString: nil))
            {
                // Part begins with R
                recurrence = part
            }
            else if (scanner.scanString("P", intoString: nil))
            {
                // Part begins with P
                interval = part
            }
            else
            {
                // Part does not begin with R or P, most likely a datetime

                if (interval == nil && startDateTime == nil)
                {
                    startDateTime = part
                }
                else
                {
                    if (endDateTime == nil)
                    {
                        // Must be the end time
                        endDateTime = part
                    }
                    else
                    {
                        println("Weird stuff happening, two end times?")
                    }
                }
            }
        }
        
        return (recurrence, startDateTime, endDateTime, interval)
    }

    // MARK: - 

    // MARK: - Parse Parts

    private static func parseRecurrenceAmount(recurrence: String) -> Int?
    {
        let scanner = NSScanner(string: recurrence)
        if (scanner.scanString("R", intoString: nil))
        {
            var recurrenceAmount: Int = NSNotFound
            if (scanner.scanInteger(&recurrenceAmount))
            {
                return recurrenceAmount
            }
        }

        return nil
    }

    public static func parsePeriod(period: String) -> Float
    {
        var years: Float = 0
        var months: Float = 0
        var days: Float = 0
        var hours: Float = 0
        var minutes: Float = 0
        var seconds: Float = 0
        var weeks: Float = 0

        func nextDateValue(scanner: NSScanner)
        {
            var periodValue: Float = 0
            if (scanner.scanFloat(&periodValue))
            {
                if (scanner.scanString("Y", intoString: nil))
                {
                    years = periodValue
                }
                else if (scanner.scanString("M", intoString: nil))
                {
                    months = periodValue
                }
                else if (scanner.scanString("D", intoString: nil))
                {
                    days = periodValue
                }
            }
        }

        func nextTimeValue(scanner: NSScanner) -> Bool
        {
            var periodValue: Float = 0
            if (scanner.scanFloat(&periodValue))
            {
                if (scanner.scanString("H", intoString: nil))
                {
                    hours = periodValue
                }
                else if (scanner.scanString("M", intoString: nil))
                {
                    minutes = periodValue
                }
                else if (scanner.scanString("S", intoString: nil))
                {
                    seconds = periodValue
                }
                else if (scanner.scanString("W", intoString: nil))
                {
                    weeks = periodValue
                }
            }
            else
            {
                println("Couldn't scan a float in: \(scanner.string)")
                return false
            }

            return true
        }

        let scanner = NSScanner(string: period)
        if (scanner.scanString("P", intoString: nil))
        {
            var dateString: NSString? = ""
            scanner.scanUpToString("T", intoString: &dateString)
            scanner.scanString("T", intoString: nil)

            let length = (scanner.string as NSString).length
            let range = NSRange(location: scanner.scanLocation, length: length - scanner.scanLocation)
            let timeString = (scanner.string as NSString).substringWithRange(range) as String

            if (dateString?.length > 0)
            {
                let dateScanner = NSScanner(string: dateString! as String)
                while (!dateScanner.atEnd)
                {
                    println("stuck on dateScanner?")
                    nextDateValue(dateScanner)
                }
            }

            if ((timeString as NSString).length > 0)
            {
                let timeScanner = NSScanner(string: timeString)
                while(!timeScanner.atEnd)
                {
                    let hasNextTimeValue = nextTimeValue(timeScanner)
                    if (!hasNextTimeValue)
                    {
                        println("no more time values? \(timeScanner.scanLocation), \((timeScanner.string as NSString).length)")
                    }
                }
            }
        }

        let secondsInSec = seconds
        let minuteInSec = minutes * 60
        let hourInSec = hours * 60 * 60

        let mhsInSec = secondsInSec + minuteInSec + hourInSec

        let yearsInMonths = years * 12
        let yearsAndMonthsInYears = (yearsInMonths + months) / 12.0
        let yearsAndMonthsInDays = (yearsAndMonthsInYears * 14097.0) / 400.0

        let weeksInDays = weeks * 7
        let yearsAndMonthsAndWeeksAndDaysInDays = yearsAndMonthsInDays + weeksInDays + days

        return (yearsAndMonthsAndWeeksAndDaysInDays * 24 * 60 * 60) + mhsInSec
    }

    private static func parseDateTime(datetime: String) -> NSDateComponents?
    {
        //TODO: Check this is a dateTime string, not a P string or R string or something else

        var components = NSDateComponents()

        //TODO: Extract date and time components

        return components
    }
}