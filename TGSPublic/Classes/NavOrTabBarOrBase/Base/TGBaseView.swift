//
//  TGBaseView.swift
//  Yeast
//
//  Created by luo luo on 2022/11/11.
//

import UIKit

class TGBaseView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        windowSizeDidChangeAction()
    }
    
    var lastStep:Int = 0;
     func windowSizeChangeAction(){
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
}
