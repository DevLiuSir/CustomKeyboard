//
//  ViewController.swift
//  CustomKeyboardExample
//
//  Created by Liu Chuan on 2017/12/26.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

/// 淡蓝色
let lightBlue = UIColor(red:0.45, green:0.69, blue:0.95, alpha:1.00)
let lightOrange = UIColor(red:255.0/255.0, green:128.0/255.0, blue:0.0, alpha:1.00)

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
        textField.borderStyle = .roundedRect
        textField.text = "0"
        view.addSubview(textField)
        
        /* -- CustomKeyboard --- */
        let keyboard = CustomKeyboard(view, field: textField, keyboardStyle: .custom)
        keyboard.isEnableKeyboard = true
        keyboard.whetherHighlight = true
        keyboard.frame.size.height = 300
        keyboard.customDoneButton(title: "确定", titleColor: .white, theme: lightOrange, target: self, callback: nil)
        textField.becomeFirstResponder()
    }
}
