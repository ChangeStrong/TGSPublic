//
//  WebUtil.swift
//  Yeast
//
//  Created by luo luo on 2024/3/19.
//

import Foundation
import WebKit
extension WKWebsiteDataStore {
    class func defaultDataStoreConfiguration() -> WKWebsiteDataStore {
        let config = WKWebViewConfiguration()
        return config.websiteDataStore
    }
}

public class WebUtil{
    
    public static   func clearWKWebViewCache() {
        //清除所有数据包括cookie那些
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { recodes in
            for item in recodes {
                WKWebsiteDataStore.default().removeData(ofTypes: item.dataTypes , modifiedSince: Date.distantPast) {
                    print("Cache cleared")
                }
            }
        }
//        let websiteDataTypes =  WKWebsiteDataStore.allWebsiteDataTypes()
    }

    //清除所有cookie
    func clearWKWebViewCookies() {
        let cookieStore = WKWebsiteDataStore.default().httpCookieStore
        cookieStore.getAllCookies { cookies in
            for cookie in cookies {
                cookieStore.delete(cookie, completionHandler: nil)
            }
        }
    }

    
    //清除指定域名的缓存 baidu.com
    public static  func clearWKWebViewCache(forDomain domain: String) {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let dataStore = WKWebsiteDataStore.defaultDataStoreConfiguration()

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: websiteDataTypes as! Set<String>) { records in
            for record in records {
                if record.displayName.contains(domain) {
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                        print("Cache cleared for \(record.displayName)")
                    })
                }
            }
        }
    }

    
    public static  func extractFilename(_ contentDisposition: String) -> String? {
        // 尝试从 filename*=UTF-8''... 格式中提取文件名
        if let utf8Filename = extractFilenameFromRFC5987(contentDisposition: contentDisposition) {
            return utf8Filename
        }

        // 如果无法从 filename*=UTF-8''... 格式中提取文件名，则尝试从 filename="..." 格式中提取
        if let normalFilename = extractFilenameFromRegular(contentDisposition: contentDisposition) {
            return normalFilename
        }

        // 未能提取到文件名
        return nil
    }

    // 解析 filename*=UTF-8''... 格式的文件名
    static func extractFilenameFromRFC5987(contentDisposition: String) -> String? {
        guard let charsetPrefixRange = contentDisposition.range(of: "filename\\*=(.*?)'.*?'", options: .regularExpression),
              let filenamePrefixRange = contentDisposition.range(of: "'", range: charsetPrefixRange.upperBound..<contentDisposition.endIndex),
              let filenameSuffixRange = contentDisposition.range(of: "'", range: filenamePrefixRange.upperBound..<contentDisposition.endIndex)
        else {
            return nil
        }

        let charsetRange = charsetPrefixRange.lowerBound..<filenamePrefixRange.lowerBound
        let filenameRange = filenamePrefixRange.upperBound..<filenameSuffixRange.lowerBound
        let charsetString = String(contentDisposition[charsetRange])
        
        guard
              let filenameEncodedString = String(contentDisposition[filenameRange]).removingPercentEncoding,
              let filenameData = filenameEncodedString.data(using: .utf8),
              let filename = String(data: filenameData, encoding: .utf8)
        else {
            return nil
        }

        return filename
    }

    // 解析 filename="..." 格式的文件名
    static func extractFilenameFromRegular(contentDisposition: String) -> String? {
        let pattern = "filename=\"([^\"]+)\""
        let regex = try! NSRegularExpression(pattern: pattern)
        if let match = regex.firstMatch(in: contentDisposition, range: NSRange(contentDisposition.startIndex..., in: contentDisposition)) {
            let range = Range(match.range(at: 1), in: contentDisposition)!
            return String(contentDisposition[range])
        }
        return nil
    }
}
