![](https://github.com/ChinaHackers/Customkeyboard/raw/master/Screencast/Customkeyboard.png)

![language](https://img.shields.io/badge/language-swift-orange.svg)
[![Swift &4.0](https://img.shields.io/badge/swift-4.0+-blue.svg?style=flat)](https://developer.apple.com/swift/)
![xcode version](https://img.shields.io/badge/xcode-9+-brightgreen.svg)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Customkeyboard.svg)](#cocoapods) 
![downloard](https://img.shields.io/cocoapods/dt/Customkeyboard.svg)
![build](https://img.shields.io/appveyor/ci/gruntjs/grunt/master.svg)
![platform](https://img.shields.io/cocoapods/p/Customkeyboard.svg?style=flat)
![https://github.com/ChinaHackers/Customkeyboard/blob/master/LICENSE](https://img.shields.io/github/license/ChinaHackers/Customkeyboard.svg)
![Github star](https://img.shields.io/github/stars/ChinaHackers/Customkeyboard.svg?style=social&label=Star)
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
       
	 /** CustomKeyboard **/
        let keyboard = CustomKeyboard(view)
        keyboard.style = .number
        keyboard.customDoneButton(title: "确定", titleColor: .white, theme: .blue, target: self, callback: nil)
        textField.inputView = keyboard
        textField.becomeFirstResponder()
    }
}

```

