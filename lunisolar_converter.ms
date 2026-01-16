// Lunisolar Calendar Converter
// Convert between Gregorian, Lunisolar, and day-of-year formats

import "dateTime"
import "stringUtil"

// Lunisolar month names
monthNames = ["Monoluna", "Diluna", "Triluna", "Quadriluna", "Quintiluna",
              "Sextiluna", "Septiluna", "Octoluna", "Noviluna", "Deciluna",
              "Ondecoluna", "Dodecoluna", "Tredecoluna"]

// Lunisolar weekday names (Solday = first day of week)
weekdayNames = ["Solday", "Moonday", "Marsday", "Mercuday", "Jupiday", "Venday", "Saturnday"]

// Gregorian weekday names (Sunday first, to match dateTime.weekday)
gregorianWeekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

// Gregorian month names
gregorianMonths = ["January", "February", "March", "April", "May", "June",
                   "July", "August", "September", "October", "November", "December"]

// Check if a year is a leap year
isLeapYear = function(year)
	return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)
end function

// Get day of year from Gregorian date (1-indexed)
gregorianToDayOfYear = function(year, month, day)
	// Build date string and get its value
	dateStr = year + "-" + ("0" + month)[-2:] + "-" + ("0" + day)[-2:]
	dateVal = dateTime.val(dateStr)
	// Get Jan 1 of same year
	jan1Str = year + "-01-01"
	jan1Val = dateTime.val(jan1Str)
	// Difference in days, plus 1 (since Jan 1 is day 1)
	return floor((dateVal - jan1Val) / (24 * 60 * 60)) + 1
end function

// Convert day of year to Gregorian month and day
dayOfYearToGregorian = function(year, dayOfYear)
	// Start from Jan 1 and add days
	jan1Str = year + "-01-01"
	jan1Val = dateTime.val(jan1Str)
	targetVal = jan1Val + (dayOfYear - 1) * 24 * 60 * 60
	result = {}
	result.year = dateTime.year(targetVal)
	result.month = dateTime.month(targetVal)
	result.day = dateTime.day(targetVal)
	return result
end function

// Convert day of year to Lunisolar month and day
dayOfYearToLunisolar = function(dayOfYear)
	result = {}
	if dayOfYear <= 336 then  // First 12 months (12 * 28 = 336)
		result.month = floor((dayOfYear - 1) / 28) + 1
		result.day = (dayOfYear - 1) % 28 + 1
	else  // Month 13 (Tredecoluna)
		result.month = 13
		result.day = dayOfYear - 336
	end if
	return result
end function

// Convert Lunisolar month and day to day of year
lunisolarToDayOfYear = function(month, day)
	return (month - 1) * 28 + day
end function

// Get Lunisolar weekday name for a day of month
lunisolarWeekday = function(day)
	if day > 28 then return "Extraday"
	return weekdayNames[(day - 1) % 7]
end function

// Get Gregorian weekday name
gregorianWeekday = function(year, month, day)
	dateStr = year + "-" + ("0" + month)[-2:] + "-" + ("0" + day)[-2:]
	idx = dateTime.weekday(dateStr)
	return gregorianWeekdays[idx]
end function

// Format number with leading zeros
pad2 = function(n)
	return ("0" + n)[-2:]
end function

// Parse user input and determine format
// Returns a map with: type, year, and either month/day or dayOfYear
parseInput = function(input)
	input = input.trim
	result = {}

	if input.indexOf("|") != null then
		// Lunisolar format: YYYY|MM|DD
		parts = input.split("|")
		if parts.len != 3 then
			result.error = "Invalid Lunisolar format. Use YYYY|MM|DD"
			return result
		end if
		result.type = "lunisolar"
		result.year = parts[0].val
		result.month = parts[1].val
		result.day = parts[2].val
	else if input.indexOf("-") != null then
		parts = input.split("-")
		if parts.len == 3 then
			// Gregorian format: YYYY-MM-DD
			result.type = "gregorian"
			result.year = parts[0].val
			result.month = parts[1].val
			result.day = parts[2].val
		else if parts.len == 2 then
			// Julian day format: YYYY-DDD
			result.type = "julian"
			result.year = parts[0].val
			result.dayOfYear = parts[1].val
		else
			result.error = "Invalid date format. Use YYYY-MM-DD or YYYY-DDD"
		end if
	else
		result.error = "Unknown format. Use YYYY-MM-DD, YYYY|MM|DD, or YYYY-DDD"
	end if

	return result
