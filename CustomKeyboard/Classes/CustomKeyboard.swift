//
//  CustomKeyboard.swift
//  CustomKeyboard
//
//  Created by Liu Chuan on 2017/12/26.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

/// 屏幕的宽度
let screenWith = UIScreen.main.bounds.size.width
/// 默认完成按钮颜色
public let defaultDoneColor = UIColor(red:0.45, green:0.69, blue:0.95, alpha:1.00)

/// 键盘样式
///
/// - idcard: 身份证类型
/// - number: 数字类型
public enum KeyboardStyle {
    
    /// 身份证类型
    case idcard
    /// 小数
    case decimal
    /// 数字
    case number
}

// 遵守 UITextFieldDelegate 协议
/// 自定义键盘
open class CustomKeyboard: UIInputView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - 属性
    // 存储属性
    public static let `default` = CustomKeyboard(frame: CGRect(x: 0, y: 0, width: screenWith, height: 300), inputViewStyle: .keyboard)
    
    /// 文本输入框
    private var textFields = [UITextField]()
    
    /// 父视图
    private var superView: UIView?
    
    /// 按钮的个数
    private let buttonsCount: Int = 14
    
    /// 按钮数组
    fileprivate var buttions: [UIButton] = []

    /// 按钮文字
    fileprivate lazy var titles = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    /// 键盘样式
    public var keyboardStyle = KeyboardStyle.idcard {
        didSet {        // 监听 `style` 数值的改变, 从而设置数字键盘的样式
            setDigitButton(keyboardStyle)
        }
    }

    /// 是否高亮
    public var whetherHighlight = false {
        didSet {        // 监听 `whetherHighlight` 数值的改变, 从而设置按钮高亮状态
            highlight(heghlight: whetherHighlight)
        }
    }
    
    /// 是否开启键盘
    public var isEnableKeyboard: Bool = false {
        didSet {
            if isEnableKeyboard {
                // 注册键盘通知
                /**
                 *参数一：注册观察者对象，参数不能为空
                 *参数二：收到通知执行的方法，可以带参
                 *参数三：通知的名字
                 *参数四：收到指定对象的通知，没有指定具体对象就写nil
                 */
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            }else {
                NotificationCenter.default.removeObserver(self)
            }
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
        backgroundColor = .white
        addKeyboard(view, field: field)
    }
    
  
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - frame: 尺寸
    ///   - inputViewStyle: 输入视图样式
    public override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /***** 布局视图的时候调用 *****/
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        /// 纵列数
        let columnsNum = 4
        
        /// 一个按钮的宽度
        let btnWidth = frame.width / CGFloat(columnsNum)
        
        /// 一个按钮的高度
        let btnHeight = frame.height / CGFloat(columnsNum)
        
        /***循环布局12个按钮***/
        for i in 0...11 {
            let view = viewWithTag(i + 1)
            view?.frame.origin.x = btnWidth * CGFloat((i) % 3)  //3个按钮以换行
            view?.frame.origin.y = btnHeight * CGFloat((i) / 3)
            view?.frame.size.width = btnWidth
            view?.frame.size.height = btnHeight
        }
        /**** 右边: 删除\确定按钮 ****/
        // 因为上文button的tag值加1, 所以获取tag值需要加1
        viewWithTag(12 + 1)?.frame = CGRect(x: btnWidth * 3, y: 1, width: btnWidth, height: btnHeight * 2 - 1)
        viewWithTag(13 + 1)?.frame = CGRect(x: btnWidth * 3, y: btnHeight * 2, width: btnWidth, height: btnHeight * 2)
    }
    
    /***** 绘制界面: 按钮的分割线 *****/
    // 调用情况: 1.UIView初始化后自动调用； 2.调用setNeedsDisplay方法时会自动调用）
    open override func draw(_ rect: CGRect) {

        /// 纵列数
        let columnsNum = 4

        /// 一个按钮的宽度
        let btnWidth = frame.width / CGFloat(columnsNum)

        /// 一个按钮的高度
        let btnHeight = frame.height / CGFloat(columnsNum)

        // 创建一个贝塞尔路径
        let bezierPath = UIBezierPath()

        for i in 0 ... 3 {  // 4条横线
            //开始绘制
            bezierPath.move(to: CGPoint(x: 0, y: btnHeight * CGFloat(i)))
            bezierPath.addLine(to: CGPoint(x: frame.width, y: btnHeight * CGFloat(i)))
        }
        for i in 1 ... 3 {  // 3条竖线
            bezierPath.move(to: CGPoint(x: btnWidth * CGFloat(i), y: 0))
            bezierPath.addLine(to: CGPoint(x: btnWidth * CGFloat(i), y: frame.height))
        }
        UIColor.lightGray.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
    }
    
    /// 设置完成按钮
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - titleColor: 标题颜色
    ///   - theme: 主题
    ///   - target: 目标控制器
    ///   - callback: 回调
    private func setDoneButton(_ title: String, titleColor: UIColor, theme: UIColor, target: UIViewController?, callback: Selector?) {
        // 通过tag值获取done按钮
        guard let itemButton = findButton(by: 13 + 1) else {
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

    /// 添加键盘视图
    ///
    /// - Parameters:
    ///   - view: 视图
    ///   - field: 文本输入框
    private func addKeyboard(_ view: UIView, field: UITextField? = nil) {
        superView = view
        customSubview()
        
        guard let textField = field else {
            for view in (superView?.subviews)! {
                guard view.isKind(of: UITextField.self) else { return }
                let textField = view as! UITextField
                textField.delegate = self
                textField.inputView = self
                textFields.append(textField)
            }
            return
        }
        textFields.append(textField)
        textField.inputView = self
        textField.delegate = self
    }

    
    /// 自定义视图
    private func customSubview() {
        
        /// 退格键\删除键 图片视图
        var backSpace: UIImage?
        
        /// 消失图片视图
        var dismiss: UIImage?
        
        // 获取指向类对象的引用，只需使用 ClassName.self
        let podBundle = Bundle(for: CustomKeyboard.self)
        
        // 获取当前类的文件路径
        guard let bundleURL = podBundle.url(forResource: "CustomKeyboard", withExtension: "bundle") else {
            backSpace = UIImage(named: "Keyboard_Backspace")
            dismiss = UIImage(named: "Keyboard_DismissKey")
            return
        }
        guard let bundle = Bundle(url: bundleURL) else {
            backSpace = UIImage(named: "Keyboard_Backspace")
            dismiss = UIImage(named: "Keyboard_DismissKey")
            return
        }
        // 设置图片
        backSpace = UIImage(named: "Keyboard_Backspace", in: bundle, compatibleWith: nil)
        dismiss = UIImage(named: "Keyboard_DismissKey", in: bundle, compatibleWith: nil)

        /* 创建键盘视图上所有的按钮 */
        for idx in 0 ..< buttonsCount {
            let button = UIButton()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 28)
            button.setTitleColor(UIColor.black, for: .normal)

            switch idx {    // tag值
            case 9:         //包含0, 所以当前是第10个按钮
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
                button.backgroundColor = .white
            case 13:        // 完成按钮
                button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                button.backgroundColor = defaultDoneColor
                button.setTitleColor(UIColor.white, for: .normal)
                button.setBackgroundImage(nil, for: .normal)
                button.setBackgroundImage(nil, for: .highlighted)
                button.setTitle(LocalizedString("Done"), for: .normal)
            default:        // 数字按钮
                button.setTitle("\(idx + 1)", for: .normal)
                buttions.append(button)
            }
            button.addTarget(self, action: #selector(tap), for: .touchUpInside)
            addSubview(button)
            button.tag = idx + 1
        }
    }

    /// 键盘视图按钮点击事件
    ///
    /// - Parameter sender: 按钮
    @objc func tap(_ sender: UIButton) {
        // 获取按钮的当前文字
        guard let text = sender.currentTitle else {
            fatalError("not found the sender's currentTitle")
        }
        // 因为上文button的tag值加1, 所以值改变了
        switch sender.tag {
        case 12:                        // 小数点
            handlePoint(btn: sender)
        case 12 + 1:                    // 删除
            handleDelete(button: sender)
        case 13 + 1, 9 + 1:             // 隐藏键盘\确定键,辞去第一响应者
            firstResponder()?.resignFirstResponder()
        default:                        // 其他按钮文本框插入当前输入文本
            firstResponder()?.insertText(text)
        }
        /*
        播放输入点击.
            想要在点击自定义输入或键盘附加视图的键时: 播放输入点击音，首先要确认该视图采用了UIInputViewAudioFeedback协议。
            然后，为每个点击提供你想要的点击声音，调用UIDevice类的playInputClick方法
         */
        UIDevice.current.playInputClick()
    }
    
    /// 处理小数点
    ///
    /// - Parameter btn: 按钮
    private func handlePoint(btn: UIButton) {
        
        // 获取按钮的当前文字
        guard let text = btn.currentTitle else { return }

        // 获取文本输入框的文字
        guard let str = firstResponder()?.text else { return }
        // 是否包含字符 '.'
        let subStr = str.contains(".")
        
        if subStr {
            print("小数点已存在....")
        }else {
            firstResponder()?.insertText(text)
        }
    }
    
    /// 处理删除
    private func handleDelete(button: UIButton) {
        
        // 单击删除
        firstResponder()?.deleteBackward()
        
        /// 创建长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(deleteLongPressed))
        longPress.delegate = self
        
        // 设置最低长按时长 ( 以秒为单位 )
        longPress.minimumPressDuration = 0.5
        
        // 添加长按手势
        button.addGestureRecognizer(longPress)
    }

    /// 删除按钮长按事件
    ///
    /// - Parameter sender: 长按手势
    @objc private func deleteLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        guard sender.state == .began else {
            print("长按响应结束")
            return
        }
        print("长按响应开始")
        /* 根据文本输入框的文字的个数, 多次循环删除 */
        for _ in 0 ... (firstResponder()?.text?.count)! {
            firstResponder()?.deleteBackward()
        }
    }
 
    /// 高亮状态
    ///
    /// - Parameter heghlight: 是否高亮
    private func highlight(heghlight: Bool) {
        
        print(subviews.count)
        
        /// 获取当前视图的所有子视图的个数
        let subviewCount = subviews.count
        
        /// 获取当前视图的所有按钮的个数
        let subviewBtnCout = subviewCount - 2
        
        for i in 2 ... subviewBtnCout {
            // 获取按钮
            guard let button = subviews[i] as? UIButton else { return }
            // 如何是确定按钮就直接返回
            if button.tag == 13 + 1 { return }
            if heghlight {
                button.setBackgroundImage(UIImage.dk_image(with: .clear), for: .normal)
                button.setBackgroundImage(UIImage.dk_image(with: .lightGray), for: .highlighted)
            }else {
                button.setBackgroundImage(UIImage.dk_image(with: .clear), for: .normal)
                button.setBackgroundImage(UIImage.dk_image(with: .clear), for: .highlighted)
            }
        }
    }

    /// 设置数字按钮的样式
    ///
    /// - Parameter style: 样式
    private func setDigitButton(_ style: KeyboardStyle) {
        guard let button = findButton(by: 12) else {
            fatalError("not found the button with the tag")
        }
        switch keyboardStyle {
        case .idcard:
            button.setTitle("X", for: .normal)
        case .decimal:
            let locale = Locale.current
            // 返回地区的十进制分隔符。例如，对于“en_US”，返回“.”
            let decimalSeparator = locale.decimalSeparator! as String
            button.setTitle(decimalSeparator, for: .normal)
        case .number:
            button.setTitle("", for: .normal)
        }
    }
    
    /// 第一响应者
    ///
    /// - Returns: 文本输入框
    private func firstResponder() -> UITextField? {
        var firstResponder: UITextField?
        for field in textFields {
            if field.isFirstResponder {
                firstResponder = field
            }
        }
        return firstResponder
    }

    /// 通过按钮的 tag 值，获取按钮
    ///
    /// - Parameter tag:  tag 值
    /// - Returns: 按钮
    private func findButton(by tag: Int) -> UIButton? {
        
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
    private func LocalizedString(_ key: String) -> String {
        return (Bundle(identifier: "com.apple.UIKit")?.localizedString(forKey: key, value: nil, table: nil))!
    }
    
    /// 键盘即将显示 (弹起)
    ///
    /// - Parameter notification: 通知
    @objc fileprivate func keyboardWillShow(_ notification: NSNotification) {
        print("成为第一响应者 (弹起键盘)")
    }
    
    /// 键盘即将隐藏 (收起)
    ///
    /// - Parameter notification: 通知
    @objc fileprivate func keyboardWillHide(_ notification: NSNotification) {
        print("辞去第一响应者 (收起键盘)")
    }
    
}
// MARK: - 扩展 UIImage
extension UIImage {
    
    /// 利用颜色绘制成新的图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 尺寸
    /// - Returns: UIImage
    fileprivate class func dk_image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
       
        // 开启图形上下文
        UIGraphicsBeginImageContext(size)
        // 设置颜色
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

// MARK: - UIInputViewAudioFeedback
/* 播放输入点击
 当用户点击自定义输入视图和键盘附加视图的时候，你可以播放标准的系统键盘点击音。首先，在你的输入视图中采用UIInputViewAudioFeedback协议。然后，当响应该视图的键盘点击的时候调用playInputClick方法。
 */
extension CustomKeyboard: UIInputViewAudioFeedback {
    open var enableInputClicksWhenVisible: Bool {
        return true
    }
}
