![](https://github.com/ChinaHackers/Customkeyboard/raw/master/Screencast/Customkeyboard.png)

![](https://camo.githubusercontent.com/f3bc68f8badf9ec1143275e35cba2114910b0522/687474703a2f2f696d672e736869656c64732e696f2f62616467652f6c616e67756167652d73776966742d627269676874677265656e2e7376673f7374796c653d666c6174)
[![Swift &4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
![](https://camo.githubusercontent.com/c33e2972a445f3e8ecf5859b339577fcbe9e2b65/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f58636f64652d392532422d627269676874677265656e2e737667)
[![Swift compatible](https://img.shields.io/badge/swift-compatible-4BC51D.svg?style=flat)](https://developer.apple.com/swift/)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Customkeyboard.svg)](#cocoapods) 
![](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg)
![](https://img.shields.io/badge/platform-iOS-blue.svg)
![https://github.com/ChinaHackers/Customkeyboard/blob/master/LICENSE](https://img.shields.io/github/license/ChinaHackers/Customkeyboard.svg)
![](https://img.shields.io/github/stars/ChinaHackers/Customkeyboard.svg?style=social&label=Star)
[![Twitter Follow](https://img.shields.io/twitter/follow/LiuChuan_.svg?style=social)](https://twitter.com/LiuChuan_)


## What is Customkeyboard?
<p align="center"> <b> Customkeyboard is a simple and fast framework for custom digital keyboards. There's always a keyboard for you. </b></p> 


## Screencast from our Demo

![](https://github.com/ChinaHackers/Customkeyboard/raw/master/Screencast/Screencast.gif)


## Requirements
---
- iOS 11.2
- Xcode 9.2
- Swift 4.0.2+

## Installation

[CocoaPods](http://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```swift
$ gem install cocoapods
```


Just add the `Customkeyboard` folder to your project.

or use `CocoaPods` with Podfile:

```swift
pod 'Customkeyboard'
```

Swift 4.0.3：

```swift

platform :ios, '11.2'
target '<Your Target Name>' do
use_frameworks!
pod 'Customkeyboard'
end
```



Then, run the following command:

```swift
$ pod install
```



## Example:

```swift
import UIKit
import Customkeyboard

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.gray
        example()
    }
    
    /// 例子
    private func example() {
        /// 文本框
        let textField = UITextField(frame: CGRect(x: 100, y: 120, width: 200, height: 35))
        textField.backgroundColor = UIColor.white
        view.addSubview(textField)
        
        let keyboard = CustomKeyboard(view)
        keyboard.style = .number
        keyboard.customDoneButton(title: "确定", titleColor: .white, theme: .blue, target: self, callback: nil)
        textField.inputView = keyboard
        textField.becomeFirstResponder()
    }
}

```

