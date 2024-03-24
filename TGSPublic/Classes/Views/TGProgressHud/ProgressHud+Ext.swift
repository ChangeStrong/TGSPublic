//
//  ProgressHud+Ext.swift
//  Yeast
//
//  Created by luo luo on 2022/11/24.
//

import Foundation
import ProgressHUD
public extension ProgressHUD {
      class func showMessageAuto(_ text:String) -> Void {
        if Thread.current != Thread.main {
            DispatchQueue.main.async {
                ProgressHUD.animate(text)
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(1000*2)) {
                    ProgressHUD.dismiss()
                }
            }
        }else{
            ProgressHUD.animate(text)
            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(1000*2)) {
                ProgressHUD.dismiss()
            }
        }
        
    }
    
}
