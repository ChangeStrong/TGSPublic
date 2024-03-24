//
//  TGRunTimeUtil.swift
//  TGSPublic
//
//  Created by luo luo on 2023/12/1.
//

import Foundation
public class TGRunTimeUtil {
    //将结构体转类  结构体->字典->类
    public static func conventStructToModel<C:NSObject,S>( temp : S) -> C where S: Encodable{
        let model:C = C()
        //获取
        let dict:Dictionary? = TGDecoder.encoder(toDictionary: temp)
        if dict == nil {
            print("dict is nil.!")
            return model
        }
        
        let propertyNames:[String] = self.getAllpropertyList(C.self)
        for item in propertyNames {
            let value = dict![item]
            if value == nil {
//                print("value is nil. key=\(item)")
                continue
            }
            model.setValue(value!, forKey: item)
        }
        return model
    }
    //类转类---swift的枚举类型copy不过来
    public static func conventModelToModel<C:NSObject,M:NSObject>( temp : M) -> C{
        return self.conventModelToModel(temp: temp, blackList: [])
    }
    //类转类 黑名单属性不copy
    public static func conventModelToModel<C:NSObject,M:NSObject>( temp : M, blackList:[String]) -> C{
        return self.conventModelToModel(temp: temp, blackList: blackList, old: nil)
    }
    //类转类 在原类上修改
    public static func conventModelToModel<C:NSObject,M:NSObject>(temp : M, blackList:[String], old:C? = nil) -> C{
        var model:C = C()
        if old != nil {
            model = old!
        }
        //模型转字典
        let dict:Dictionary? = TGDecoder.conventModelToDict(model: temp)
        if dict == nil {
            print("dict is nil.!")
            return model
        }
        
        let propertyNames:[String] = self.getAllpropertyList(C.self)
        for item in propertyNames {
            if blackList.contains(item) {
                //黑名单属性不copy
                continue
            }
            let value = dict![item]
            if value == nil {
//                print("value is nil. key=\(item)")
                continue
            }
            model.setValue(value!, forKey: item)
        }
        return model
        
    }
    
    //将类转结构  类转->json->转结构体
    public  static func conventModelToStruct<C:NSObject,S>(model:C) ->S? where C: Encodable, S: Decodable{
//        TGDecoder.decode(T##type: Decodable.Protocol##Decodable.Protocol, param: T##[String : Any])
        let dict:[String:Any]? = TGDecoder.conventModelToDict(model: model)
        //注意：此处得到的字典key数 和结构体属性个数不一致也会转换失败.
        if dict == nil {
            print("dict is nil.!")
            return nil
        }
        //将字典转结构体
        return TGDecoder.decode(S.self, param: dict!)
//        return try? JSONModel(STUDENT.self, withKeyValues: dict!) as! S
    }
    //从一个实列赋值所有值到本实列 被搜索的内需要加上 艾特objcMembers
   public static func copyValueFor<C:NSObject>(_ destModel:C,_ fromModel:C,_ blackList:[String]){
        let propertyNames:[String] = self.getAllpropertyList(C.self)
        for item in propertyNames {
            if blackList.contains(item) {
                //黑名单属性不copy
                continue
            }
            let value = fromModel.value(forKey: item)//取出值
//            LLog(TAG: TAG(self), "复制的key=\(item) value=:\(String(describing: value))");
            if value == nil {
//                print("value is nil. key=\(item)")
                continue
            }
            destModel.setValue(value!, forKey: item)
        }
    }
    
    
    ///获取当前类所有的属性数组
    public class  func getPropertyListFor(_ cls: AnyClass) -> [String] {
        self.getPropertyListFor(cls, blackList: [])
      }
    //获取当前类的属性除了黑名单以为
    class  func getPropertyListFor(_ cls: AnyClass,blackList:[String]) -> [String] {
       var count :UInt32 = 0
       //获取‘类’的属性列表
      let list = class_copyPropertyList(cls, &count)
//      print("\(NSStringFromClass(cls)) 属性的数量\(count)")
       var names:[String] = []
       for i in 0..<Int(count) {
           //根据下标 获取属性
           let a = list?[i]
           //获取属性的名称
           let cName = property_getName(a!)
           let n = String(utf8String:cName)
           if n == nil {
               print("name is nil. \(cName)")
               continue
           }
//           print("runtime name=\(n!)")
        if blackList.contains(n!) {
            //黑名单属性不添加
//            print("blak Property:\(String(describing: n))")
            continue
        }
           names.append(n!)
           
       }
      free(list)
        return names
    }
    
     public class func getAllpropertyList(_ cls: AnyClass?) -> [String] {
          //获取自身的所有属性名
        var names:[String] = []
          //获取父类的
          var myfather: AnyClass? = cls
          while myfather != nil {
              if myfather == NSObject.classForCoder() {
                  //如果是NSObject属性了 则退出
//                  print("it is nsobject.")
                  break
              }
              let array = self.getPropertyListFor(myfather!)
              names.append(contentsOf: array)
              myfather = myfather!.superclass()
              
          }
          return names
      }
    
//   static func JSONModel<T>(_ type: T.Type, withKeyValues data:[String:Any]) throws -> T where T: Decodable {
//        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
//        let model = try JSONDecoder().decode(type, from: jsonData)
//        return model
//    }
}



//字典和结构体互转
public struct TGDecoder {
    
    //字典转结构体
    public static func decode<T>(_ type: T.Type, param: [String:Any]) -> T? where T:Decodable{
        guard let jsonData = self.getJsonData(with: param) else {
            return nil
        }
        guard let model = try? JSONDecoder().decode(type, from: jsonData) else {
            return nil
        }
        return model
    }
    
    
    //将对象转为字符串
    public static func encoder<T>(toString model: T) ->String? where T: Encodable{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else{
            return nil
        }
        guard let jsonStr = String(data: data, encoding:  .utf8) else {
            return nil
        }
        return jsonStr
    }
    //将对象T转为字典  如果对象有继承其它类则会存在缺失
    public static func encoder<T>(toDictionary model: T) ->[String:Any]? where T: Encodable{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else{
                   return nil
               }
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String:Any] else{
            return nil
        }
        return dict
    }
    //模型转字典 模型可以继承父类
   public static func conventModelToDict(model:NSObject) -> [String:Any] {
    var dict:[String:Any] = [:]
    //将属性值copy到字典
    let propertyNames:[String] = TGRunTimeUtil.getAllpropertyList(model.classForCoder)
    for item in propertyNames {
        let value = model.value(forKey: item)
        if value == nil {
//            print("value is nil. key=\(item)")
            continue
        }
        dict[item] = value
    }
        return dict
    }
    
    
    
    private static func getJsonData(with param:Any)->Data?{
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        guard let data = try?JSONSerialization.data(withJSONObject: param, options: [])else{
            
              return nil
        }
        return data
    }
    
}
