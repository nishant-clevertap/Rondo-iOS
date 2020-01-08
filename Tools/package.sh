#!/usr/bin/env bash
xcodebuild clean -workspace Rondo-iOS.xcworkspace -scheme Rondo-iOS
xcodebuild archive -workspace Rondo-iOS.xcworkspace -scheme Rondo-iOS -archivePath build/Rondo-iOS.xcarchive
xcodebuild -exportArchive -archivePath build/Rondo-iOS.xcarchive -exportPath build/ -exportOptionsPlist build/ExportOptions.plist
