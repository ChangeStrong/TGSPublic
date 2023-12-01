//
//  UIView+extension.swift
//  SwiftFrameworkDemo
//
//  Created by luo luo on 2021/12/4.
//  Copyright © 2021 GL. All rights reserved.
//

import Foundation
import UIKit

public extension UIView{
    //添加毛玻璃效果
     func addBlurView(style effctStyle: UIBlurEffect.Style) -> UIView {
        let blurEffect = UIBlurEffect(style: effctStyle)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
         self.addSubview(visualEffectView)
         self.sendSubviewToBack(visualEffectView)
        visualEffectView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).offset(0)
        }
        return visualEffectView
    }
    //添加过渡动画 duration 秒
    func addTransitionAnimation(_ duration:Float, _ type:String,_ subTpe:CATransitionSubtype = .fromTop) {
        
        // 立方体、吸收、翻转、波纹、翻页、反翻页、镜头开、镜头关
        let transition = CATransition()
        transition.duration = CFTimeInterval(duration)
        transition.type = CATransitionType(rawValue: type)
        transition.subtype = subTpe
        self.layer.add(transition, forKey: "animation")
        
        // 确保动画完成后移除过渡效果，以免影响后续动画
        DispatchQueue.main.asyncAfter(deadline: .now() + transition.duration) {
            self.layer.removeAnimation(forKey: kCATransition)
        }
       //        transition.type = @"cube";//立方体
       //        transition.type = @"suckEffect";//没什么效果 吸收
       //        transition.type = @"oglFlip";//  翻转 不管subType is "fromLeft" or "fromRight",official只有一种效果
         
       //                          @"rippleEffect";// 波纹
       //        transition.type = @"pageCurl"; // 翻页
       //        transition.type = @"pageUnCurl"; // 反翻页
       //        transition.type = @"cameraIrisHollowOpen "; // 镜头开
       //        transition.type = @"cameraIrisHollowClose "; // 镜头关
        
          
       //    transition.type 的类型可以有
       //    淡化、推挤、揭开、覆盖
       //    NSString * const kCATransitionFade;
       //    NSString * const kCATransitionMoveIn;
       //    NSString * const kCATransitionPush;
       //    NSString * const kCATransitionReveal;
       //    这四种，
       //    transition.subtype
       //    也有四种
       //    NSString * const kCATransitionFromRight;
       //    NSString * const kCATransitionFromLeft;
       //    NSString * const kCATransitionFromTop;
       //    NSString * const kCATransitionFromBottom;
       
       }
   
    
}

public extension UIView{
    var x:CGFloat{
        set{
            self.frame = CGRect.init(x: newValue, y: self.y, width: self.width, height: self.height);
        }
        get{
            return self.frame.origin.x;
        }
    }
    
    var y:CGFloat{
        set{
            self.frame = CGRect.init(x: self.x, y: newValue, width: self.width, height: self.height);
        }
        get{
            return self.frame.origin.y;
        }
    }
    
    var width:CGFloat{
        set{
            self.frame = CGRect.init(x: self.x, y: self.y, width: newValue, height: self.height);
        }
        get{
            return self.frame.size.width;
        }
    }
    
    var height:CGFloat{
        set{
            self.frame = CGRect.init(x: self.x, y: self.y, width: self.width, height: newValue);
        }
        get{
            return self.frame.size.height;
        }
    }
    
    var viewController: UIViewController? {
            var next = superview
        while (next != nil) {
                let nextResponder = next!.next
            if nextResponder == nil {
                return nil
            }
                if nextResponder is UIViewController {
                    return nextResponder as? UIViewController
                }
                next = next!.superview
            }
            return nil
        }
    
}
