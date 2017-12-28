//
//  ViewController.swift
//  CustomKeyboard
//
//  Created by Liu Chuan on 2017/12/26.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

/// 淡蓝色
let lightBlue = UIColor(red:0.45, green:0.69, blue:0.95, alpha:1.00)

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.gray
        
        let textField = UITextField(frame: CGRect(x: 100, y: 120, width: 200, height: 35))
        textField.borderStyle = .roundedRect
        view.addSubview(textField)
       
        let keyboard = DigitalKeyboard(view)
        keyboard.style = .number
        keyboard.customDoneButton(title: "确定", titleColor: .white, theme: lightBlue, target: self, callback: nil)
        textField.inputView = keyboard
        textField.becomeFirstResponder()
        
        
    }
}

