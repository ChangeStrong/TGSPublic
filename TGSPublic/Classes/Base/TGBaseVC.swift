//
//  TGBaseVC.swift
//  SwiftFrameworkDemo
//
//  Created by luo luo on 2021/11/25.
//  Copyright © 2021 GL. All rights reserved.
//

import UIKit
import RxSwift
import ProgressHUD
import SnapKit
@objc public protocol TGFileHandlerProtocol{
    @objc optional  func handleNextNodeAction(_ node:Any,_ isNeedRemovedPreviousVC:UIViewController?)
}
public  let kNavBarHeight:CGFloat = 44;
open class TGBaseVC: UIViewController {
   
    public weak var needRemovedVC:UIViewController? //如果上一个界面需要被移除传入
    //在视频出现的时候是否需要刷新
    public  var isNeedUpdateDataInViewWillAppear:Bool = false
    //点击文件执行的相关操作
    public var fileDelegete:TGFileHandlerProtocol?
    public let disposeBag = DisposeBag()
    public var pageNumber:Int = 1
    //是否可以显示无任何数据的提示
    public var isCanShowEmptyAlert:Bool = false;
    public var isNeedHiddenSystemNavBar:Bool = false{
        didSet{
            if isNeedHiddenSystemNavBar == true{
                if self.navigationController  != nil{
//                    oldNavBarHiddenStatus = self.navigationController!.isNavigationBarHidden
                    self.navigationController?.isNavigationBarHidden = isNeedHiddenSystemNavBar;
                }
            }else{
                LLog(TAG: TAG(self), "not handle");
            }
        }
    }
    
