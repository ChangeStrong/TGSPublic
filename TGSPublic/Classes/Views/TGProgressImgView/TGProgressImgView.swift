//
//  TGProgressImgView.swift
//  HotComicCommunity
//
//  Created by luo luo on 2022/2/16.
//

import UIKit

public class TGProgressImgView: UIImageView {

    
    public override init(frame: CGRect) {
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
        self.updateUI();
    }
    
    func updateUI() -> Void {
        var temp:CGFloat = TGWidth(self);
        if TGWidth(self) < TGHeight(self) {
            temp = TGWidth(self)
        }
//        temp = temp/2.0
//        let centerPoint:CGPoint = CGPoint.init(x: TGWidth(self)/2.0, y: TGHeight(self)/2.0)
//        self.circlularView.center = centerPoint;
//        self.circlularView.bounds = CGRect.init(x: 0, y: 0, width: temp, height: temp)
//        self.bringSubviewToFront(self.circlularView)
    }
    required init?(coder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    // MARK: 懒加载
  public  lazy var circlularView: TGCircularProgressView = {
        let view = TGCircularProgressView.init(frame: CGRect.init(x: 0, y: 0, width: TGX(150), height: TGX(150)))
        view.isHidden = false;
        view.mLineWidth = 4
        view.isHidden = true;
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.center.equalTo(self).offset(0)
            make.size.equalTo(CGSize.init(width: TGX(60), height: TGX(60)))
        }
        return view
    }()
}
