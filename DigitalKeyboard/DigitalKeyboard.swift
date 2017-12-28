//
//  DigitalKeyboard.swift
//  CustomKeyboard
//
//  Created by Liu Chuan on 2017/12/26.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

/// 间距
let marginvalue = CGFloat(0.5)
/// 屏幕的宽度
let screenWith = UIScreen.main.bounds.size.width
/// 默认完成按钮颜色
public let defaultDoneColor = UIColor(red: 28 / 255, green: 171 / 255, blue: 235 / 255, alpha: 1)

/// 样式
///
/// - idcard: 身份证类型
/// - number: 数字类型
public enum Style {
    
    /// 身份证类型
    case idcard
    /// 数字
    case number
}

// MARK: - 数字键盘。 遵守 UITextFieldDelegate 协议
open class DigitalKeyboard: UIInputView, UITextFieldDelegate {
    
    // MARK: - 属性
    // 存储属性
    open static let `default` = DigitalKeyboard(frame: CGRect(x: 0, y: 0, width: screenWith, height: 250), inputViewStyle: .keyboard)
    
    /// 文本输入框
    private var textFields = [UITextField]()
    
    /// 父视图
    private var superView: UIView?
    
    /// 按钮
    fileprivate var buttions: [UIButton] = []

    /// 按钮文字
    fileprivate lazy var titles = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    /// 样式
    var style = Style.idcard {
        didSet {
            setDigitButton(style)
        }
    }

    /// 是否安全
    open var isSafety: Bool = false {
        didSet {
            if isSafety {
                
                // 注册键盘通知
                /**
                 *参数一：注册观察者对象，参数不能为空
                 *参数二：收到通知执行的方法，可以带参
                 *参数三：通知的名字
                 *参数四：收到指定对象的通知，没有指定具体对象就写nil
                 */
                // 显示键盘
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotify(notifiction:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            }
        }
    }

    /// 是否应该高亮
    public var shouldHighlight = true {
        didSet {
            highlight(heghlight: shouldHighlight)
        }
    }

    // MARK: - 方法
    
    /// 自定义完成按钮
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - titleColor: 标题颜色
    ///   - theme: 主题
    ///   - target: 目标控制器
    ///   - callback: 回调
    public func customDoneButton(title: String, titleColor: UIColor = UIColor.white, theme: UIColor = defaultDoneColor, target: UIViewController? = nil, callback: Selector? = nil) {
        
        setDoneButton(title, titleColor: titleColor, theme: theme, target: target, callback: callback)
    }

    /*
     指定构造器: 必须调用它直接父类的指定构造器方法.
     便利构造器: 必须调用同一个类中定义的其它初始化方法.
     便利构造器: 在最后必须调用一个指定构造器.
     */
    /// 便利构造器
    ///
    /// - Parameters:
    ///   - view: 视图
    ///   - field: 文本输入框
    public convenience init(_ view: UIView, field: UITextField? = nil) {
        self.init(frame: CGRect.zero, inputViewStyle: .keyboard)
        
        addKeyboard(view, field: field)
    }

    /// 初始化方法
    ///
    /// - Parameters:
    ///   - _: 尺寸
    ///   - inputViewStyle: 输入视图样式
    fileprivate override init(frame _: CGRect, inputViewStyle: UIInputViewStyle) {
        let frameH = CGFloat(250)
        super.init(frame: CGRect(x: 0, y: 0, width: screenWith, height: frameH), inputViewStyle: inputViewStyle)
        backgroundColor = .lightGray
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 添加键盘视图
    ///
    /// - Parameters:
    ///   - view: 视图
    ///   - field: 文本输入框
    public func addKeyboard(_ view: UIView, field: UITextField? = nil) {
        superView = view
        
        customSubview()
        
        if let textField = field {
            textFields.append(textField)
            textField.inputView = self
            textField.delegate = self
        } else {
            for view in (superView?.subviews)! {
                if view.isKind(of: UITextField.self) {
                    let textField = view as! UITextField
                    textField.delegate = self
                    textField.inputView = self
                    textFields.append(textField)
                }
            }
        }
    }

    
    /// 自定义视图
    fileprivate func customSubview() {
        
        /// 退格键\删除键 图片视图
        var backSpace: UIImage?
        
        /// 消失视图
        var dismiss: UIImage?
        
        let podBundle = Bundle(for: classForCoder)
        // 获取文件路径
        if let bundleURL = podBundle.url(forResource: "DigitalKeyboard", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                // 设置图片
                backSpace = UIImage(named: "Keyboard_Backspace", in: bundle, compatibleWith: nil)
                dismiss = UIImage(named: "Keyboard_DismissKey", in: bundle, compatibleWith: nil)
            } else {
                backSpace = UIImage(named: "Keyboard_Backspace")
                dismiss = UIImage(named: "Keyboard_DismissKey")
            }
        } else {
            backSpace = UIImage(named: "Keyboard_Backspace")
            dismiss = UIImage(named: "Keyboard_DismissKey")
        }
        /* 创建 键盘视图上所有的按钮 */
        for idx in 0 ... 13 {
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 28)
            button.backgroundColor = UIColor.white
            button.tag = idx
            button.setTitleColor(UIColor.black, for: .normal)
            
            highlight(heghlight: shouldHighlight)
            addSubview(button)
            
            switch idx {    // tag值
            case 9:
                button.setTitle("", for: .normal)
                button.setImage(dismiss, for: .normal)
            case 10:        // 0
                button.setTitle("0", for: .normal)
                buttions.append(button)
            case 11:        // 小数点
                button.setTitle("X", for: .normal)
            case 12:        // 退格键
                button.setTitle("", for: .normal)
                button.setImage(backSpace, for: .normal)
            case 13:        // 完成按钮
                button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                button.backgroundColor = defaultDoneColor
                button.setTitleColor(UIColor.white, for: .normal)
                button.setBackgroundImage(nil, for: .normal)
                button.setBackgroundImage(nil, for: .highlighted)
                button.setTitle(LocalizedString("Done"), for: .normal)
            default:
                button.setTitle("\(idx + 1)", for: .normal)
                buttions.append(button)
            }
            button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        }
    }

