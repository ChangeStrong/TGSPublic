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
class TGBaseVC: UIViewController {
    //在视频出现的时候是否需要刷新
    var isNeedUpdateDataInViewWillAppear:Bool = false
    
    let disposeBag = DisposeBag()
    var pageNumber:Int = 1
    //是否可以显示无任何数据的提示
    var isCanShowEmptyAlert:Bool = false;
    var isNeedHiddenSystemNavBar:Bool = false{
        didSet{
            if isNeedHiddenSystemNavBar == true{
                if self.navigationController  != nil{
                    oldNavBarHiddenStatus = self.navigationController!.isNavigationBarHidden
                    self.navigationController?.isNavigationBarHidden = isNeedHiddenSystemNavBar;
                }
            }else{
                LLog(TAG: TAG(self), "not handle");
            }
        }
    }
    var isNeedLeftPanGesture:Bool = false{
        didSet{
            //自定义侧滑手势
            if isNeedLeftPanGesture == true {
                self.monitorLeftPanGesture()
            }
        }
    }
    
    
//   public func TAG() -> String {
//        return self.className
//    }
    var oldNavBarHiddenStatus:Bool = false;
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        self.edgesForExtendedLayout = UIRectEdge.all
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        //导航条不透明
        self.navigationController?.navigationBar.isTranslucent = false
        self.initNavBarUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNeedHiddenSystemNavBar == true {
            self.navigationController?.isNavigationBarHidden = true;
        }
//        self.monitorWindowEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isNeedHiddenSystemNavBar == true {
            //归还之前vc的状态
            if self.navigationController != nil{
                self.navigationController?.isNavigationBarHidden = oldNavBarHiddenStatus;
            }
        }