    public var isNeedLeftPanGesture:Bool = false{
        didSet{
            //自定义侧滑手势
            if isNeedLeftPanGesture == true {
                self.monitorLeftPanGesture()
            }else{
                //移除左滑手势
                self.removeLeftPanGesture()
            }
        }
    }
    
    
    public var oldNavBarHiddenStatus:Bool = false;
    //用来监听点击返回--跳下一节点用
    public enum TGKFinishedType {
        case clickBackBtn //点击返回按钮
    }
    public typealias TGKFinishedBlock = (_ type: TGKFinishedType,_ tempVC:TGBaseVC) -> Void
    public var kFinishedBlock:TGKFinishedBlock?
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //        self.edgesForExtendedLayout = UIRectEdge.all
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        //导航条不透明
        self.navigationController?.navigationBar.isTranslucent = false
        self.initNavBarUI()
        self.isNeedLeftPanGesture = true;
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNeedHiddenSystemNavBar == true {
            if self.navigationController  != nil{
                oldNavBarHiddenStatus = self.navigationController!.isNavigationBarHidden
            }
            self.navigationController?.isNavigationBarHidden = true;
        }
        //        self.monitorWindowEvent()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removePreviousVCOfNavgation() //移除上一个观看界面
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isNeedHiddenSystemNavBar == true {
            //归还之前vc的状态
            if self.navigationController != nil{
                self.navigationController?.isNavigationBarHidden = oldNavBarHiddenStatus;
            }
        }
        //        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "NSWindowDidResizeNotification"), object: nil)
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        LLog(TAG: TAG(self), "viewDidLayoutSubviews");
        //        if TGGlobal.isMac() {
        //
        //        }
        self.windowSizeDidChangeAction()
    }
    //监听屏幕尺寸变化
    var lastStep:Int = 0;
    @objc func windowSizeChangeAction(){
        LLog(TAG: TAG(self), "windowSizeChangeAction");
        lastStep += 1;
        let currentStep = lastStep;
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(250*1)) {
            if currentStep != self.lastStep {
                LLog(TAG: TAG(self), "Discard redundant steps.!");
                return;
            }
            self.windowSizeDidChangeAction()
        }
        
    }
    
    // MARK: 需要外部去实现的
    //给子vc用来继承
    open  func windowSizeDidChangeAction() -> Void {
    }
    
    
    //    func monitorWindowEvent() -> Void {
    //        NotificationCenter.default.addObserver(self, selector: #selector(windowSizeChangeAction), name: Notification.Name.init(rawValue: "NSWindowDidResizeNotification"), object: nil)
    //    }
    
    //初始化导航条UI
    //这个已经不起作用了
    /*static func initNavigationBarUI() -> Void {
     let bar = UINavigationBar.appearance()
     var barAttrs: [NSAttributedString.Key : Any] = [:]
     barAttrs[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 18)
     //[UIFont systemFontOfSize:18];
     barAttrs[NSAttributedString.Key.foregroundColor] = UIColor.black
     bar.titleTextAttributes = barAttrs
     bar.setBackgroundImage(UIColor.init(hex: "F9F9F9").toImage(size: CGSize.init(width: 1.0, height: 1.0)), for: UIBarMetrics.default)
     }*/
    //end
    
    open func initNavBarUI() -> Void {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.init(hexStr:"F9F9F9")
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            // Fallback on earlier versions
        }
    }
    
    func initCustomNavBar() -> Void {
        
    }
    //移除navBar的上一个VC
    public  func removePreviousVCOfNavgation() -> Void {
        if self.needRemovedVC == nil {
            //没有需要被移除的
            return
        }
        if self.navigationController == nil {
            return
        }
        self.navigationController?.viewControllers.removeAll(where: { tempVC in
            if tempVC == self.needRemovedVC {
                return true
            }
            return false
        })
        //清空-以防某个vc未释放
        self.needRemovedVC = nil
    }
    // MARK: 手势监听
    var leftGesutre:UISwipeGestureRecognizer?
    open  func monitorLeftPanGesture() -> Void {
        if leftGesutre != nil {
            return
        }
        leftGesutre = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeLeftAction(gesture:)))
        leftGesutre!.direction = .right;
        self.view.addGestureRecognizer(leftGesutre!)
    }
    
    open func removeLeftPanGesture() -> Void {
        if leftGesutre == nil {
            LLog(TAG: TAG(self), "leftGesutre is nil.it isn't repeat to remove.!");
            return
        }
        self.view.removeGestureRecognizer(leftGesutre!)
        leftGesutre = nil
    }
    
    
    @objc open func swipeLeftAction(gesture:UISwipeGestureRecognizer){
        LLog(TAG: TAG(self), "gesture direction=\(gesture.direction)");
        if gesture.direction == .right {
            //退出当前界面
            self.backAction()
        }
    }
    
   
    
    // MARK: 事件
    @objc open func backAction() -> Void {
        exitVC()
    }
    public func exitVC() -> Void {
        ProgressHUD.dismiss()
        if self.navigationController != nil {
            LLog(TAG: TAG(self), "count=\(self.navigationController!.viewControllers.count)");
            if self.navigationController?.viewControllers.first != nil  && self.navigationController?.viewControllers.first == self{
                self.navigationController?.dismiss(animated: false)
                LLog(TAG: TAG(self), "nav dismiss");
            }else{
                self.navigationController?.popViewController(animated: false)
                LLog(TAG: TAG(self), "nav pop");
            }
            //            self.navigationController?.popViewController(animated: false)
        }else{
            LLog(TAG: TAG(self), "only diss Miss");
            self.dismiss(animated: false)
        }
    }
    
    @objc open func leftBtnAction() -> Void {
        self.backAction()
        
    }
    
    
    @objc open func rightBtnAction() -> Void {
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: deinit
    deinit {
        print("deinit- \(self.classForCoder)")
    }
    
    // MARK: 弹框
    open  func alertControl(title:String?,message:String?,sureName:String?,cancelName:String?,sureAction:(()->Void)?,cancelAction: (()->Void)? ) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if sureName != nil {
            let action = UIAlertAction(title: sureName, style: .destructive) { (action) in
                if sureAction != nil{
                    (sureAction ?? {})()
                }
            }
            alert.addAction(action)
        }
        
        if cancelName != nil {
            let cancel = UIAlertAction(title: cancelName, style: .cancel){ (action) in
                if cancelAction != nil{
                    (cancelAction ?? {})()
                }
            }
            alert.addAction(cancel)
        }
        let popover:UIPopoverPresentationController? = alert.popoverPresentationController;
        if popover != nil {
            popover!.sourceView = self.view;
            popover!.sourceRect = CGRect.init(x: TGWidth(self.view)*0.5, y: TGHeight(self.view)*0.5, width: 1, height: 1);
            popover!.permittedArrowDirections = .any
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    public typealias LSAlertFinisheBlock = (_ result:String,_ index:Int) -> Void
    open func showAlertSheetView(_ title: String?, content: String?, titles array: [String]?, handler hander: LSAlertFinisheBlock?) {
        
        showAlertType(.actionSheet, title: title, content: content, titles: array, handler: hander)
    }
    
    open func showAlertView(_ title: String?, content: String?, titles array: [String]?, handler hander: LSAlertFinisheBlock?) {
        showAlertType(.alert, title: title, content: content, titles: array, handler: hander)
    }
    
    open  func showAlertType(_ type: UIAlertController.Style, title: String?, content: String?, titles array: [String]?, handler hander: LSAlertFinisheBlock?) {
        //UIAlertControllerStyleActionSheet
        let alertVC = UIAlertController(title: title, message: content, preferredStyle: type)
        if TGGlobal.isPhone() == true {
            //在ipad上 会没有那么大空间
            let titleAttributes = [NSAttributedString.Key.font: TGFontBold(18), NSAttributedString.Key.foregroundColor: UIColor.black]
            let titleString = NSAttributedString(string: title ?? "", attributes: titleAttributes)
            alertVC.setValue(titleString, forKey: "attributedTitle")
        }
       
//        let messageAttributes = [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 17)!, NSAttributedStringKey.foregroundColor: UIColor.red]
//          let messageString = NSAttributedString(string: "Company name", attributes: messageAttributes)
//        alertVC.setValue(messageString, forKey: "attributedMessage")
        
        for i in 0..<(array?.count ?? 0) {
            let cancel = UIAlertAction(title: array?[i] as? String, style: .default, handler: { action in
                if hander != nil {
                    let str:String = array?[i] ?? "";
                    hander!(str,i)
                }
            })
            cancel.setValue(UIColor.blue, forKey: "titleTextColor")
            alertVC.addAction(cancel)
        }
        let popover:UIPopoverPresentationController? = alertVC.popoverPresentationController;
        if popover != nil {
            popover!.sourceView = self.view;
            popover!.sourceRect = CGRect.init(x: TGWidth(self.view)*0.5, y: TGHeight(self.view)*0.5, width: 1, height: 1);
            popover!.permittedArrowDirections = .any
        }
        present(alertVC, animated: true)
    }
    
    open  func showAlertInputTextType(_ type: UIAlertController.Style, title: String?, content: String?, placeHolder: String, buttonTitle:String, handler hander: LSAlertFinisheBlock?){
        showAlertInputTextType(type, title: title, content: content, placeHolder: placeHolder, buttonTitle: buttonTitle, .default, handler: hander)
    }
    
    open  func showAlertInputTextType(_ type: UIAlertController.Style, title: String?, content: String?, placeHolder: String, buttonTitle:String, _ keyboardType:UIKeyboardType = .default,handler hander: LSAlertFinisheBlock?) {
        //UIAlertControllerStyleActionSheet
        let alertVC = UIAlertController(title: title, message: content, preferredStyle: type)
        
        alertVC.addTextField { text in
            text.keyboardType = keyboardType
            text.placeholder = placeHolder
        }
        
        var cancel = UIAlertAction(title: buttonTitle, style: .default, handler: { action in
            if hander != nil {
                let str:String = alertVC.textFields?.first?.text ?? "";
                hander!(str,0)
            }
        })
        cancel.setValue(UIColor.blue, forKey: "titleTextColor")
        alertVC.addAction(cancel)
        
        
        let popover:UIPopoverPresentationController? = alertVC.popoverPresentationController;
        if popover != nil {
            popover!.sourceView = self.view;
            popover!.sourceRect = CGRect.init(x: TGWidth(self.view)*0.5, y: TGHeight(self.view)*0.5, width: 1, height: 1);
            popover!.permittedArrowDirections = .any
        }
        
        self.present(alertVC, animated: true)
    }
    
    
    // MARK: 屏幕旋转
    open override var shouldAutorotate: Bool{
        return false;
    }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait;
    }
    
    
    // MARK: 弹框
    open  func showAlertDecompressInputPassword(_ completion:@escaping ((_ isSure:Bool,_ password:String?) -> Void)) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: NSLocalizedString("Please enter the unzip password".localized, comment: ""),
                                                    message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { alert in
                completion(false,nil)
            }
            let okAction = UIAlertAction(title: "Sure".localized, style: .default, handler: {
                action in
                let textField: UITextField = (alertController.textFields?[0])!;
                completion(true,textField.text)
                //跳到定位设置
            })
            //添加输入框
            alertController.addTextField { (textfield) in
                textfield.delegate = self
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            let popover:UIPopoverPresentationController? = alertController.popoverPresentationController;
            if popover != nil {
                popover!.sourceView = self.view;
                popover!.sourceRect = CGRect.init(x: TGWidth(self.view)*0.5, y: TGHeight(self.view)*0.5, width: 1, height: 1);
                popover!.permittedArrowDirections = .any
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    
    // MARK: 背景
    //添加背景
    open func addBgImageViewFor(view:UIView,fatherView:UIView,imageStr:String)-> UIImageView{
        //无边框多余
        return addBgImageViewFor(view: view, fatherView: fatherView, imageStr: imageStr, edgInset: UIEdgeInsets.zero)
    }
    open func addBgImageViewFor(view:UIView,fatherView:UIView,imageStr:String?,edgInset:UIEdgeInsets) -> UIImageView {
        let bgView = UIImageView()
        bgView.isUserInteractionEnabled = true
        if imageStr != nil {
            bgView.image = UIImage.init(named: imageStr!)
        }
        bgView.backgroundColor = UIColor.clear
        fatherView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(-edgInset.top)
            make.left.equalTo(view).offset(-edgInset.left)
            make.right.equalTo(view).offset(edgInset.right)
            make.bottom.equalTo(view).offset(edgInset.bottom)
        }
        //背景放下面
        fatherView.insertSubview(bgView, belowSubview: view)
        return bgView
    }
    
    // MARK: 自定义button
    public lazy var navBar: UIView = {
        //隐藏系统的navBar
        self.isNeedHiddenSystemNavBar = true;
        
        let view = UIView()
        let statusBarHeight = TGNavStatusBarHeight();
        view.backgroundColor = UIColor.clear;
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)//.offset(statusBarHeight);
            make.left.right.equalTo(self.view).offset(0);
            make.height.equalTo(kNavBarHeight);
        }
        return view
    }()
    
    
    public var backBtnImg = UIImage.imageForModule("public_back_arrow")
    public  lazy var backBtn: TGExpandButton = {
        let view1 = UIImageView()
        view1.image = backBtnImg
        self.navBar.addSubview(view1)
        let scale:CGFloat = 22/40.0;
        view1.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.navBar).offset(-9)
            make.left.equalTo(self.navBar).offset(TGX(20))
            make.size.equalTo(CGSize.init(width: 20*scale, height: 20))
        }
        
        let view = TGExpandButton()
        //        view.setBackgroundImage(UIImage.init(named: "public_back_arrow"), for: UIControl.State.normal)
        view.backgroundColor = UIColor.clear
        view.addTarget(self, action: #selector(backAction), for: UIControl.Event.touchUpInside)
        self.navBar.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(view1).offset(0)
        }
        return view
    }()
    
    public    lazy var navLeftBtn: TGExpandButton = {
        let view = TGExpandButton()
        //        view.setTitle(LocalString("Cancel"), for: UIControl.State.normal)
        view.setTitleColor(TGColorTextGray6, for: UIControl.State.normal)
        view.backgroundColor = UIColor.clear
        view.titleLabel?.font = TGFont(16)
        view.frame = CGRect.init(x: 0, y: 0, width: 100, height: 50)
        view.addTarget(self, action: #selector(leftBtnAction), for: UIControl.Event.touchUpInside)
        self.navBar.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.navBar).offset(-9)
            make.left.equalTo(self.navBar).offset(TGX(20))
            make.size.equalTo(CGSize.init(width: TGX(60), height: 25))
        }
        return view
    }()
    
    public lazy var navRightBtn: TGExpandButton = {
        let view = TGExpandButton()
        view.setTitleColor(TGColorTheamMain, for: UIControl.State.normal)
        view.backgroundColor = UIColor.clear;
        view.titleLabel?.font = TGFont(16)
        view.frame = CGRect.init(x: 0, y: 0, width: 100, height: 50)
        view.addTarget(self, action: #selector(rightBtnAction), for: UIControl.Event.touchUpInside)
        self.navBar.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.navBar).offset(-9)
            make.right.equalTo(self.navBar).offset(TGX(-20))
            make.size.equalTo(CGSize.init(width: TGX(60), height: 25))
        }
        return view
    }()
    
    public lazy var navTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = TGFontBold(18)
        label.textAlignment = .center
        self.navBar.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self.navBar).offset(0)
            make.width.equalTo(self.navBar).multipliedBy(6.0/10.0)
        }
        return label
    }()
    
    
    
    
    
    
}

extension TGBaseVC: UITextFieldDelegate {
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}