    /// 键盘视图按钮点击事件
    ///
    /// - Parameter sender: 按钮
    @objc func tap(_ sender: UIButton) {
        guard let text = sender.currentTitle else {
            fatalError("not found the sender's currentTitle")
        }
        switch sender.tag {
        case 12:
            firstResponder()?.deleteBackward()         // 删除
        case 13, 9:
            firstResponder()?.resignFirstResponder()   // 隐藏键盘\确定键,辞去第一响应者
        default:
            firstResponder()?.insertText(text)         // 其他按钮文本框插入当前输入文本
        }
        /*
         播放输入点击
         想要在点击自定义输入或键盘附加视图的键时: 播放输入点击音，首先要确认该视图采用了UIInputViewAudioFeedback协议。然后，为每个点击提供你想要的点击声音，调用UIDevice类的playInputClick方法 */
        UIDevice.current.playInputClick()
    }

    /// 第一响应者
    ///
    /// - Returns: 文本输入框
    func firstResponder() -> UITextField? {
        var firstResponder: UITextField?
        for field in textFields {
            if field.isFirstResponder {
                firstResponder = field
            }
        }
        return firstResponder
    }

    /// 布局视图的时候调用
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnWidth = (frame.width - marginvalue * 3) / 4    // 1个按钮的宽度
        let btnHeight = (frame.height - marginvalue) / 2      // 1个按钮的高度
        let x: CGFloat = btnWidth * 3 + marginvalue
        
