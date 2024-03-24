//
//  TGCircularProgressView.swift
//  SwiftFrameworkDemo
//
//  Created by mac on 2020/7/8.
//  Copyright © 2020 GL. All rights reserved.
//

import UIKit

public class TGCircularProgressView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //设置padding值
    public var mContentInset:UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    //线宽度设置
    public var mLineWidth:CGFloat = TGX(10)
    //0-1
  public  var currentProgress:CGFloat = 0.0{
        didSet{
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            let temp = currentProgress*100;
            self.progresslabel.text = String(format: "%.1f%@", temp,"%")
            
        }
    }
    fileprivate  var circleCenter:CGPoint = CGPoint.zero
    fileprivate var radius:CGFloat = 0
    
    func getProgressPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.addArc(withCenter: circleCenter, radius: radius, startAngle: TGDegreesToRadian(360*(1-self.currentProgress)), endAngle: 0, clockwise: true)
        return path
    }
    
    //灰色背景路径
    lazy var grayBgPath: UIBezierPath = {
        let path = UIBezierPath()
        path.addArc(withCenter: circleCenter, radius: radius, startAngle: 0, endAngle: TGDegreesToRadian(360), clockwise: true)
        return path
    }()
    
    lazy var grayCicularLayer: CAShapeLayer! = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.init(hexStr: "F3F3F3").cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = CGFloat(mLineWidth)
        shapeLayer.lineJoin = .round;
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.2
        shapeLayer.shadowOffset = CGSize.init(width: 2, height: 2)
        shapeLayer.path = self.grayBgPath.cgPath
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }()
    
    lazy var gradientColorLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        //E97D5A
        gradientLayer.colors = [UIColor.init(hexStr: "E97D5A").cgColor,UIColor.init(hexStr: "E97D5A").cgColor]
            //[UIColor.init(hex: "feb718").cgColor, UIColor.init(hex: "fe5050").cgColor, UIColor.init(hex: "EFC082").cgColor]
        //gradientLayer.locations = [0.2, 0.5, 0.9];
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        //给渐变层添加一个遮罩 则只有这条路径显示且颜色渐变的路径
//        gradientLayer.mask = self.grayCicularLayer  //此处的layer可以不用被addsublayer
        gradientLayer.type = .axial
        self.layer.addSublayer(gradientLayer)
        return gradientLayer
    }()
    
//    lazy var topCicularLayer: CAShapeLayer! = {
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = UIColor.gray.cgColor
//        shapeLayer.lineWidth = CGFloat(mLineWidth)
//        shapeLayer.lineJoin = .round;
//        shapeLayer.path = self.grayBgPath.cgPath
//        self.layer.addSublayer(shapeLayer)
//        return shapeLayer
//    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    func setupUI() -> Void {
       
    }
    public  override func layoutSubviews() {
        super.layoutSubviews()
        
       
        circleCenter = CGPoint.init(x: TGWidth(self)/2.0, y: TGHeight(self)/2.0)
        radius = TGWidth(self)/2.0 - mLineWidth
        self.grayCicularLayer.isHidden = false
        self.gradientColorLayer.frame = self.bounds
        
        let progressPath  = self.getProgressPath()
        //创建用于遮罩的view
        let progressshapeLayer = CAShapeLayer()
        progressshapeLayer.fillColor = UIColor.clear.cgColor
        progressshapeLayer.strokeColor = UIColor.green.cgColor
        progressshapeLayer.lineWidth = CGFloat(mLineWidth)
        progressshapeLayer.lineJoin = .round
         progressshapeLayer.lineCap = .round
//        progressPath.lineCapStyle = .round
//        progressPath.lineJoinStyle = .round
        progressshapeLayer.lineCap = .round
        //只设置到进度路径
        progressshapeLayer.path = progressPath.cgPath
        
        
//        self.topCicularLayer.mask = progressshapeLayer
        self.gradientColorLayer.mask = progressshapeLayer
        
        self.progresslabel.isHidden = false
//        self.tipslabel.isHidden = false
    }
    
    // MARK: 其它
    lazy var progresslabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.textColor = UIColor.init(hexStr: "4D4D4D")
        label.font = TGFontBold(12)
        label.textAlignment = .center
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
//            make.centerY.equalTo(self).offset(TGX(-10))
        }
        return label
    }()
    /*
    lazy var tipslabel: UILabel = {
           let label = UILabel()
        label.text = "Loading..".localized
           label.textColor = UIColor.init(hex: "4D4D4D")
           label.font = TGFont(9)
           label.textAlignment = .center
           self.addSubview(label)
           label.snp.makeConstraints { (make) in
               make.centerX.equalTo(self)
            make.top.equalTo(self.progresslabel.snp.bottom).offset(9)
           }
           return label
       }()*/
}
