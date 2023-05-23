//
//  TGPaginationVo.swift
//  SwiftFrameworkDemo
//
//  Created by luo luo on 2021/12/24.
//  Copyright © 2021 GL. All rights reserved.
//

import UIKit

class TGPaginationVo: TGBaseModel {
    var pageSize:Int=0
    var pageNo:Int?
    var firstResult:Int?
    var nextPage:Int?
    var prePage:Int?
    var totalCount:Int?
    var totalPage:Int?
    var isFirstPage:Bool = false
    var isLastPage:Bool = false
    
}