        for view in subviews {
            if view.isKind(of: UIButton.self) { // 判断按钮是否是这个类或者这个类的子类的实例
                let i = view.tag
                
                //  删除键\确定键 以外 所有按钮 的 frame
                let threeX: CGFloat = CGFloat(i % 3) * ((btnWidth * 3 - marginvalue * 2) / 3 + marginvalue)
                let threeY: CGFloat = CGFloat(i / 3) * (frame.height / 4 + marginvalue)
                let threeWidth: CGFloat = (btnWidth * 3 - marginvalue * 2) / 3
                let threeHeight: CGFloat = (frame.height - marginvalue * 3) / 4
                
                if i >= 12 {    // 删除键\确定键的frame
                    let y: CGFloat = CGFloat((i - 12) % 2) * (frame.height / 2 + marginvalue)
                    view.frame = CGRect(x: x, y: y, width: btnWidth, height: btnHeight)
                }else {         // 其他按键的frame
                    view.frame = CGRect(x: threeX, y: threeY, width: threeWidth, height: threeHeight)
                }
            }
        }
    }

    /// 高亮状态
    ///
    /// - Parameter heghlight: 是否高亮
    func highlight(heghlight: Bool) {
        for view in subviews {
            if let button = view as? UIButton {
                if button.tag == 13 { return }
                if heghlight {
                    button.setBackgroundImage(UIImage.dk_image(with: .white), for: .normal)
                    button.setBackgroundImage(UIImage.dk_image(with: .lightGray), for: .highlighted)
                } else {
                    button.setBackgroundImage(UIImage.dk_image(with: .white), for: .normal)
                    button.setBackgroundImage(UIImage.dk_image(with: .white), for: .highlighted)
                }
            }
        }
    }

    /// 设置数字按钮的样式
    ///
    /// - Parameter style: 样式
    func setDigitButton(_ style: Style) {
        guard let button = findButton(by: 11) else {
            fatalError("not found the button with the tag")
        }
        switch style {
        case .idcard:
            button.setTitle("X", for: .normal)
        case .number:
            let locale = Locale.current
            let decimalSeparator = locale.decimalSeparator! as String
            button.setTitle(decimalSeparator, for: .normal)
        }
    }

    /// 通过按钮的 tag 值，获取按钮
    ///
    /// - Parameter tag:  tag 值
    /// - Returns: 按钮
    func findButton(by tag: Int) -> UIButton? {
        for button in subviews {
            if button.tag == tag {
                return button as? UIButton
            }
        }
        return nil
    }

    /// 调用Bundle的localizedString去查找指定( 调用者 )下的key并返回值
    ///
    /// - Parameter key: 调用者的key
    /// - Returns: 字符串
    func LocalizedString(_ key: String) -> String {
        return (Bundle(identifier: "com.apple.UIKit")?.localizedString(forKey: key, value: nil, table: nil))!
    }

    /// 设置完成按钮
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - titleColor: 标题颜色
    ///   - theme: 主题
    ///   - target: 目标控制器
    ///   - callback: 回调
    func setDoneButton(_ title: String, titleColor: UIColor, theme: UIColor, target: UIViewController?, callback: Selector?) {
        
        guard let itemButton = findButton(by: 13) else {
            fatalError("not found the button with the tag")
        }
        if let selector = callback, let target = target {
            itemButton.addTarget(target, action: selector, for: .touchUpInside)
        }
        itemButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        itemButton.setTitle(title, for: .normal)
        itemButton.backgroundColor = theme
        itemButton.setTitleColor(titleColor, for: .normal)
    }

    /// 显示键盘
    ///
    /// - Parameter _: 通知
    @objc func keyboardWillShowNotify(notifiction _: Notification) {
        titles = titles.sorted { _, _ in
            arc4random() < arc4random()
        }
        if !buttions.isEmpty {
            for (idx, item) in buttions.enumerated() {
                item.setTitle(titles[idx], for: .normal)
            }
        }
    }

   
}
// MARK: - 扩展UIImage
extension UIImage {
    // 绘制新的图片
    public class func dk_image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
       
        // 开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        color.set()
        
        //用下面混合模式,以渐变.效果为歌词逐字依次变为绿色(基于progress的递增)
        //UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn)
        // 直接绘图
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        // 关闭图形上下文
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: 遵守 UIInputViewAudioFeedback 协议
/* 播放输入点击
 当用户点击自定义输入视图和键盘附加视图的时候，你可以播放标准的系统键盘点击音。首先，在你的输入视图中采用UIInputViewAudioFeedback协议。然后，当响应该视图的键盘点击的时候调用playInputClick方法。
 
 采用UIInputViewAudioFeedback协议
 */
extension DigitalKeyboard: UIInputViewAudioFeedback {
    open var enableInputClicksWhenVisible: Bool {
        return true
    }
}
