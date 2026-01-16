#!/usr/bin/env python3
"""Convert between Gregorian and Lunisolar calendar dates."""

import datetime
import readline

# Lunisolar month names and abbreviations
MONTH_NAMES = [
    "Monoluna", "Diluna", "Triluna", "Quadriluna", "Quintiluna", "Sextiluna",
    "Septiluna", "Octoluna", "Noviluna", "Deciluna", "Ondecoluna", "Dodecoluna",
    "Tredecoluna"
]
MONTH_ABBREVS = ["Mon", "Dil", "Tri", "Qua", "Qui", "Sex", "Sep", "Oct", "Nov", "Dec", "Ond", "Dod", "Tre"]

# Lunisolar weekday names (Solday = first day of week)
WEEKDAY_NAMES = ["Solday", "Moonday", "Marsday", "Mercuday", "Jupiday", "Venday", "Saturnday"]


def is_leap_year(year):
    """Check if a year is a leap year (same rules as Gregorian)."""
    return year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)


def gregorian_to_day_of_year(year, month, day):
    """Convert Gregorian date to day of year (1-indexed)."""
    return datetime.date(year, month, day).timetuple().tm_yday


def day_of_year_to_gregorian(year, day_of_year):
    """Convert day of year to Gregorian date."""
    date = datetime.date(year, 1, 1) + datetime.timedelta(days=day_of_year - 1)
    return date.year, date.month, date.day


def day_of_year_to_lunisolar(day_of_year):
    """Convert day of year to Lunisolar month and day."""
    if day_of_year <= 336:  # First 12 months (12 × 28 = 336)
        month = (day_of_year - 1) // 28 + 1
        day = (day_of_year - 1) % 28 + 1
    else:  # Month 13 (Tredecoluna)
        month = 13
        day = day_of_year - 336
    return month, day


def lunisolar_to_day_of_year(month, day):
    """Convert Lunisolar month and day to day of year."""
    return (month - 1) * 28 + day


def lunisolar_weekday(day):
    """Get the Lunisolar weekday for a day of month.

    Days 1-28: regular weekdays (day 1 = Solday)
    Days 29-30: Extraday (outside normal week cycle)
    """
    if day > 28:
        return "Extraday"
    return WEEKDAY_NAMES[(day - 1) % 7]


def format_gregorian_full(year, month, day):
    """Format Gregorian date in full form with weekday."""
    date = datetime.date(year, month, day)
    return date.strftime("%A, %d %B %Y")


def format_gregorian_numeric(year, month, day):
    """Format Gregorian date in numeric form (YYYY-MM-DD)."""
    return f"{year:04d}-{month:02d}-{day:02d}"


def format_lunisolar_full(year, month, day):
    """Format Lunisolar date in full form with weekday."""
    weekday = lunisolar_weekday(day)
    month_name = MONTH_NAMES[month - 1]
    return f"{weekday}, {day} {month_name} {year}"


def format_lunisolar_numeric(year, month, day):
    """Format Lunisolar date in numeric form (YYYY|MM|DD)."""
    return f"{year:04d}|{month:02d}|{day:02d}"


def parse_input(date_str):
    """Parse user input and determine calendar type.

    Returns: (calendar_type, year, month_or_doy, day_or_none)
    - 'gregorian': year, month, day
    - 'lunisolar': year, month, day
    - 'julian': year, day_of_year, None
    """
    date_str = date_str.strip()

    if '|' in date_str:
        # Lunisolar format: YYYY|MM|DD
        parts = date_str.split('|')
        if len(parts) != 3:
            raise ValueError("Invalid Lunisolar date format. Use YYYY|MM|DD")
        year, month, day = int(parts[0]), int(parts[1]), int(parts[2])
        return 'lunisolar', year, month, day
    elif '-' in date_str:
        parts = date_str.split('-')
        if len(parts) == 3:
            # Gregorian format: YYYY-MM-DD
            year, month, day = int(parts[0]), int(parts[1]), int(parts[2])
            return 'gregorian', year, month, day
        elif len(parts) == 2:
            # Julian day format: YYYY-DDD
            year, day_of_year = int(parts[0]), int(parts[1])
            return 'julian', year, day_of_year, None
        else:
            raise ValueError("Invalid date format. Use YYYY-MM-DD or YYYY-DDD")
    else:
        raise ValueError("Unknown date format. Use YYYY-MM-DD (Gregorian), YYYY|MM|DD (Lunisolar), or YYYY-DDD (Julian day)")


