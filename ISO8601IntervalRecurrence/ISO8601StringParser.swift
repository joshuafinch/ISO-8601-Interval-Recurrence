//
//  ISO8601StringParser.swift
//  ISO8601IntervalRecurrence
//
//  Created by Joshua Finch on 23/07/2015.
//  Copyright (c) 2015 Joshua Finch. All rights reserved.
//

import Foundation

open class ISO8601StringParser
{
    open static func parseISO8601StringIntoParts(_ iso8601string: String) -> (reccurence: String?, startDateTime: String?, endDateTime: String?, interval: String?)
    {
        var recurrence: String?
        var interval: String?
        var startDateTime: String?
        var endDateTime: String?

        let parts: [String] = iso8601string.components(separatedBy: "/")

        for part in parts
        {
            let scanner = Scanner(string: part)

            if (scanner.scanString("R", into: nil))
            {
                // Part begins with R
                recurrence = part
            }
            else if (scanner.scanString("P", into: nil) || scanner.scanString("-P", into: nil))
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
                        print("Weird stuff happening, two end times?")
                    }
                }
            }
        }
        
        return (recurrence, startDateTime, endDateTime, interval)
    }

    // MARK: - 

    // MARK: - Parse Parts

    open static func parseRecurrenceCount(_ recurrence: String) -> Int?
    {
        let scanner = Scanner(string: recurrence)
        if (scanner.scanString("R", into: nil))
        {
            var recurrenceCount: Int = NSNotFound
            if (scanner.scanInt(&recurrenceCount))
            {
                return recurrenceCount
            }
            else
            {
                return NSNotFound
            }
        }

        return nil
    }

    open static func parsePeriod(_ period: String) -> DateComponents
    {
        var years: Int = 0
        var months: Int = 0
        var days: Int = 0
        var hours: Int = 0
        var minutes: Int = 0
        var seconds: Int = 0
        var weeks: Int = 0

        func nextDateValue(_ scanner: Scanner) -> Bool
        {
            var periodValue: Int = 0
            if (scanner.scanInt(&periodValue))
            {
                if (scanner.scanString("W", into: nil))
                {
                    weeks = periodValue
                    return true
                }
                else if (scanner.scanString("Y", into: nil))
                {
                    years = periodValue
                    return true
                }
                else if (scanner.scanString("M", into: nil))
                {
                    months = periodValue
                    return true
                }
                else if (scanner.scanString("D", into: nil))
                {
                    days = periodValue
                    return true
                }
            }

            return false
        }

        func nextTimeValue(_ scanner: Scanner) -> Bool
        {
            var periodValue: Int = 0
            if (scanner.scanInt(&periodValue))
            {
                if (scanner.scanString("H", into: nil))
                {
                    hours = periodValue
                    return true
                }
                else if (scanner.scanString("M", into: nil))
                {
                    minutes = periodValue
                    return true
                }
                else if (scanner.scanString("S", into: nil))
                {
                    seconds = periodValue
                    return true
                }
            }

            return false
        }

        let scanner = Scanner(string: period)

        let sign = (scanner.scanString("-", into: nil)) ? -1 : 1

        if (scanner.scanString("P", into: nil))
        {
            var dateString: NSString? = ""
            scanner.scanUpTo("T", into: &dateString)
            scanner.scanString("T", into: nil)

            let length = (scanner.string as NSString).length
            let range = NSRange(location: scanner.scanLocation, length: length - scanner.scanLocation)
            let timeString = (scanner.string as NSString).substring(with: range) as String

            if let dateString = dateString {
                if dateString.length > 0 {
                    let dateScanner = Scanner(string: dateString as String)
                    while (!dateScanner.isAtEnd)
                    {
                        if (!nextDateValue(dateScanner))
                        {
                            print("no more date values? \(dateScanner.scanLocation), \((dateScanner.string as NSString).length)")
                            break
                        }
                    }
                }
            }

            if ((timeString as NSString).length > 0)
            {
                let timeScanner = Scanner(string: timeString)
                while(!timeScanner.isAtEnd)
                {
                    if (!nextTimeValue(timeScanner))
                    {
                        print("no more time values? \(timeScanner.scanLocation), \((timeScanner.string as NSString).length)")
                        break
                    }
                }
            }
        }

        var dateComponents: DateComponents = DateComponents()
        dateComponents.year = years * sign
        dateComponents.month = months * sign
        dateComponents.day = (days + (weeks * 7)) * sign
        dateComponents.hour = hours * sign
        dateComponents.minute = minutes * sign
        dateComponents.second = seconds * sign
        return dateComponents
    }
}
