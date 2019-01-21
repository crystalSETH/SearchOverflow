# SearchOverflow
> An iOS search client for StackOverflow using Stack Exchange API v2.2.

SeachOverflow is an iOS app that provides a simple interface for its users to search StackOverflow. With SearchOverflow, you can also view individual question details (includes a display of answers). Currently, all questions are sorted, in descending order, based on their "score" which is the net of that question's up/down votes. All answer lists will show answers with the accepted answer (if available) first, then sorted by score. 

## Features

- [x] Search StackOverflow using the Stack Exchange API
- [x] Inifinite scrolling of questions found
- [x] Question details page to see the answers for specific questions 
- [x] Markdown View to show question/answer bodies
- [x] Simple Unit Tests

## Requirements

- iOS 11.0+
- Xcode 10.0+
- Cocoapods

## Installation

Clone or download this repo.

[CocoaPods](http://cocoapods.org/) is neccessary to run `SearchOverflow`.
Using the terminal, navigate to the directory of this project and run:

```shell
pod install
```

## Project Thoughts
#### 3rd Party Libraries
I chose to use three 3rd party libraries via cocaopods, all of which are for UI: 
1. [Down](https://github.com/iwasrobbed/Down) - "Blazing fast Markdown (CommonMark) rendering in Swift, built upon [cmark v0.28.3](https://github.com/commonmark/cmark)."
2. [Kingfisher](https://github.com/onevcat/Kingfisher) - "a powerful, pure-Swift library for downloading and caching images from the web."
3. [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView) - "is a collection of awesome loading animations."

#### Improvements
Below (in Future Improvements), I've listed some additional improvements to make to this project. Being more descriptive:
I would like to add additional units test to the view controllers (specifically looking at you infinite scroll), as well as UI Testing and integration testing.
Speaking of inifinite scroll, this technique can have the potential to create a massive array of question arrays which would not be very effecient. I would like to refine this technique into something that would might only have ~100 (or some fixed number) questions avaiable at a time. 
Improvements can als be made to give the UI a little bit more a "feel."

## Future Improvements
- [ ] Refine infinite scroll to not have the potential for MASSIVE arrays
- [ ] More Unit Tests
- [ ] Search filtering by tags
- [ ] Search ordering by views, score, date, etc
- [ ] Refine UI
- [ ] Splash to Home animation
