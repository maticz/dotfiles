#!/bin/bash

wmctrl -c '' # Tell everyone to close gracefully
while [[ $(wmctrl -l | wc -l) -gt 0 ]]; do # Loop until all windows are closed
    sleep 0.5 # Wait a little bit before checking again
done
