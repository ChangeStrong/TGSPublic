//
//  StatusModel.swift
//  ComicChatSwift
//
//  Created by luo luo on 2020/4/21.
//  Copyright © 2020 GL. All rights reserved.
//

import UIKit
import HandyJSON
//通用接数据模型
class StatusModel<T:Any>: TGBaseModel {
    var code:Int32?
    var data:T?
    var message:String?
    //内部测试
    var datas:T?
}
