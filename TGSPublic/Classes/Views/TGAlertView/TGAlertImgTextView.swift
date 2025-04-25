//
//  TGAlertImgTextView.swift
//  Yeast
//
//  Created by luo luo on 2024/11/9.
//

import UIKit


public class TGAlertImgTextView: UIView,UITextViewDelegate {
    public  enum ClickType {
        case sureAction
    }
    public var clickAdoptionTimes:Int = 0 //用在请求下一章时 切换大模型
    public  typealias ClickBlock = (_ type: ClickType,_ value:NSMutableAttributedString) -> Void
    public var clickBlock:ClickBlock?
    public static let share:TGAlertImgTextView = TGAlertImgTextView();
    var fartherWindow:UIWindow?
    var requestKey:String = ""//对应的正在请求的key
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        setupUI()
    }
    
    var isFistLoad = true;
    public override func layoutSubviews() {
        super.layoutSubviews()
        if self.superview != nil && isFistLoad == true {
            isFistLoad = false;
            //初始化UI
            self.setupUI()
        }else{
            if self.superview != nil {
                //更新UI
            }
        }
    }
    
    // MARK: UI
    func setupUI() -> Void {
        self.bgBlackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.blurBgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(TGX(30))
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-80)
            make.left.equalTo(self).offset(TGX(20))
            make.right.equalTo(self).offset(TGX(-20))
        }
        
        self.sureBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.blurBgView).offset(TGX(-8))
//            make.right.equalTo(self.blurBgView).offset(TGX(-8))
            make.centerX.equalTo(self.blurBgView)
            make.size.equalTo(CGSize(width: TGX(120), height: TGX(40)))
        }
        
        self.textView.snp.makeConstraints { (make) in
            make.top.equalTo(self.blurBgView).offset(TGX(8))
            make.left.equalTo(self.blurBgView).offset(TGX(8))
            make.right.equalTo(self.blurBgView).offset(TGX(-8))
            make.bottom.equalTo(self.sureBtn.snp.top).offset(TGX(-10))
        }
        
        if self.sureBtn.isHidden == true {
            LLog(TAG: TAG(self), "updateUI隐藏了");
            self.indicatorView.style = .large
            self.indicatorView.snp.remakeConstraints { (make) in
                make.centerX.equalTo(self.blurBgView)
                make.centerY.equalTo(self.sureBtn)
            }
            
        }else{
            self.indicatorView.style = .medium
            self.indicatorView.snp.remakeConstraints { (make) in
                make.right.equalTo(self.sureBtn.snp.left).offset(-10)
                make.centerY.equalTo(self.sureBtn)
            }
        }
       
//        self.indicatorView.snp.makeConstraints { (make) in
//            make.right.equalTo(self.sureBtn.snp.left).offset(-10)
//            make.centerY.equalTo(self.sureBtn)
//        }
        self.bringSubviewToFront(self.textView)
        self.bringSubviewToFront(self.sureBtn)
        self.bringSubviewToFront(self.indicatorView)
    }
    
    func updateUI() -> Void {
       
        if self.sureBtn.isHidden == true {
            LLog(TAG: TAG(self), "updateUI隐藏了");
            self.indicatorView.style = .large
            self.indicatorView.snp.remakeConstraints { (make) in
                make.centerX.equalTo(self.blurBgView)
                make.centerY.equalTo(self.sureBtn)
            }
            
        }else{
            self.indicatorView.style = .medium
            self.indicatorView.snp.remakeConstraints { (make) in
                make.right.equalTo(self.sureBtn.snp.left).offset(-10)
                make.centerY.equalTo(self.sureBtn)
            }
        }
        self.sendSubviewToBack(self.bgBlackView)
        self.bringSubviewToFront(self.textView)
        self.bringSubviewToFront(self.sureBtn)
        self.bringSubviewToFront(self.indicatorView)
    }
    required init?(coder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    // MARK: 操作
    var fontSize:CGFloat = 25.0
    var isShowing:Bool = false
    public class func show(_ requestKey:String,_ text:NSMutableAttributedString,_ isShowSureBtn:Bool = true,_ fontSize:CGFloat = 25){
        self.share.fartherWindow = TGGlobal.getScenesDelegate()?.window as? UIWindow
        if self.share.fartherWindow == nil {
            LLog(TAG: TAG(self), "father window is nil.!");
            return
        }
        self.share.requestKey = requestKey
        self.share.fontSize = fontSize
        let range = NSRange(location: 0, length: text.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = TGFontSpaceSize(CGFloat(10)) // 设置行间隙为10个点
        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        text.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range: range)
        self.share.textView.attributedText = text
        self.share.textView.isEditable = false
        self.share.isShowing = true;
        self.share.fartherWindow?.addSubview(self.share)
        self.share.fartherWindow?.bringSubviewToFront(self.share)
        self.share.frame = CGRect.init(x: 0, y: 0, width: self.share.fartherWindow!.width, height: self.share.fartherWindow!.height)
        if isShowSureBtn {
            //显示采用按钮
            self.share.sureBtn.isHidden = false
        }else{
            self.share.sureBtn.isHidden = true
        }
        self.share.updateUI()
    }
    
    public class func updateTextUI(_ text:NSMutableAttributedString) -> Void {
        let range = NSRange(location: 0, length: text.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = TGFontSpaceSize(CGFloat(10)) // 设置行间隙为10个点
        text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        text.addAttribute(.font, value: UIFont.systemFont(ofSize: self.share.fontSize), range: range)
        self.share.textView.attributedText = text
    }
    
    class func remove() {
        if self.share.superview != nil {
            self.share.removeFromSuperview()
        }
        self.share.isShowing = false;
    }
    // MARK: 点击事件
    @objc func clickBgAction(){
        self.clickAdoptionTimes += 1
        self.clickBgAction2()
        //通知请求取消
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: requestKey), object: nil)
        
    }
    
    func clickBgAction2() -> Void {
        TGAlertImgTextView.remove()
        TGAlertImgTextView.share.sureBtn.setTitle("Adopt".localeForModule, for: UIControl.State.normal)
    }
    
