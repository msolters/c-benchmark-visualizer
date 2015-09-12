# c-benchmark-visualizer
A Meteor app that visualizes how long embedded code takes to run in realtime.

# Setup
Sometimes the mechanisms for clocking the amount of time different algorithms take to run in an embedded environment can be a pain, especially when you are in an environment where even the requirement of instantiating an interrupt-based timer could itself slow down the apparent processing speed of the application.

I often find it easier to use another microcontroller, and then send "benchmark" labels from the process I am interested in over serial.  The second microcontroller does nothing but timestamp those labels to millisecond precision.  However, reading this output from a serial port is not exactly optimal either.

Therefore, I created this web app which will automatically populate a bar chart in realtime showing how long each algorithm takes, as well as the total run time of all clocked processes.  It can only be run locally, since the idea is for the computer to be connected to the uC doing the clocking, and for that uC to be connected to the embedded environment of interest.
