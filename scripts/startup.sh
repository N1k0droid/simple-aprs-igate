#!/bin/bash

echo "======================================================"
echo "APRS IGATE STARTUP"
echo "======================================================"
echo "Callsign: ${APRS_CALLSIGN}"
echo "Server: ${APRS_SERVER}:${APRS_PORT}"
echo "Location: ${LATITUDE}, ${LONGITUDE}"
echo "Filter Radius: ${FILTER_RADIUS} km"
echo "Frequency: 144.800 MHz (European APRS)"
echo "PPM Correction: ${RTL_PPM}"
echo "Time: $(date)"
echo "======================================================"

# Check RTL-SDR device
echo "Checking RTL-SDR device..."
rtl_test -t 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✓ RTL-SDR device found and working"
else
    echo "✗ ERROR: RTL-SDR device not found"
    exit 1
fi

# Create logs directory
mkdir -p /logs

# Generate configuration from template
echo "Generating Direwolf configuration..."
envsubst < /config/direwolf.conf.template > /config/direwolf.conf

echo ""
echo "Starting APRS iGate..."
echo "RTL-SDR -> Direwolf -> APRS-IS servers"
echo "======================================================"

# Start RTL-SDR -> Direwolf pipeline
rtl_fm -f 144800000 -p ${RTL_PPM} -M fm -s 22050 - | \
direwolf -c /config/direwolf.conf -r 22050 -D 1 -t 0 -
