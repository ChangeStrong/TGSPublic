//
//  TGWebviewCommonVC.swift
//  SwiftFrameworkDemo
//
//  Created by luo luo on 2022/3/22.
//  Copyright © 2022 GL. All rights reserved.
//

import UIKit
import WebKit

class TGWebviewCommonVC: TGBaseVC {
    var path:String = "http://www.baidu.com";
    var titile:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.backBtn.isHidden = false;
        self.navTitleLabel.text = titile;
        setupUI()
        loadData()
    }
    
    // MARK: UI
    func setupUI() -> Void {
        self.webView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar.snp.bottom).offset(0)
            make.left.right.equalTo(self.view).offset(0)
            make.bottom.equalTo(self.view).offset(-20)
        }
    }
    
    
    // MARK: 数据
    func loadData() -> Void {
        let urlR:URLRequest = URLRequest.init(url: URL.init(string: self.path)!)
        self.webView.load(urlR)
    }
    
    // MARK: 点击事件
    
    // MARK: 懒加载
    lazy var webView: WKWebView = {
        let view = WKWebView()
        view.frame = CGRect.init(x: 0, y: 0, width: TGWidth(self.view), height: TGHeight(self.view))
        
        self.view.addSubview(view)
        return view
    }()

}
