# LMDropdownView
==============
LMDropdownView is a simple dropdown view inspired by Tappy.

[![CI Status](https://img.shields.io/travis/LMinh/LMDropdownView.svg?style=flat)](https://travis-ci.org/LMinh/LMDropdownView)
[![Version](https://img.shields.io/cocoapods/v/LMDropdownView.svg?style=flat)](https://cocoapods.org/pods/LMDropdownView)
[![License](https://img.shields.io/cocoapods/l/LMDropdownView.svg?style=flat)](https://cocoapods.org/pods/LMDropdownView)
[![Platform](https://img.shields.io/cocoapods/p/LMDropdownView.svg?style=flat)](https://cocoapods.org/pods/LMDropdownView)

<img src="https://raw.github.com/lminhtm/LMDropdownView/master/Screenshots/screenshot1.png"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://raw.github.com/lminhtm/LMDropdownView/master/Screenshots/screenshot2.gif"/>

## Features
* Dropdown view with blur+transform3D effect.
* Using keyframe animation from Core Animation.
* You can easily change the menu content view.

## Requirements
* iOS 8.0 or higher 
* ARC

## Installation
LMDropdownView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LMDropdownView'
```

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
You can easily integrate the LMDropdownView with a few lines of code. For an example usage look at the code below.
```ObjC
LMDropdownView *dropdownView = [LMDropdownView dropdownView];
[dropdownView showFromNavigationController:self.navigationController withContentView:self.menuTableView];
```
See sample Xcode project in `/LMDropdownViewDemo`

## License
LMDropdownView is licensed under the terms of the MIT License.

## Contact
Minh Luong Nguyen
https://github.com/lminhtm

## Projects using LMDropdownView
Feel free to add your project [here](https://github.com/lminhtm/LMDropdownView/wiki/Projects-using-LMDropdownView)

## Donations
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=J3WZJT2AD28NW&lc=VN&item_name=LMDropdownView&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)

