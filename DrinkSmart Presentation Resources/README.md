# Drink Smart

Provides users with a simple way to track their BAC and state of intoxication, as well as an intuitive way of messaging a predetermined emergency contact when a certain state of intoxication is reached. At the heart of the application is the BAC calculation. As with all BAC calculations, it is only accurate if you space your drinks evenly throughout the evening. For this reason, we advise against using this application for anything other than curiosity. We do not endorse underage drinking, nor drinking to excess. We claim no responsibility for user's actions while using this application.

## Architecture

In this repository you'll find the iOS application and all resources it requires, including code from two third party repositories that provide us with the round progress view (https://github.com/Ceroce/CERoundProgressView) in the Main View Controller, and radio buttons throughout (https://github.com/onegray/RadioButton-ios). The application follows a model-view-controller pattern, where the user and night classes make up the model, the view is contained in the storyboard, and the controller is implemented as UIViewControllers. For persistent storage, the application makes use of NSUserDefaults. See the image below for how individual UIViewControllers interact with the data objects. For a more detailed description of individual elements and interactions, see comments in code.

[<img src="doc/DrinkSmart_Architecture.jpg" width="652" height="483">]

Unidirectional arrows represent read only interactions, bidirectional arrows represent read + write interactions. Whenever the user object is written to, the change is reflected in NSUserDefaults.

## Requirements for Running and Building

The iOS application was developed using xCode 5, targeting iOS 7.

It makes use of several of Apple's frameworks and libraries, all listed under "Linked Frameworks and Libraries".

## HaLeAlEi Team

Thank you for taking the time to check out our work. Feel free to contribute as you please.

Haroon, Leo, Alexandra, Eivind

Macalester College, May 2014