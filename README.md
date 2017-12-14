Colour Clock
============

This is a simple clock that tells time by converting the time of day to
a hue, then varying the lightness and saturation over the course of the
hours and minutes

[View it live to see what's up.](https://colourclock.kepstin.ca/)

By default it displays local time, but you can set (nearly) any modern
time zone by appending a fragment identifier, e.g.
[#UTC](https://colourclock.kepstin.ca/#UTC) or
[#Canada/Eastern](https://colourclock.kepstin.ca/#Canada/Eastern).
It should take any modern timezone name from the
[IANA Time Zone Database](http://en.wikipedia.org/wiki/Tz_database).

Calculating the Colour
----------------------

The colour clock uses the [HSLuv](http://www.hsluv.org/) (formerly HUSL) colour space
(revision 3) to calculate the colours used. All calculations are done in
floating point up to the final conversion to sRGB colours for display.

To calculate the colour, start with the current hour (24 hour clock), minute,
and second, and calculate these intermediate values:

- seconds\_since\_midnight = (current\_hour × 60 × 60) + (current\_minute × 60) + current\_second
- seconds\_since\_hour = (current\_minute × 60) + current\_second

Now calculate the colour hue (an angle in degrees).

- hue = seconds\_since\_midnight ÷ 86400 × 360

And the saturation value (radius).
This generates values oscillating between 50 and 100. It is most saturated
on second 0 of the minute, least saturated on second 30.

(Note that most cos functions expect an angle in radians, so that's what's
used here)

- saturation = 75 + cos(current\_second ÷ 60 × 2 × π) × 25

Finally, the lightness value can be calculated.
This varies over the course of the hour; brightest on minute 0 and darkest on
minute 30. The range of values used here is 40 to 60.

(Again, the argument for the cos function is in radians)

- lightness = 50 + cos(seconds\_since\_hour ÷ 3600 × 2 × π) × 10

The hue, saturation, and lightness arguments can then be used as input to
the HUSL library, which can convert to sRGB via e.g. the toHex() function.

Note that I'm also rendering text above the background. The text colour used is
the same hue as the background, but the saturation is calculated differently;
the sign on the cos is inverted and the range is from 75 to 100. The L value
is increased by 20.