//    @objc func clickBgAction2(){
//        LLog(TAG: TAG(self), "clickBgAction2");
//    }
    
    @objc func sureAction(){
        LLog(TAG: TAG(self), "sureAction");
        if self.indicatorView.isAnimating {
            //还在请求中--点击采用无效
            LLog(TAG: TAG(self), "please wait finished.!!");
            return
        }
    
        self.clickAdoptionTimes = 0 //点击采用 就清零
        self.clickBlock?(.sureAction,NSMutableAttributedString(attributedString: self.textView.attributedText))
        self.clickBgAction2()
    }
    
    @objc func cancelAction(){
        LLog(TAG: TAG(self), "cancelAction");
        self.clickBgAction()
    }
    
    // MARK: 懒加载
    lazy var bgBlackView: UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor.black
        view.alpha = 0.6
        view.addTarget(self, action: #selector(clickBgAction), for: UIControl.Event.touchUpInside)
        self.addSubview(view)
        return view
    }()
    lazy var blurBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        //UIColor(hexStr: "#b8bd9a");
        //
        view.layer.cornerRadius = TGX(10)
        view.clipsToBounds = true
//        view.addTarget(self, action: #selector(clickBgAction2), for: UIControl.Event.touchUpInside)
        self.addSubview(view)
        let view2 = view.addBlurView(style: .extraLight)
//        view2.alpha = 1.0
        return view
    }()
    
    public lazy var textView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.autocorrectionType = .no //关闭自动纠正
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor.black;
        view.textAlignment = .center;
        view.font = TGFont(25)
        view.delegate = self;
        self.addSubview(view)
        return view
    }()
    
    public  lazy var sureBtn: UIButton = {
        let view = UIButton()
        view.setTitle("Adopt".localeForModule, for: UIControl.State.normal)
        view.backgroundColor = UIColor.init(hexStr: "#ff5251")
        view.frame = CGRect.init(x: 0, y: 0, width: 100, height: 50)
        view.addTarget(self, action: #selector(sureAction), for: UIControl.Event.touchUpInside)
        self.addSubview(view)
        view.layer.cornerRadius = 10
//        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    lazy var cancelBtn: UIButton = {
        let view = UIButton()
        view.setTitle("Cancel".localeForModule, for: UIControl.State.normal)
        view.backgroundColor = UIColor.red
        view.frame = CGRect.init(x: 0, y: 0, width: 100, height: 50)
        view.addTarget(self, action: #selector(cancelAction), for: UIControl.Event.touchUpInside)
        self.addSubview(view)
        return view
    }()
    
    public lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .red
        view.center = self.center
        view.hidesWhenStopped = true
        self.addSubview(view)
        return view
    }()
    
    
    // MARK: UITextViewDelegate
    public func textViewDidChange(_ textView: UITextView) {
        
    }

}
