LMDropdownView
==============
LMDropdownView is a simple dropdown view inspired by Tappy.

<img src="https://raw.github.com/lminhtm/LMDropdownView/master/Screenshots/screenshot1.png"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://raw.github.com/lminhtm/LMDropdownView/master/Screenshots/screenshot2.gif"/>

## Features
* Dropdown view with blur+transform3D effect.
* Using keyframe animation from Core Animation.
* You can easily change the menu content view.

## Requirements
* iOS 7.0 or higher 
* ARC

## Installation
#### From CocoaPods
```ruby
pod 'LMDropdownView'
```
#### Manually
* Drag the `LMDropdownView` folder into your project.
* Add `#include "LMDropdownView.h"` to the top of classes that will use it.

## Swift Version
https://github.com/lminhtm/LMDropdownViewSwift

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
* https://github.com/lminhtm
* lminhtm@gmail.com

## Donations
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=J3WZJT2AD28NW&lc=VN&item_name=LMDropdownView&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)
