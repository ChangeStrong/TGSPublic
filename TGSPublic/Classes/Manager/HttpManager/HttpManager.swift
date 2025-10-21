//
//  HttpManager.swift
//  ComicChatSwift
//
//  Created by luo luo on 2020/4/20.
//  Copyright © 2020 GL. All rights reserved.
//

import Foundation
import Moya

public var TGHttpBaseUrlPath = "http://116.62.172.2:80/"
public var TGHttpBaseDomainUrlPath = "http://yeast.plus:80/"
public var TGPlatformatType:Int = 16;//平台类型 16 - 酵母菌 40- 写诗助手 60-场景英语
public var TGUploadFileBasseAdressType:Int = 16//默认酵母菌国内
public func TGGetHttpBaseUrl() -> String {
    if TGAppEnviroment == 0 {
        return "http://127.0.0.1:8888/Comic/"
//        return "http://192.168.83.97:8888/Comic/"
    }
        return TGHttpBaseUrlPath
}

public func TGGetUploadFileBasseAdressType() -> Int {
//    if TGUserManager.share().jugementIsAbroad() == true {
//        //国外
//        return 13;
//    }else{
        //酵母菌国内
//        return 16;
//    }
    //目前文件存到火漫社里面吧
//    return 40;
    return TGUploadFileBasseAdressType;
}
public func TGGetQiniuDomainBaseUrl() -> String{
    switch TGGetUploadFileBasseAdressType() {
    case 16:
        return "http://guangdong.yeast.plus/";
//        break
    case 40:
        //
        return "http://hotcommunity.yeast.plus/";
    case 60:
        //
        return "http://hotcommunity.yeast.plus/";
//        break
    default:
        break
    }
    return "";
}

//使用域名的方式--分享链接需要
public func TGGetHttpDomainUrl() -> String {
    if TGAppEnviroment == 0 {
        return TGGetHttpBaseUrl();
    }
    return TGHttpBaseDomainUrlPath
}

public func TGFetchDefaultHeadUrl() -> String {
    return TGGetHttpBaseUrl() + "resources/images/defaultAdminHead.png";
}

public func TGFetchTutorialUrl() ->String{
    var tempUrl =  TGGetHttpBaseUrl() + "views/protocol/";
     switch TGGlobal.currentLanguage() {
     case .chinese:
         tempUrl += "tutorial/tutorial_zh.html"
         break
     case .english:
         tempUrl += "tutorial/tutorial_en.html"
         break
     case .russian:
         tempUrl += "tutorial/tutorial_ru.html"
         break
     case .korean:
         tempUrl += "tutorial/tutorial_ko.html"
         break
     case .japanese:
         tempUrl += "tutorial/tutorial_ja.html"
         break
     case .spanish:
         tempUrl += "tutorial/tutorial_es.html"
         break
     case .spanishLa:
         tempUrl += "tutorial/tutorial_la.html"
         break
     case .chineseTraditional:
         tempUrl += "tutorial/tutorial_zh.html"
     default:
         tempUrl += "tutorial/tutorial_en.html"
     break
     }
   
    return tempUrl
}

public func TGFetchProtocolPrivateUrl() ->String{
    var tempUrl =  TGGetHttpBaseUrl() + "views/protocol/";
    if TGPlatformatType == 60 {
        tempUrl += "sceneenglish/"
//        tempUrl += "private/private_en.html"
//        return tempUrl
    }
     switch TGGlobal.currentLanguage() {
     case .chinese:
         tempUrl += "private/private_zh.html"
         break
     case .english:
         tempUrl += "private/private_en.html"
         break
     case .russian:
         tempUrl += "private/private_ru.html"
         break
     case .korean:
         tempUrl += "private/private_ko.html"
         break
     case .japanese:
         tempUrl += "private/private_ja.html"
         break
     case .spanish:
         tempUrl += "private/private_es.html"
         break
     case .spanishLa:
         tempUrl += "private/private_la.html"
         break
     case .chineseTraditional:
         tempUrl += "private/private_zh_tr.html"
     case .italian:
         tempUrl += "private/private_it.html"
         break
     case .vietnamese:
         tempUrl += "private/private_vi.html"
         break
     case .thai:
         tempUrl += "private/private_thai.html"
         break
     case .hindi:
         tempUrl += "private/private_hi.html"
         break
//     default:
//         tempUrl += "private/private_en.html"
//         break
     }
    
    return tempUrl
}

