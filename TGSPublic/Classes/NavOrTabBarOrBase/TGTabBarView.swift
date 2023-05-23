//
//  TGTabBarView.swift
//  SwiftFrameworkDemo
//
//  Created by luo luo on 2022/2/8.
//  Copyright © 2022 GL. All rights reserved.
//

import UIKit

class TGTabBarView: UITabBar {
    
    var images:[(normal:String,selectedImg:String)] = [
                           ("post_tabbar_fabu","post_tabbar_fabu"),
                           ("icon_home_nor","icon_home_sel"),
                           ("icon_me_nor","icon_me_sel")];
    var titles:[String] = ["Store".localized,"Local".localized,"My".localized];
    var allItems:[UIButton] = []
    let barHeight:CGFloat = 49;
    //按钮之间的水平间隙
    var horizationInterval:CGFloat = 20;
    //topBgView的padding
//    var topBgViewPaddingInsert:UIEdgeInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0)
    //
    var currentSelectedBlock:((_ index:Int) -> Void)?
    var currentIndex:Int = 0{
        didSet{
//            if currentIndex == 1 {
//                //点击中间的无需更改
//            }else{
                for (index,item) in allItems.enumerated(){
                    if index == currentIndex {
                        //被选中的
//                        item.imageView.image = UIImage.init(named: self.images[index].selectedImg)
//                        item.textColor = UIColor.init(hex: "FF5251")
                        item.isSelected = true;
//                        item.setTitleColor(UIColor.black, for: UIControl.State.normal)
//                        item.titleLabel?.font = TGFontBold(18)
                    }else{
                        //未被选中的
//                        item.imageView.image = UIImage.init(named: self.images[index].normal)
//                        item.textColor = UIColor.init(hex: "888888")
                        item.isSelected = false;
//                        item.setTitleColor(TGColorTextGray8, for: UIControl.State.normal)
//                        item.titleLabel?.font = TGFontBold(18)
                    }
                }
//            }
            if currentSelectedBlock != nil {
                self.currentSelectedBlock!(currentIndex)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        setupUI()
    }
    var isFistLoad = true;
    override func layoutSubviews() {
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
    
    func fetchMaxWidth() -> CGFloat {
        var maxWidth:CGFloat = 60;
        for item in titles{
            let tempStrSize = String.size(withText: item, maxSize: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: TGFont(18).lineHeight), font: TGFont(18))
            if tempStrSize.width > maxWidth{
                maxWidth = tempStrSize.width+10;
            }
        }
        return maxWidth;
    }
    
    // MARK: UI
    func setupUI() -> Void {
//        self.backgroundColor = UIColor.red
        self.bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).offset(0)
        }
        let topInsert:CGFloat = 0;
        self.topBgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.bgView).offset(topInsert)
            make.left.right.equalTo(self.bgView).offset(0)
            make.height.equalTo(barHeight)
        }
        
        let count:CGFloat = CGFloat(self.images.count);
        let itemWidth:CGFloat = fetchMaxWidth();
        let itemHeight:CGFloat = barHeight;
        horizationInterval = (TGWidth(self)-(itemWidth*count))/(count + 1);

        
        var lastView:UIView? = nil
        for index in 0..<self.images.count {
            let view = UIButton()
            view.frame = CGRect.init(x: 50, y: 100, width: itemWidth, height: barHeight)
            if TGGlobal.isPhone() {
                view.titleLabel?.font = TGFont(18)
            }else{
                view.titleLabel?.font = UIFont.systemFont(ofSize:22)
            }
            view.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
            view.setTitleColor(TGColorTextGray8, for: UIControl.State.normal)
            view.setTitleColor(UIColor.black, for: UIControl.State.selected)
            view.tag = index;
            self.topBgView.addSubview(view)
            if lastView == nil {
                view.snp.makeConstraints { (make) in
                    make.top.equalTo(self.topBgView).offset(0)
                    make.left.equalTo(self.topBgView).offset(horizationInterval)
                    make.size.equalTo(CGSize.init(width: itemWidth, height: itemHeight))
                }
            }else if index == 1 {
                view.snp.makeConstraints { (make) in
                    make.centerY.equalTo(lastView!).offset(0)
                    make.centerX.equalTo(self.topBgView)
                    make.size.equalTo(CGSize.init(width: itemWidth, height: itemHeight))
                }
            }else if index == 2{
                view.snp.makeConstraints { (make) in
                    make.centerY.equalTo(lastView!).offset(0)
                    make.right.equalTo(self.topBgView).offset(-horizationInterval)
                    make.size.equalTo(CGSize.init(width: itemWidth, height: itemHeight))
                }
            }
//            else{
//                view.snp.makeConstraints { (make) in
//                    make.centerY.equalTo(lastView!).offset(0)
//                    make.left.equalTo(lastView!.snp.right).offset(self.horizationInterval)
//                    make.size.equalTo(CGSize.init(width: itemWidth, height: itemHeight))
//                }
//            }
            lastView = view;
            /*
            if index == 1 {
                //中间的只需显示图片
                let view2 = UIImageView()
                view2.image = UIImage.init(named: self.images[index].normal)
                self.bgView.addSubview(view2)
                view2.snp.makeConstraints { (make) in
                    make.center.equalTo(view).offset(0)
                    make.size.equalTo(CGSize.init(width: itemWidth-10, height: itemWidth-10))
                }
                self.bgView.sendSubviewToBack(view2)
                
            }else{*/
                //只显示文字
                view.setTitle(self.titles[index], for: UIControl.State.normal)
//            }
            
//            var imgSize:CGSize = CGSize.init(width: TGX(0), height: TGX(0))
//            if index == 1 {
//                //中间那个--图片稍微加大一点
//                imgSize = CGSize.init(width: TGX(30), height: TGX(30))
//            }
//            let temp = TGGloabalUI.addContentForButton(button: view, fatherView: self.topBgView, bgImageStr: nil, imageStr: self.images[index].normal, title: self.titles[index], imgDirection: .Top, imageSize: imgSize, interval: 5, contentInset: UIEdgeInsets.zero)
//            temp.titleLabel.font = TGFont(18)
//            temp.titleLabel.textColor = UIColor.init(hex: "888888");
            self.allItems.append(view)
        }
        //默认选中第一个
        self.currentIndex = 0;
    }
    
    func updateUI() -> Void {
        
    }
    
    required init?(coder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    // MARK: 事件
    @objc func btnClick(btn:UIButton){
        LLog(TAG: TAG(self), "taggg=\(btn.tag)");
        self.currentIndex = btn.tag;
    }
    
    // MARK: 懒加载
    //固定tabbar高度49+34  //刘海屏+34
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        //UIColor.init(hex: "F5F5F5")
        self.addSubview(view)
        return view
    }()
    
    lazy var topBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        self.addSubview(view)
        return view
    }()
    
    

}