//        NotificationCenter.default.removeObserver(self, name: Notification.Name.init(rawValue: "NSWindowDidResizeNotification"), object: nil)
    }
    override func viewDidLayoutSubviews() {
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
    //给子vc用来继承
    func windowSizeDidChangeAction() -> Void {
       
        
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
    
    func initNavBarUI() -> Void {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.init(hex: "F9F9F9")
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            // Fallback on earlier versions
        }
    }
    
    func initCustomNavBar() -> Void {
        
    }
    // MARK: 手势监听
    var leftGesutre:UISwipeGestureRecognizer?
    func monitorLeftPanGesture() -> Void {
        if leftGesutre != nil {
            return
        }
        leftGesutre = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeLeftAction(gesture:)))
        leftGesutre!.direction = .right;
        self.view.addGestureRecognizer(leftGesutre!)
    }
    
    @objc func swipeLeftAction(gesture:UISwipeGestureRecognizer){
        LLog(TAG: TAG(self), "gesture direction=\(gesture.direction)");
        if gesture.direction == .right {
            //退出当前界面
            self.backAction()
        }
    }
    
    // MARK: 事件
    @objc func backAction() -> Void {
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
            self.dismiss(animated: true)
        }
    }
    
    @objc func leftBtnAction() -> Void {
        if self.navigationController != nil {
            if self.navigationController?.viewControllers.first != nil  && self.navigationController?.viewControllers.first == self{
                self.navigationController?.dismiss(animated: false)
            }else{
                self.navigationController?.popViewController(animated: false)
            }
        }else{
            self.dismiss(animated: true)
        }
        
    }
    
    
    @objc func rightBtnAction() -> Void {
        
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
    func alertControl(title:String?,message:String?,sureName:String?,cancelName:String?,sureAction:(()->Void)?,cancelAction: (()->Void)? ) -> Void {
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
    
    typealias LSAlertFinisheBlock = (_ result:String,_ index:Int) -> Void
    func showAlertSheetView(_ title: String?, content: String?, titles array: [String]?, handler hander: LSAlertFinisheBlock?) {
        
        showAlertType(.actionSheet, title: title, content: content, titles: array, handler: hander)
    }
    
    func showAlertView(_ title: String?, content: String?, titles array: [String]?, handler hander: LSAlertFinisheBlock?) {
        showAlertType(.alert, title: title, content: content, titles: array, handler: hander)
    }
    
    func showAlertType(_ type: UIAlertController.Style, title: String?, content: String?, titles array: [String]?, handler hander: LSAlertFinisheBlock?) {
        //UIAlertControllerStyleActionSheet
        let alertVC = UIAlertController(title: title, message: content, preferredStyle: type)
        for i in 0..<(array?.count ?? 0) {
            var cancel = UIAlertAction(title: array?[i] as? String, style: .default, handler: { action in
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
    // MARK: 屏幕旋转
    override var shouldAutorotate: Bool{
        return false;
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait;
    }

    // MARK: 弹框
    func showAlertDecompressInputPassword(_ completion:@escaping ((_ isSure:Bool,_ password:String?) -> Void)) {
        
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
    
    
    
    
    // MARK: 背景
    //添加背景
    func addBgImageViewFor(view:UIView,fatherView:UIView,imageStr:String)-> UIImageView{
        //无边框多余
        return addBgImageViewFor(view: view, fatherView: fatherView, imageStr: imageStr, edgInset: UIEdgeInsets.zero)
    }
    func addBgImageViewFor(view:UIView,fatherView:UIView,imageStr:String?,edgInset:UIEdgeInsets) -> UIImageView {
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
    
    lazy var navBar: UIView = {
        //隐藏系统的navBar
        self.isNeedHiddenSystemNavBar = true;
        
        let view = UIView()
        let statusBarHeight = TGNavStatusBarHeight();
        view.backgroundColor = UIColor.clear;
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(statusBarHeight);
            make.left.right.equalTo(self.view).offset(0);
            make.height.equalTo(44);
        }
        return view
    }()
    
    
    
    lazy var backBtn: TGExpandButton = {
        let view1 = UIImageView()
        view1.image = UIImage.init(named: "public_back_arrow")
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
    
    lazy var navLeftBtn: TGExpandButton = {
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
    
    lazy var navRightBtn: TGExpandButton = {
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
    
    lazy var navTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = TGFontBold(18)
        self.navBar.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self.navBar).offset(0)
        }
        return label
    }()
    
   
    
    
    
}

extension TGBaseVC: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}

extension TGBaseVC{
    
    
    
    // TODO: 点击文件夹
    func handFolderClick(folder:TGFolderModel) -> Void {
        //判断是否需要密码
        if folder.isNeedGesturePassword == true{
            //需要密码
            let tempVC = TGGestureLockVC.init();
            tempVC.currentType = .vertify;
            tempVC.modalPresentationStyle = .fullScreen
            tempVC.passwordCompleteBlock = { (result,type) in
                //验证成功
                if result == true {
                    LLog(TAG: TAG(self), "验证成功...");
                    self.handFolderClick2(folder: folder);
                }
            }
            self.present(tempVC, animated: false)
            return;
        }
        
        self.handFolderClick2(folder: folder);
        
    }
    
    func handFolderClick2(folder:TGFolderModel) -> Void {
        switch folder.watchModel {
        case .defaultIntellect:
//            LLog(TAG: TAG(self), "ggg22g");
            self.handleClickIntellectFolder(folder: folder)
//            LLog(TAG: TAG(self), "gggg");
            break;
        case .comic:
            let tempVC = TGComicLookVC.init()
            tempVC.model = folder;
            self.navigationController?.pushViewController(tempVC, animated: false)
            break;
        case .album:
            let tempVC = TGAlbumLookVC.init()
            tempVC.model = folder;
            self.navigationController?.pushViewController(tempVC, animated: false)
            break;
        case .musicHall:
            let tempVC = TGMusicalHallVC.init();
            tempVC.folderModel = folder;
            self.navigationController?.pushViewController(tempVC, animated: false)
            break;
        case .threeDModel:
            let tempVC = TGObjVC.init();
            tempVC.model = folder;
            self.navigationController?.pushViewController(tempVC, animated: false)
            break
        default:
            //以文件形式浏览
            let tempVC = TGFileListStyle1VC.init()
            tempVC.model = folder;
            self.navigationController?.pushViewController(tempVC, animated: false)
            break;
        }
    }
    
    func handleClickIntellectFolder(folder:TGFolderModel) -> Void {
        let type = folder.jugementFolderContentType();
        switch type {
        case .comic:
//            let tempVC = TGComicLookVC.init()
            let tempVC = TGComicOrAlbumVC.init()
            tempVC.model = folder;
            self.navigationController?.pushViewController(tempVC, animated: false)
            break;
        case .album:
            let tempVC = TGComicLookVC.init()
            tempVC.model = folder;
            self.navigationController?.pushViewController(tempVC, animated: false)
            break;
        case .musicHall:
            let tempVC = TGMusicalHallVC.init();
            tempVC.folderModel = folder;
            self.navigationController?.pushViewController(tempVC, animated: false)
            break;
        case .cinema:
            //目前也是以文件方式浏览
            let tempVC = TGFileListStyle1VC.init()
            tempVC.model = folder;
            self.navigationController?.pushViewController(tempVC, animated: false)
            break;
        case .eBook:
            let eBookCount = folder.getNumberOfPerCategory(.articles)
            if eBookCount == 1 {
                //只有一部作品直接跳进去观看
                folder.requestSyncFiles();
                var tempFile:TGFileBaseModel?
                for item in folder.files {
                    if item.fileType == .articles && item.fileSubType == .eBook{
                        tempFile = item;
                        break;
                    }
                }
                if tempFile != nil {
                    let tempVC = TGReadEBookVC.init()
                    tempVC.resourceURL = tempFile!.getUrl()
                    self.navigationController?.pushViewController(tempVC, animated: false)
                    break;
                }
            }else{
                //以文件形式浏览
                let tempVC = TGFileListStyle1VC.init()
                tempVC.model = folder;
                self.navigationController?.pushViewController(tempVC, animated: false)
            }
            //统计
            TGUserManager.share().enterVCOnce(.novalVC)
            break;
        case .threeDModel:
            let tempVC = TGObjVC.init();
            tempVC.model = folder;
            self.navigationController?.pushViewController(tempVC, animated: false)
            break
           
        default:
            //以文件形式浏览
            let tempVC = TGFileListStyle1VC.init()
            tempVC.model = folder;
            self.navigationController?.pushViewController(tempVC, animated: false)
            break;
        }
    }
    
    func exportFile(_ tempFolder:TGFolderModel) -> Void {
        self.showAlertView("Are you sure you want to export?".localized, content: "", titles: ["Sure".localized,"Cancel".localized]) { result, index in
            if index == 0 {
                //确定
                //压缩文件---
                ProgressHUD.show()
                DispatchQueue.global().async {
                    let zipFile = tempFolder.fetchCompressZip(nil)
                    if zipFile == nil {
                        ProgressHUD.showMessageAuto("fetch compress file failture")
                        return
                    }
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                        let shareURL =  zipFile!.getUrl()
                        let activityItems = [shareURL]
                        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                        vc.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                            print("\(String(describing: activityType))")
                            if completed {
                                print("分享成功")
                                tempFolder.deleteCompressedZipFile()//删除已压缩的文件
                            } else {
                                //用户取消了分享
                                print("户取消了分享")
                                tempFolder.deleteCompressedZipFile()//删除已压缩的文件
                            }
                            vc.dismiss(animated: true)
                        }
                        self.present(vc, animated: true)
                    }
                }

            }
        }
    }
    
}

