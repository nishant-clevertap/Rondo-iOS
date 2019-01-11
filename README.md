# Rondo-iOS
Internal QA test app for Leanplum
## Installation
Run: 
`pod install`
`open Rondo-iOS.xcworkspace/`
Build the app
## Usage
Rondo iOS has a few different features to help test the Leanplum product.

### App Setup
This screen shows the currently active Application Keys, User and Device settings, and API settings.

You can change the "Leanplum App" that Rondo is connected to by going to App Picker, and creating a New App with the API keys.

You can change the API endpoint that Rondo hits by going to Env Picker, and creating a New Environment. The production and QA environments are present by default.

You can also make a forced "Start" call, though it's recommended that you restart the app once you have added your App and Environment.

There is also a convenience button to quickly ask for iOS Push permissions.

### Adhoc

On this screen, you can type in any string and call a custom event, or state or user attribute.

### App Inbox

This screen shows the App Inbox for the user. Once you send a message through the Leanplum dashboard, it will show up here.

### Variables

On this screen, there are 4 variables that are being displayed. If you change the values on the Leanplum dashboard, those values will show here.
The variables are `varString, varNumber, varBool, varFile`

### SDK QA

This screen provides convenient buttons to quickly run the SDK QA through the app "RondoQA", present on the Leanplum production environment.