end function

// Validate Lunisolar date
validateLunisolar = function(year, month, day)
	if month < 1 or month > 13 then
		return "Invalid Lunisolar month: " + month + ". Must be 1-13."
	end if
	if month <= 12 then
		maxDay = 28
	else  // Tredecoluna
		if isLeapYear(year) then maxDay = 30 else maxDay = 29
	end if
	if day < 1 or day > maxDay then
		return "Invalid day " + day + " for " + monthNames[month-1] + ". Must be 1-" + maxDay + "."
	end if
	return null  // No error
end function

// Validate Gregorian date (basic check)
validateGregorian = function(year, month, day)
	if month < 1 or month > 12 then
		return "Invalid month: " + month + ". Must be 1-12."
	end if
	daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	maxDay = daysInMonth[month - 1]
	if month == 2 and isLeapYear(year) then maxDay = 29
	if day < 1 or day > maxDay then
		return "Invalid day " + day + " for " + gregorianMonths[month-1] + ". Must be 1-" + maxDay + "."
	end if
	return null
end function

// Validate Julian day (day of year)
validateJulian = function(year, dayOfYear)
	if isLeapYear(year) then maxDay = 366 else maxDay = 365
	if dayOfYear < 1 or dayOfYear > maxDay then
		return "Invalid day of year: " + dayOfYear + ". Must be 1-" + maxDay + " for year " + year + "."
	end if
	return null
end function

// Main conversion and display function
convertAndDisplay = function(input)
	parsed = parseInput(input)

	if parsed.hasIndex("error") then
		print "Error: " + parsed.error
		return
	end if

	year = parsed.year

	if parsed.type == "gregorian" then
		err = validateGregorian(year, parsed.month, parsed.day)
		if err then
			print "Error: " + err
			return
		end if
		gYear = year
		gMonth = parsed.month
		gDay = parsed.day
		dayOfYear = gregorianToDayOfYear(year, parsed.month, parsed.day)
		luni = dayOfYearToLunisolar(dayOfYear)
		lYear = year
		lMonth = luni.month
		lDay = luni.day

	else if parsed.type == "lunisolar" then
		err = validateLunisolar(year, parsed.month, parsed.day)
		if err then
			print "Error: " + err
			return
		end if
		lYear = year
		lMonth = parsed.month
		lDay = parsed.day
		dayOfYear = lunisolarToDayOfYear(parsed.month, parsed.day)
		greg = dayOfYearToGregorian(year, dayOfYear)
		gYear = greg.year
		gMonth = greg.month
		gDay = greg.day

	else  // julian
		err = validateJulian(year, parsed.dayOfYear)
		if err then
			print "Error: " + err
			return
		end if
		dayOfYear = parsed.dayOfYear
		greg = dayOfYearToGregorian(year, dayOfYear)
		gYear = greg.year
		gMonth = greg.month
		gDay = greg.day
		lYear = year
		luni = dayOfYearToLunisolar(dayOfYear)
		lMonth = luni.month
		lDay = luni.day
	end if

	// Print results
	print
	print "Day of year: " + dayOfYear
	print
	print "Gregorian:"
	print "  " + gYear + "-" + pad2(gMonth) + "-" + pad2(gDay)
	gWeekday = gregorianWeekday(gYear, gMonth, gDay)
	print "  " + gWeekday + ", " + gDay + " " + gregorianMonths[gMonth-1] + " " + gYear
	print
	print "Lunisolar:"
	print "  " + lYear + "|" + pad2(lMonth) + "|" + pad2(lDay)
	lWeekday = lunisolarWeekday(lDay)
	print "  " + lWeekday + ", " + lDay + " " + monthNames[lMonth-1] + " " + lYear
	print
end function

// Main program
main = function
	print "=" * 50
	print "  Gregorian <-> Lunisolar Date Converter"
	print "=" * 50
	print
	print "Enter a date in one of these formats:"
	print "  YYYY-MM-DD  (Gregorian)"
	print "  YYYY|MM|DD  (Lunisolar)"
	print "  YYYY-DDD    (Year and day of year)"
	print
	print "Type 'quit' to exit"
	print

	while true
		print "-" * 80
		userInput = input("Enter date: ")
		if userInput == null or userInput.lower == "quit" then
			print "Goodbye!"
			break
		end if
		if userInput.trim then convertAndDisplay userInput
	end while
end function

main