public func TGFetchProtocolServiceUrl() ->String{
    var tempUrl =  TGGetHttpBaseUrl() + "views/protocol/";
    if TGPlatformatType == 60 {
        tempUrl += "sceneenglish/"
//        tempUrl += "service/service_en.html"
//        return tempUrl
    }
     switch TGGlobal.currentLanguage() {
     case .chinese:
         tempUrl += "service/service_zh.html"
         break
     case .english:
         tempUrl += "service/service_en.html"
         break
     case .russian:
         tempUrl += "service/service_ru.html"
         break
     case .korean:
         tempUrl += "service/service_ko.html"
         break
     case .japanese:
         tempUrl += "service/service_ja.html"
         break
     case .spanish:
         tempUrl += "service/service_es.html"
         break
     case .spanishLa:
         tempUrl += "service/service_la.html"
         break
     case .italian:
         tempUrl += "service/service_it.html"
         break
     case .chineseTraditional:
         tempUrl += "service/service_zh_tr.html"
         break
//     default:
//         break
     case .vietnamese:
         tempUrl += "service/service_vi.html"
     case .thai:
         tempUrl += "service/service_thai.html"
     case .hindi:
         tempUrl += "service/service_hi.html"
     }
    return tempUrl
}

public func TGFetchProtocolspecificationUrl() ->String{
    var tempUrl =  TGGetHttpBaseUrl() + "views/protocol/";
     switch TGGlobal.currentLanguage() {
     case .chinese:
         tempUrl += "specification/specification_zh.html"
         break
     case .english:
         tempUrl += "specification/specification_en.html"
         break
     case .russian:
         tempUrl += "specification/specification_ru.html"
         break
     case .korean:
         tempUrl += "specification/specification_ko.html"
         break
     case .japanese:
         tempUrl += "specification/specification_ja.html"
         break
     case .spanish:
         tempUrl += "specification/specification_es.html"
         break
     case .spanishLa:
         tempUrl += "specification/specification_la.html"
         break
     default:
         break
     }
    return tempUrl
}


public enum HttpAPIManager{
    case DownloadFullAddress(Dictionary<String, Any>) // 添加游客
    case GetHomeDetail(Int)  // 获取详情页
    case PostMethod1(Dictionary<String, Any>) //根据关键字搜索
    case getCityInfo1
    case getCityInfo2
    case CommonFullUrl(Dictionary<String, Any>) // 通用普通请求
}
//提供给外部组件重新设置请求头
public var TGHttpHeadersDict:[String : String]?
extension HttpAPIManager: TargetType {
   
    public var headers: [String : String]? {
        var dict0:[String:String] = [:]
        
        switch self {
        case .CommonFullUrl(let dict):
            if let tempHeader = dict["mHeaders"] as? Dictionary<String,String> {
                //外部有传
                return tempHeader;
            }
            break
        default:
            if TGHttpHeadersDict != nil {
                //外部组件有重新设置请求头
                return TGHttpHeadersDict
            }
            if TGGlobal.isMac() {
                dict0["platform"] = "mac";
            }else{
                dict0["platform"] = "iOS";
            }
            dict0["deviceType"] = TGGlobal.deviceType()
            var temp = "en"
            if let preferredLanguage = Locale.preferredLanguages.first {
                temp = preferredLanguage;
            }
            dict0["deviceLanguage"] = temp
            return dict0
//            break
        }

        
        return dict0
    }
    
