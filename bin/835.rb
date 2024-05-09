
# A Pythagorean triangle is called supernatural 
# if two of its three sides are consecutive integers.
# Let S(N) be the sum of the perimeters of all distinct supernatural triangles with perimeters less than or equal <span style="white-space:nowrap;"> to $N$.</span><br>
# For example, S(100) = 258 and
# S(10000) = 172004.
# Find S(10^{10^{10}}). 
# Give your answer modulo 1234567891.

a**2 + (a+1)**2 = c**2
a^2 + a^2 + 2a + 1 = c^2
2 a^2 + 2a + 1 = a(2a +1) + 1 = c^2
