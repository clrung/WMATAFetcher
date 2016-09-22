# Version 2.1.0
* Updated to Swift 3
* Updated SwiftyJSON

# Version 2.0.1
* trainArrayShouldIncludeSpaces -> isSpaceInTrainArray to be consistent with boolean naming convention
* Changed errorCode's type from String? to Int? to facilitate easier custom error handling
* Added more documentation

# Version 2.0.0 (codename: "usable") 
This is what should have been v.1.0.0.

* `WMATAFetcher` was refactored considerably to only expose what is needed to the user.
* Added Usage
* Added [AppleDocs](http://nshipster.com/documentation/) to the classes

# Version 1.0.1
Steps toward making this a true API:
* WMATAFetcher is now a class, and must be instantiated with a WMATA API key.
* Fields that should be accessable to the user were made `public`.
* Explicitly listed how the Train class relates to [IMPredictionTrainInfo](https://developer.wmata.com/docs/services/547636a6f9182302184cda78/operations/547636a6f918230da855363f/console#AIMPredictionTrainInfo).

# Version 1.0.0
Initial release.

This is my first CocoaPod, and I should have used a pre-1.0.0 version number here.  The WMATAFetcher included in this release was a copy of what I used in my [DC Metro Widget](https://github.com/clrung/DCMetroWidget), and was not indended for public use.
