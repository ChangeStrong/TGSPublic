//
//  TGBaseModel.swift
//  SwiftFrameworkDemo
//
//  Created by luo luo on 2021/11/28.
//  Copyright © 2021 GL. All rights reserved.
//

import UIKit
import HandyJSON
//@objcMembers 加上这个是方便我自己写的运行时方法起作用 主要用在文件的动画类里面
 open class TGBaseModel: NSObject,HandyJSON,Codable {
    required public override init() {}
    
    //json转模型时
   public var descriptioN:String?
    open func mapping(mapper: HelpingMapper) {
            // specify 'cat_id' field in json map to 'id' property in object
            mapper <<<
                self.descriptioN <-- "description"

    
        }
   
}

/*
 //转对象
 let object = BasicTypes.deserialize(from: jsonString)
 
 //转json
 print(object.toJSON()!) // serialize to dictionary
 print(object.toJSONString()!) // serialize to JSON string
 print(object.toJSONString(prettyPrint: true)!) // serialize to pretty JSON string
 
 func mapping(mapper: HelpingMapper) {
         // specify 'cat_id' field in json map to 'id' property in object
         mapper <<<
             self.id <-- "cat_id"

         // specify 'parent' field in json parse as following to 'parent' property in object
         mapper <<<
             self.parent <-- TransformOf<(String, String), String>(fromJSON: { (rawString) -> (String, String)? in
                 if let parentNames = rawString?.characters.split(separator: "/").map(String.init) {
                     return (parentNames[0], parentNames[1])
                 }
                 return nil
             }, toJSON: { (tuple) -> String? in
                 if let _tuple = tuple {
                     return "\(_tuple.0)/\(_tuple.1)"
                 }
                 return nil
             })

         // specify 'friend.name' path field in json map to 'friendName' property
         mapper <<<
             self.friendName <-- "friend.name"
     }
 
 
 //自定义解析某个属性
 
 
 
 //支持枚举
 enum TGFileType:Int,HandyJSONEnum {
 case unknow = 0
 }
 
 //支持Date
 override func mapping(mapper: HelpingMapper) {
     super.mapping(mapper: mapper)
         mapper <<<
             createDate <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd HH:mm:ss:SSS")
     }
 
 //忽略属性
 override static func ignoredProperties() -> [String] {
         return ["owner"]
     }
 
 
 
//针对非object-c对象
 //自定义解析某个属性
 func mapping(mapper: HelpingMapper) {
         mapper <<<
             self.frame <-- TransformOf<CGRect, NSDictionary>(
                 fromJSON: { (value: NSDictionary?) -> CGRect in
                     if let dictionary = value {
                         let x = dictionary["x"] as? CGFloat ?? 0
                         let y = dictionary["y"] as? CGFloat ?? 0
                         let width = dictionary["width"] as? CGFloat ?? 0
                         let height = dictionary["height"] as? CGFloat ?? 0
                         return CGRect(x: x, y: y, width: width, height: height)
                     }
                     return CGRect.zero
                 },
                 toJSON: { (value: CGRect?) -> NSDictionary in
                     if let rect = value {
                         let dictionary: [String: CGFloat] = [
                             "x": rect.origin.x,
                             "y": rect.origin.y,
                             "width": rect.size.width,
                             "height": rect.size.height
                         ]
                         return NSDictionary(dictionary: dictionary)
                     }
                     return NSDictionary()
                 }
             )
     }
 
 
 */


