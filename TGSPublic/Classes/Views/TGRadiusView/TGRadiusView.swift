//
//  TGRadiusView.swift
//  SwiftFrameworkDemo
//
//  Created by luo luo on 2021/12/5.
//  Copyright © 2021 GL. All rights reserved.
//

import UIKit

public class TGRadiusView: UIView {

    public    var radiusValue:CGFloat = 10;
    public var corners:UIRectCorner =  [.topLeft, .topRight]
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
                updateUI()
            }
        }
    }
    // MARK: UI
    func setupUI() -> Void {
//        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: UIBezierPath(20.0) ?? CGSize.zero)
        
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radiusValue, height: radiusValue))
        let shaperLayer = CAShapeLayer.init()
        shaperLayer.path = path.cgPath
        self.layer.mask = shaperLayer;
    }
    
    func updateUI() -> Void {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radiusValue, height: radiusValue))
        let shaperLayer = CAShapeLayer.init()
        shaperLayer.path = path.cgPath
        self.layer.mask = shaperLayer;
    }
    required init?(coder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    // MARK: 懒加载
    
}
