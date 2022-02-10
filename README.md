# Pain Meds Buddy

![Platform](https://img.shields.io/badge/platform-ios-black.svg)  ![iOS Version](https://img.shields.io/badge/iOS-+14.5-green) ![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg) ![SwiftUI Version](https://img.shields.io/badge/SwiftUI-2.0-orange) ![Xcode Version](https://img.shields.io/badge/Xcode-12.5%20-blue) ![GitHub License](https://img.shields.io/github/license/JulesMoorhouse/sttv1.svg) [![Build Status](https://travis-ci.org/JulesMoorhouse/PainsMedBuddy.svg?branch=master)](https://travis-ci.org/JulesMoorhouse/PainsMedBuddy?branch=master) ![Twitter](https://img.shields.io/twitter/follow/MindwarpJules?style=social)

## Introduction

Pain Meds Buddy has been designed to help people in pain manage their medication. It allows the user to add their medication and track their doses. The app is focused on making it easy to manage pain around the person not a schedule.

The app is written with SwiftUI and uses Core Data / Combine. 

## Prerequisites

* The project was written using `Xcode 12.5` and `iOS 14.5`
* For best experience please use `iPhone 8 or later`
* You will also need [SwiftLint](https://github.com/realm/SwiftLint)
* The project  uses several swift packages :-
  - [https://github.com/MartinP7r/AckGen.git](https://github.com/MartinP7r/AckGen.git)
  - [https://github.com/DoubleSymmetry/XNavigation.git](https://github.com/DoubleSymmetry/XNavigation.git)
  - [https://github.com/ArnavMotwani/CircularProgressSwiftUI](https://github.com/ArnavMotwani/CircularProgressSwiftUI)
* To automate test coverage across multiple devices and produce framed screenshots [Fastlane](https://fastlane.tools) integration has been added, please see these [Setup Instructions](https://docs.fastlane.tools/getting-started/ios/setup/)

## Approach
The project uses an MVVM architecture approach. However, ViewModels have only been employed where Core Data fetch requests and more complex code has cluttered the SwiftUI Views. Unit Tests cover most of the code where it is difficult to visual test functionality. There is also some UI Testing which covers the main functionality of the app e.g. adding / editing. The project also has good accessibility coverage.

## Design / Screenshots

<a target="_blank" href="/fastlane/screenshots/en-GB/iPhone 11 Pro Max-01-Home.png"><img align=right width=150 height=324 src="/fastlane/screenshots/en-GB/iPhone 11 Pro Max-01-Home.png"></a><img align="right" src="gfx/spacer.gif" width="20" height="324">

### Home

##### Code
[HomeView.swift](/PainMedsBuddy/Routes/Home/HomeView.swift) / [HomeViewModel.swift](/PainMedsBuddy/Routes/Home/HomeViewModel.swift)

##### Usage
The main screen in the app has been designed to summarise medication and current doses. Here the user can quickly take the next medication and see which medication is running out.

When designing the app it was important to consider the key functions a user would need and how these could be performed quickly.

The progress circles show how long is left until the the user can take their next dose or whether medication has recently become available to take.

<img src="gfx/spacer.gif" width="100%" height="5">

<!-- -->

<a target="_blank" href="/fastlane/screenshots/en-GB/iPhone 11 Pro Max-02-Medications.png"><img align=left width=150 height=324 src="/fastlane/screenshots/en-GB/iPhone 11 Pro Max-02-Medications.png"></a><img align="left" src="gfx/spacer.gif" width="20" height="324">

### Medications

##### Code
[MedsView.swift](/PainMedsBuddy/Routes/Meds/MedsView.swift) / [MedsViewModel.swift](/PainMedsBuddy/Routes/Meds/MedsViewModel.swift)

##### Usage
Here in the medications screen the user can see all the drugs they have setup.

They can also see an icon for which will make it easier to identify the medication at a glance.

A simple sort feature has been provided to make it easier to find medications if the list grows over time.

<img src="gfx/spacer.gif" width="100%" height="5">

<!-- -->

<a target="_blank" href="/fastlane/screenshots/en-GB/iPhone 11 Pro Max-03-AddMed.png"><img align=right width=150 height=324 src="/fastlane/screenshots/en-GB/iPhone 11 Pro Max-03-AddMed.png"></a><img align="right" src="gfx/spacer.gif" width="20" height="324">

### Add Medications

##### Code
[MedAddView.swift](/PainMedsBuddy/Routes/Meds/MedAddView.swift)

##### Usage
The add medication screen allows the user to setup details about their medication, the dose and how long the medication should last.

A gap time can also be used to space out medication taken through-out the day so coverage of the medication can stretched across the day within the maximum dose range for the day.

The user can also pick from a range of medical related icons and colours.

<img src="gfx/spacer.gif" width="100%" height="5">

<!-- -->

<a target="_blank" href="/fastlane/screenshots/en-GB/iPhone 11 Pro Max-04-History.png"><img align=left width=150 height=324 src="/fastlane/screenshots/en-GB/iPhone 11 Pro Max-04-History.png"></a><img align="left" src="gfx/spacer.gif" width="20" height="324">

### In Progress / History

##### Code
[DosesView.swift](/PainMedsBuddy/Routes/Doses/DosesView.swift) / [DosesViewModel.swift](/PainMedsBuddy/Routes/Doses/DosesViewModel.swift)

##### Usage
The 'In Progress' / 'History screen' are very similar and either show available or taken medication.

The list of doses is grouped by day.

<img src="gfx/spacer.gif" width="100%" height="5">

<!-- -->

<a target="_blank" href="/fastlane/screenshots/en-GB/iPhone 11 Pro Max-05-AddDose.png"><img align=right width=150 height=324  src="/fastlane/screenshots/en-GB/iPhone 11 Pro Max-05-AddDose.png"></a><img align="right" src="gfx/spacer.gif" width="20" height="324">

### Add Dose Screen

##### Code
[DoseAddView.swift](/PainMedsBuddy/Routes/Doses/DoseAddView.swift)

##### Usage
The add dose screen is quite powerful, it uses the medications the user has setup and makes it easy and quick to add a new dose / take medication.

<img src="gfx/spacer.gif" width="100%" height="5">

<!-- -->
## App Store
You can also download the latest version of the app from the app store.

<a target="_blank" href="http://itunes.apple.com/app/id1603596916?mt=8">
    <img title="Download Pain Meds Buddy for iOS" height="61" width="206" src="/gfx/Download.png">
</a>
<br/>
You can also use this QR code to download the app from the app store.
<br/>
<img width=100 height=100 src="/gfx/qrcode.png">

# Contributing
Contributions for bug fixing or improvements are welcomed. Feel free to submit a pull request. Please ensure that all current unit tests and UI tests pass before submitting. Also if you find this code useful, feel free to buy a copy of my app, see the app store button above.

# License
Usage is provided under the [MIT License](http://opensource.org/licenses/mit-license.php). See LICENSE for the full details.


# Acknowledgements
I'd like to thank Paul Hudson from [Hacking with Swift](https://www.hackingwithswift.com) for his 100 days courses which I have followed since 2019. 

# Contact
You may [Contact me](https://www.julesmoorhouse.com/contactme/) with any questions or concerns at <a href="https://twitter.com/intent/tweet?screen_name=MindwarpJules&ref_src=twsrc%5Etfw" class="twitter-mention-button" data-show-count="false">@MindwarpJules</a>