    /// The target's base `URL`.
    public var baseURL: URL {
        switch self {
        case .getCityInfo1:
            return URL.init(string: "http://ip-api.com")!
        case .getCityInfo2:
            return URL.init(string: "https://extreme-ip-lookup.com")!
        case .DownloadFullAddress(let dict):
            let tempStr:String = dict["mUrl"] as! String
            let temp:String = tempStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
            return URL.init(string: temp)!
        case .CommonFullUrl(let dict):
            let tempStr:String = dict["mUrl"] as! String
            let temp:String = tempStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
            return URL.init(string: temp)!
        default:
            return URL.init(string: TGGetHttpBaseUrl())!
        }
        
    }
    /// The path to be appended to `baseURL` to form the full `URL`.
    public var path: String {
        switch self {
        case .getCityInfo1:
            return "json/";
        case .getCityInfo2:
            return "json/";
        case .DownloadFullAddress( _): // 不带参数的请求
            return ""
        case .CommonFullUrl(_): //无需追加路径了
            return ""
        case .GetHomeDetail(let id):  // 带参数的请求
            return "4/theme/\(id)"
        case .PostMethod1(let dict):
            return dict["mUrl"] as! String
        }
       
    }
// 区分get 和 post
    public var method: Moya.Method {
        switch self {
        case .getCityInfo1:
            return .get;
        case .getCityInfo2:
            return .get;
        case .DownloadFullAddress( _): // 不带参数的请求
            return .get
        case .CommonFullUrl(let  dict): // 不带参数的请求
            if let tempMethod = dict["mMethod"] as? String,tempMethod == "post" {
                return .post;
            }
            return .get
        case .GetHomeDetail(let id):  // 带参数的请求
            return .post
        case .PostMethod1( _):
            return .post
        }
    }

