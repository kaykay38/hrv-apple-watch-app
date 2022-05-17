#!/bin/bash

# Build Test
xcodebuild -project HRV\ Monitor.xcodeproj -scheme 'HRV Monitor WatchKit ExtensionTests' -sdk watchsimulator8.5 -destination 'platform=watchOS Simulator,name=Apple Watch Series 7 - 41mm,OS=8.5' test | xcbeautify
