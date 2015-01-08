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

Note that all of the colour calculations are done in the CIELAB
(aka L\*a\*b\*) colour space with D65 illuminant. All calculations are
done in floating point up until the final display output, when the colours
are rounded (and clipped) if necessary.

To calculate the colour, start with the current hour (24 hour clock), minute,
and second, and calculate these intermediate values:

- seconds\_since\_midnight = (current\_hour × 60 × 60) + (current\_minute × 60) + current\_second
- seconds\_since\_hour = (current\_minute × 60) + current\_second

Now calculate the position on the colour wheel (note that angles are in
radians).

- angle = seconds\_since\_midnight ÷ 86400 × 2 × π

And the saturation value (radius).
This generates values oscillating  between 30 and 50. It is most saturated
on second 0 of the minute, least saturated on second 30.

- radius = 40 + cos(current\_second ÷ 60 × 2 × π) × 10

From the angle and radius, the a\* and b\* values can be calculated.
Note that the hue angle is being rotated by 45° (¼π), and that a negative
sign on the sin operator is used. This causes the zero position to be red,
and the colours cycle through yellow then green in the morning, blue at
noon, purple and magenta in the afternoon/evening, before returning to red.

- a = -sin(hue - (π ÷ 4)) × radius
- b = cos(hue - (π ÷ 4)) × radius

Finally, the L\* value can be calculated. This varies over the course of
the hour; brightest on minute 0 and darkest on minute 30. The range of values
used here is 40 to 80.

- L = 60 + cos(seconds\_since\_hour ÷ 3600 × 2 × π) × 20

Now you have the L, a, and b values for the colour coordinates. You can
convert these back to sRGB colour space for display by first converting the
L\*a\*b\* to XYZ with the D65 illuminant, then converting the XYZ values to
sRGB. See the colour library I'm using in [lib/colors.js](lib/colors.js) for details.

Note that I'm also rendering text above the background. The text colour used is
the same hue as the background, but the saturation is inverted (switch the
sign in front of the cos when calculating radius), and the L value is
increased by 20.
