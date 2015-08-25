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
            else if (scanner.scanString("P", intoString: nil) || scanner.scanString("-P", intoString: nil))
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

    public static func parseRecurrenceCount(recurrence: String) -> Int?
    {
        let scanner = NSScanner(string: recurrence)
        if (scanner.scanString("R", intoString: nil))
        {
            var recurrenceCount: Int = NSNotFound
            if (scanner.scanInteger(&recurrenceCount))
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

    public static func parsePeriod(period: String) -> NSDateComponents
    {
        var years: Int = 0
        var months: Int = 0
        var days: Int = 0
        var hours: Int = 0
        var minutes: Int = 0
        var seconds: Int = 0
        var weeks: Int = 0

        func nextDateValue(scanner: NSScanner) -> Bool
        {
            var periodValue: Int = 0
            if (scanner.scanInteger(&periodValue))
            {
                if (scanner.scanString("W", intoString: nil))
                {
                    weeks = periodValue
                    return true
                }
                else if (scanner.scanString("Y", intoString: nil))
                {
                    years = periodValue
                    return true
                }
                else if (scanner.scanString("M", intoString: nil))
                {
                    months = periodValue
                    return true
                }
                else if (scanner.scanString("D", intoString: nil))
                {
                    days = periodValue
                    return true
                }
            }

            return false
        }

        func nextTimeValue(scanner: NSScanner) -> Bool
        {
            var periodValue: Int = 0
            if (scanner.scanInteger(&periodValue))
            {
                if (scanner.scanString("H", intoString: nil))
                {
                    hours = periodValue
                    return true
                }
                else if (scanner.scanString("M", intoString: nil))
                {
                    minutes = periodValue
                    return true
                }
                else if (scanner.scanString("S", intoString: nil))
                {
                    seconds = periodValue
                    return true
                }
            }

            return false
        }

        let scanner = NSScanner(string: period)

        let sign = (scanner.scanString("-", intoString: nil)) ? -1 : 1

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
                    if (!nextDateValue(dateScanner))
                    {
                        println("no more date values? \(dateScanner.scanLocation), \((dateScanner.string as NSString).length)")
                        break
                    }
                }
            }

            if ((timeString as NSString).length > 0)
            {
                let timeScanner = NSScanner(string: timeString)
                while(!timeScanner.atEnd)
                {
                    if (!nextTimeValue(timeScanner))
                    {
                        println("no more time values? \(timeScanner.scanLocation), \((timeScanner.string as NSString).length)")
                        break
                    }
                }
            }
        }

        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.year = years * sign
        dateComponents.month = months * sign
        dateComponents.day = (days + (weeks * 7)) * sign
        dateComponents.hour = hours * sign
        dateComponents.minute = minutes * sign
        dateComponents.second = seconds * sign
        return dateComponents
    }
}