def validate_lunisolar_date(year, month, day):
    """Validate a Lunisolar date."""
    if month < 1 or month > 13:
        raise ValueError(f"Invalid Lunisolar month: {month}. Must be 1-13.")

    if month <= 12:
        max_day = 28
    else:  # Tredecoluna
        max_day = 30 if is_leap_year(year) else 29

    if day < 1 or day > max_day:
        raise ValueError(f"Invalid day {day} for {MONTH_NAMES[month-1]}. Must be 1-{max_day}.")


def validate_gregorian_date(year, month, day):
    """Validate a Gregorian date."""
    try:
        datetime.date(year, month, day)
    except ValueError as e:
        raise ValueError(f"Invalid Gregorian date: {e}")


def validate_julian_day(year, day_of_year):
    """Validate a Julian day (day of year)."""
    max_day = 366 if is_leap_year(year) else 365
    if day_of_year < 1 or day_of_year > max_day:
        raise ValueError(f"Invalid day of year: {day_of_year}. Must be 1-{max_day} for year {year}.")


def convert_and_display(date_str):
    """Parse input, convert between calendars, and display both dates."""
    result = parse_input(date_str)
    calendar_type = result[0]
    year = result[1]

    if calendar_type == 'gregorian':
        month, day = result[2], result[3]
        validate_gregorian_date(year, month, day)
        g_year, g_month, g_day = year, month, day

        # Convert to Lunisolar
        day_of_year = gregorian_to_day_of_year(year, month, day)
        l_month, l_day = day_of_year_to_lunisolar(day_of_year)
        l_year = year

    elif calendar_type == 'lunisolar':
        month, day = result[2], result[3]
        validate_lunisolar_date(year, month, day)
        l_year, l_month, l_day = year, month, day

        # Convert to Gregorian
        day_of_year = lunisolar_to_day_of_year(month, day)
        g_year, g_month, g_day = day_of_year_to_gregorian(year, day_of_year)

    else:  # julian
        day_of_year = result[2]
        validate_julian_day(year, day_of_year)

        # Convert to both calendars
        g_year, g_month, g_day = day_of_year_to_gregorian(year, day_of_year)
        l_year = year
        l_month, l_day = day_of_year_to_lunisolar(day_of_year)

    # Print results
    print()
    print(f"Day of year: {day_of_year}")
    print()
    print("Gregorian:")
    print(f"  {format_gregorian_numeric(g_year, g_month, g_day)}")
    print(f"  {format_gregorian_full(g_year, g_month, g_day)}")
    print()
    print("Lunisolar:")
    print(f"  {format_lunisolar_numeric(l_year, l_month, l_day)}")
    print(f"  {format_lunisolar_full(l_year, l_month, l_day)}")
    print()


def main():
    print("=" * 50)
    print("  Gregorian ↔ Lunisolar Date Converter")
    print("=" * 50)
    print()
    print("Enter a date in one of these formats:")
    print("  YYYY-MM-DD  (Gregorian)")
    print("  YYYY|MM|DD  (Lunisolar)")
    print("  YYYY-DDD    (Year and day of year)")
    print()
    print("Press Ctrl+C to exit")
    print()

    while True:
        print("-"*80)
        try:
            date_str = input("Enter date: ")
            if date_str.strip():
                convert_and_display(date_str)
        except ValueError as e:
            print(f"Error: {e}\n")
        except (KeyboardInterrupt, EOFError):
            print("\nGoodbye!")
            break


if __name__ == "__main__":
    main()