    /// The parameters to be incoded in the request.
//    var parameters: [String: Any]? {
//
//
//    }
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    /// Provides stub data for use in testing.
    public var sampleData: Data {
        switch self {
        case .DownloadFullAddress(_):
            //{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}
            return "{}".data(using: String.Encoding.utf8)!
        case .GetHomeDetail(_):
            return "Create post successfully".data(using: String.Encoding.utf8)!
        default:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
    /// The type of HTTP task to be performed.
    public var task: Task {
        switch self {
        case .DownloadFullAddress( _):
//            if self.params.isEmpty {
                
//                return .downloadDestination(downloadDestination)
//            }
            return .downloadParameters(parameters: self.params, encoding: URLEncoding.default, destination: downloadDestination)
         case .GetHomeDetail( _):
              return .requestPlain
        case .getCityInfo1:
            return .requestPlain;
        case .getCityInfo2:
            return .requestPlain;
        case .CommonFullUrl(let dict):
            if let tempMethod = dict["mMethod"] as? String,tempMethod == "post",
               let foramt = dict["mRequestBodyFormat"] as? String,foramt == "json"{
                //以json格式发送body
                let bodyStr = TGGlobal.getJSONStringFrom(obj: self.params)
                let bodyData:Data = bodyStr.data(using: .utf8) ?? Data();
                return .requestCompositeData(bodyData: bodyData, urlParameters: [:])
            }
            return .requestPlain;
        default:
            return .requestParameters(parameters: self.params, encoding: URLEncoding.default)
         }
       
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool {
        return false
    }
    
    // MARK: 非官方需要数据
    public var params:[String: Any]{
        var params: [String: Any] = [:]
        //添加公共参数
        
        switch self {
        case .DownloadFullAddress(let dict):
            params.merge(dict: dict)
            break;
        case .CommonFullUrl(let dict):
            params.merge(dict: dict)
            if params.keys.contains("mUrl") {
                params.removeValue(forKey: "mUrl")
            }
            if params.keys.contains("mMethod") {
                params.removeValue(forKey: "mMethod")
            }
            if params.keys.contains("mHeaders") {
                params.removeValue(forKey: "mHeaders")
            }
            if params.keys.contains("mRequestBodyFormat") {
                params.removeValue(forKey: "mRequestBodyFormat")
            }
            break;
        case .GetHomeDetail( _):
            return params
        case .PostMethod1(let dict):
            params.merge(dict: dict)
            params.removeValue(forKey: "mUrl")//移除传入的链接
            //判断是否需要加密
            if params["mNeedEncrytParam"] != nil {
                let jsonStr:String = TGGlobal.getJSONStringFrom(obj: params)
                let encrytStr:String = TGAESUtil.encryptAESData(jsonStr);
                var params2: [String: Any] = [:]
                params2["encryParam"]=encrytStr;
                params = params2;
            }
            break;
            
        default:
            return params
        }
        
        return params
    }
    
    var localLocation: URL {
            switch self {
            case .DownloadFullAddress(let dict):
                //设置下载文件的保存路径
                let filePath: URL = URL.init(fileURLWithPath: dict["mDestinationPath"] as! String)
                return filePath
            default:
                let name = "\(Date.fetchCurrentSeconds())";
                return HttpAPIManager.getApplicationSupportURl().appendingPathComponent(name)
            }
        }
    
    var downloadDestination: DownloadDestination {
            // `createIntermediateDirectories` will create directories in file path
            return { _, _ in return (self.localLocation, [.removePreviousFile, .createIntermediateDirectories]) }
        }
    
    public static func getApplicationSupportURl() -> URL{
        //application support目录
        let applicationSupportURl:URL? = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        if applicationSupportURl == nil {
            LLog(TAG: TAG(self), "Not find applicationSupportDirectory.!!");
            return URL.init(fileURLWithPath: NSHomeDirectory())
        }
        return applicationSupportURl!;
    }
}

public extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}


public class Http{
    // 请求成功的回调
    public typealias successCallback = (_ result: Any?,_ pageVo:TGPaginationVo?,_ msg:String?,_ code:Int?) -> Void
    // 请求失败的回调
    public typealias failureCallback = (_ error: MoyaError) -> Void
    
    //进度
    public  typealias progressCallBack = (_ proResponse:ProgressResponse) ->Void
    public static var requestTimeOut:Double = 20;
    static let requestClosure = { (endpoint:Endpoint, done: @escaping MoyaProvider<HttpAPIManager>.RequestResultClosure) in

               do{
                   var request = try endpoint.urlRequest()
                   request.timeoutInterval = Http.requestTimeOut //设置请求超时时间
                   done(.success(request))

               }catch{
                   return
               }

           }
    // 单例
    static let provider = MoyaProvider<HttpAPIManager>(requestClosure: requestClosure)
    
    // 发送网络请求
    public static func request(
        target: HttpAPIManager,
        success: @escaping successCallback,
        failure: @escaping failureCallback
    ) {
        self.request(target: target, progress: nil, success: success, failure: failure)
        
    }
    //带进度条
    public static func request(
    target: HttpAPIManager,
    progress: progressCallBack? = nil,
    success: @escaping successCallback,
    failure: @escaping failureCallback){
        provider.request(target,progress: { (proResponse) in
            //打印进度
            if progress != nil{
                progress!(proResponse)
            }
            
        }) { result in
            //请求完成
            switch result {
            case let .success(moyaResponse):
                do {
                    
                    if moyaResponse.statusCode == 200 {
                        //响应成功
                        let json = try moyaResponse.mapJSON()
                        print("Http- success: Url:\(target.baseURL)\(target.path) headers:\(String(describing: target.headers)) params:\(target.params) result:\(json)")
                        //针对自己服务器写
                        if case .PostMethod1(_) = target {
                            //自己服务器的数据
                            if json is Dictionary<String, Any> == false {
                                let res:Response = Response.init(statusCode: -1, data: Data.init(), request: nil, response: nil);
                                let error:MoyaError = MoyaError.statusCode(res)
                                failure(error)
                                return;
                            }
                            let dict:Dictionary<String,Any> = json as! Dictionary<String, Any>;
                            let data:Any? = dict["data"];
                            let paginationVo:Dictionary<String,Any>? = dict["paginationVo"] as? Dictionary<String, Any>;
                            var pageModel:TGPaginationVo?
                            if paginationVo != nil {
                                pageModel = TGPaginationVo.deserialize(from: paginationVo)!
                            }
                            var message:String? = dict["message"] as? String;
                            var code:Int? = dict["code"] as? Int;
                            let isEny:Bool? = dict["isEny"] as? Bool;
                            if isEny != nil && isEny == true {
                                //解密
                                let encrytStr:String? = dict["enydata"] as? String;
                                if encrytStr == nil {
                                    success(nil,pageModel,message,code)
                                    return;
                                }
                                let jsonStr:String = TGAESUtil.decryptAESData(encrytStr!);
                                let decrytDict:Dictionary<String,Any>? = TGGlobal.getDictionaryFromJSONString(jsonString: jsonStr);
                                if decrytDict != nil {
                                    //是字典
                                    print("decrytDict=\(String(describing: decrytDict))")
                                    success(decrytDict,pageModel,message,code)
                                    return;
                                }
                                let decryArray:[Any]? = TGGlobal.getArrayFromJSONString(jsonString: jsonStr);
                                if decryArray != nil {
                                    //是数组
                                    print("decrytDict=\(String(describing: decrytDict))")
                                    success(decryArray,pageModel,message,code)
                                    return;
                                }
                                //可能就是字符串
                                print("decryStr=\(String(describing: jsonStr))")
                                success(jsonStr,pageModel,message,code)
                                return;
                            }
                            success(data,pageModel,message,code)
                            return
                        }
                        
                        
                        success(json,nil,"",0) // 测试用JSON数据
                    }else{
                        //响应出错
                        let data = String.init(data: moyaResponse.data, encoding: String.Encoding.utf8)
                        print("Http- failed1: Url:\(target.baseURL)\(target.path)  headers:\(String(describing: target.headers))  code:\(moyaResponse.statusCode) params:\(target.params) data:\(String(describing: data))");
                        let error:MoyaError = MoyaError.statusCode(moyaResponse)
                        failure(error)
                    }
                    
                } catch {
                    let data = String.init(data: moyaResponse.data, encoding: String.Encoding.utf8)
                    print("Http- success2: Url:\(target.baseURL)\(target.path)  headers:\(String(describing: target.headers)) params:\(target.params) code:\(moyaResponse.statusCode) error:\(error) data:\(String(describing: data))");
                    success(moyaResponse,nil,"",0)
                    
                }
            case let .failure(error):
                print("Http- failed3: Url:\(target.baseURL)\(target.path) headers:\(String(describing: target.headers)) params:\(target.params) error:\(error)");
                failure(error)
            }
        }
    }
    
    
    
    public static func requestDownload(
        target: HttpAPIManager,
        callbackQueue: DispatchQueue? = .main,
        progress: progressCallBack? = nil,
        success: @escaping successCallback,
        failure: @escaping failureCallback
    ) {
     _ = provider.requestNormal(
                        target,
                        callbackQueue: callbackQueue,
                        progress: { (ProgressResponse) in
                            //回调进度
                        progress!(ProgressResponse)
                    }) {  result in
                        
                        switch result {
                        case let .success(moyaResponse):
                            let data = moyaResponse.data
                            print("Http- success: Url:\(target.baseURL)\(target.path) headers:\(String(describing: target.headers)) params:\(target.params) result:\(data)")
                            if moyaResponse.statusCode == 200 {
                            }
                            success(result,nil,"",0)
                        case let .failure(error):
                            print("Http- failed3: Url:\(target.baseURL)\(target.path) headers:\(String(describing: target.headers)) params:\(target.params) error:\(error)");
                            failure(error)
                        }
                    }
        
//        provider.request(<#T##target: HttpAPIManager##HttpAPIManager#>, completion: <#T##Completion##Completion##(_ result: Result<Response, MoyaError>) -> Void#>)
        
    }
    
    
}
