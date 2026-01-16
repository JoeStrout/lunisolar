# The Lunisolar 13-Month Calendar System

## Overview

The Lunisolar calendar system divides the year into 13 months of 28 days each, with one or two additional days appended to the final month. Each month contains exactly 4 weeks, and the first day of every month always falls on the same day of the week (Solday/Monday equivalent).

The name reflects how this calendar is built upon the 28-day lunar cycle as well as the ~365-day solar cycle.  It also echoes the month names (which all end in "luna") as well as the first day of the week (Solday).

## Design Principles

- **Uniformity**: Each month has exactly 28 days (except Tredecoluna)
- **Perpetual alignment**: Dates always fall on the same weekday every year
- **Distinct nomenclature**: New names for both months and weekdays to avoid confusion with the Gregorian calendar
- **Astronomical inspiration**: Weekday names derive from the classical planetary system

## Month Names

The months are named using Latin numeric prefixes combined with "luna" (moon):

1. **Monoluna** (28 days)
2. **Diluna** (28 days)
3. **Triluna** (28 days)
4. **Quadriluna** (28 days)
5. **Quintiluna** (28 days)
6. **Sextiluna** (28 days)
7. **Septiluna** (28 days)
8. **Octoluna** (28 days)
9. **Noviluna** (28 days)
10. **Deciluna** (28 days)
11. **Ondecoluna** (28 days)
12. **Dodecoluna** (28 days)
13. **Tredecoluna** (29 or 30 days)

### Rationale for Month Names

The numeric prefix makes the month order immediately obvious—anyone hearing "Quintiluna 15th" knows it's the 5th month without memorization. The "-luna" suffix provides a poetic connection to the lunar cycle and distinguishes these names from Gregorian months.

For months 11-13, shortened forms (Ondeco-, Dodeco-, Tredeco-) were chosen over the full Latin forms for better euphony and ease of pronunciation.

Month names may be abbreviated to three letters (**Mon**, **Dil**, etc.), and remain unique.

## Weekday Names

The seven days of the week are named after the classical planets (sun, moon, and the five planets visible to the naked eye):

1. **Solday** (Sun)
2. **Moonday** (Moon)
3. **Marsday** (Mars)
4. **Mercuday** (Mercury)
5. **Jupiday** (Jupiter)
6. **Venday** (Venus)
7. **Saturnday** (Saturn)

### Rationale for Weekday Names

These names follow the ancient Greco-Roman system that underlies both Western weekdays (Sunday, Monday, etc.) and the Japanese weekday system (which uses the Five Elements to represent the same planets). This approach:

- Maintains historical continuity with existing calendar traditions
- Creates clear astronomical associations
- Avoids confusion with standard English weekdays
- Provides a romantic, memorable character to each day

### Standard Abbreviations

When space is limited, weekdays can be abbreviated as:
- **Sol** (Solday)
- **Moo** (Moonday)
- **Mar** (Marsday)
- **Mer** (Mercuday)
- **Jup** (Jupiday)
- **Ven** (Venday)
- **Sat** (Saturnday)

If space is _really_ limited, use just the first two letters (**So**, **Mo**, **Ma**, etc.).  These abbreviations are still unique.

We also endorse the classic astronomical symbols that have been used for centuries: Solday ☉, ☽, ♂, ☿, ♃, ♀, ♄.  These are Unicode characters and should be visible on most modern systems.  But they are not familiar to most modern English speakers, so the words/abbreviations above are probably better in most contexts.

## Calendar Structure

### Regular Months (Monoluna through Dodecoluna)

Each of the first 12 months contains exactly 28 days arranged in 4 complete weeks:

Sol|Moo|Mar|Mer|Jup|Ven|Sat
--|--|--|--|--|--|--
|1|2|3|4|5|6|7
|8|9|10|11|12|13|14
15|16|17|18|19|20|21
22|23|24|25|26|27|28


The 1st of every month always falls on Solday, the 8th on Solday, the 15th on Solday, and the 22nd on Solday. This pattern repeats identically in every month throughout the year.

### Final Month (Tredecoluna)

Tredecoluna contains 29 days in common years and 30 days in leap years:

**Common years:**
- Days 1-28: Four complete weeks (Solday through Saturnday)
- Day 29: **Extraday** (the 365th day of the year)

**Leap years:**
- Days 1-28: Four complete weeks (Solday through Saturnday)
- Day 29: **Extraday** (the 365th day of the year)
- Day 30: **Extraday** (the 366th day of the year, leap day)

For a leap year, the Tredecoluna calendar would look like this:

Sol|Moo|Mar|Mer|Jup|Ven|Sat|Ext|Ext
--|--|--|--|--|--|--|--|--
|1|2|3|4|5|6|7| |
|8|9|10|11|12|13|14| |
15|16|17|18|19|20|21| |
22|23|24|25|26|27|28|29|30


### The Extra Days

The additional day(s) at the end of Tredecoluna serve as extended New Year holidays. Both are designated as **Extraday** rather than being assigned to the regular weekly cycle. These days:

- Are technically part of Tredecoluna (the 29th and 30th days of that month)
- Do not belong to the standard seven-day week cycle
- Serve as year-end holidays bridging the old year and the new

## Perpetual Calendar Property

Because each month has exactly 28 days (4 complete weeks), and the first 12 months total exactly 364 days (52 complete weeks), the calendar exhibits perfect perpetual properties:

- The 1st of every month is always Solday
- The 2nd of every month is always Moonday
- The 20th of every month is always Venday
- Any given date always falls on the same weekday, every year

This perpetual alignment is maintained by placing the extra day(s) outside the normal weekly cycle as "Extraday."

### Misalignment with Gregorian calendar

Because 365 is not evenly divisible by 7, we cannot maintain both:
1. A fixed internal calendar (same dates = same weekdays every year)
2. Continuous alignment with the Gregorian seven-day week cycle

By placing the Extraday(s) outside the weekly cycle, this calendar "breaks" the continuous week count once per year. As a result:

- This calendar's Solday will drift relative to the Gregorian Sunday
- The drift is 1 day per common year, 2 days per leap year
- Users of this calendar must explicitly convert when coordinating with Gregorian calendar users

In addition, because the Gregorian calendar places the extra leap-year day at the end of February, the mapping from Gregorian dates to the new calendar will be different (for all dates after Feb. 28th/Triluna 3rd) by one day.

## Date Notation

Dates in this system can be written as:

**Full format:**
`Solday, 15 Quintiluna, 2026`

**Abbreviated format:**
`Sol 15 Qui 2026` or `15 Qui 2026`

**Numeric format:**
`2026|05|15` (following ISO 8601 order: year-month-day, but with `|` as a separator to avoid confusion with Gregorian dates)

## Quarters

The year can be divided into four 13-week quarters, starting on these dates:

- Q1: Solday, 1 Monoluna
- Q2: Solday, 8 Quadriluna
- Q3: Solday, 15 Septiluna (aka Midyear Day)
- Q4: Solday, 22 Deciluna

Each quarter is 91 days (plus the one or two extra days at the end of the year, typically taken as holidays).

## Other Notable Dates

- Moonday, 23 Triluna: Spring Equinox (observed)
- Mercuday, 4 Septiluna: Midsummer (summer solstice observed)
- Venday, 13 Deciluna: Fall Equinox (observed)
- Venday, 20 Tredecoluna: Midwinter (winter solstice observed)

Note that the exact astronomical solstice/equinox is not always on the above dates, but is close to it.

## Historical Context

This calendar draws inspiration from several historical proposals:

- **International Fixed Calendar (1902)**: Moses Cotsworth's proposal for 13 months of 28 days
- **Positivist Calendar (1849)**: Auguste Comte's similar system with different month names
- **Liberty Calendar (1920s)**: American proposal with 13 equal months

Like these predecessors, this system prioritizes regularity and predictability over tradition. However, it distinguishes itself through:

1. Systematic Latin-based month naming (avoiding reuse of Gregorian names)
2. Planetary weekday names (creating clear distinction from standard weekdays)
3. Simplified handling of extra days (appending to final month rather than placing between months)

## Advantages

1. **Perfect perpetuity**: Every date always falls on the same weekday
2. **Simplified planning**: Every month has identical structure
3. **Easy mental arithmetic**: Always 4 weeks per month, 13 months per year
4. **Mnemonic month names**: Numeric prefixes make month order self-evident
