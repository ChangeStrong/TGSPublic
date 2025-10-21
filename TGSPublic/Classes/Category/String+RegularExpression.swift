//
//  String+RegularExpression.swift
//  SwiftDevelopFramework
//
//  Created by gleeeli on 2020/3/29.
//  Copyright © 2020 GL. All rights reserved.
//

import Foundation

public extension String {
    /// 通过正则表达式匹配替换
    func replacingStringOfRegularExpression(pattern: String, template: String) -> String {
        var content = self
        do {
            let range = NSRange(location: 0, length: content.count)
            let expression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            content = expression.stringByReplacingMatches(in: content, options: .reportCompletion, range: range, withTemplate: template)
        } catch {
            print("regular expression error")
        }
        return content
    }
    
    /// 通过正则表达式匹配返回结果
    func matches(pattern: String) -> [NSTextCheckingResult] {
        do {
            let range = NSRange(location: 0, length: count)
            let expression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matchResults = expression.matches(in: self, options: .reportCompletion, range: range)
            return matchResults
        } catch {
            print("regular expression error")
        }
        return []
    }
    
    /// 通过正则表达式返回第一个匹配结果
    func firstMatch(pattern: String) -> NSTextCheckingResult? {
        do {
            let range = NSRange(location: 0, length: count)
            let expression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let match = expression.firstMatch(in: self, options: .reportCompletion, range: range)
            return match
            
        } catch {
            print("regular expression error")
        }
        return nil
    }
    /*
    func isLink() -> Bool {
        let urlRegex = "^(http|https)://[a-zA-Z0-9\\.-]+\\.[a-zA-Z]{2,4}(:[0-9]{1,5})?(/.*)?$"
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegex)
        return urlPredicate.evaluate(with: self)
    } */
    
    func isLink() -> Bool {
        guard let url = URL(string: self) else { return false }
        // 检查是否有 http 或 https scheme
        return ["http", "https"].contains(url.scheme?.lowercased())
    }
    //https://www.example.com 或者 example.com 也算对
    func isValidURL() -> Bool {
        let regexPattern = #"^(http(s)?:\/\/)?(www\.)?[a-zA-Z0-9_-]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?.*$"#
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: []) else {
            return false
        }
        
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    //提取域名 比如:http://www.baidu.com
    func extractDomain() -> String {
        guard let url = URL(string: self) else { return "" }
        return "\(url.scheme ?? "")://\(url.host ?? "")"
    }
    
   //提取链接中的参数
    static func fetchUrlParam(_ param: String?, url: String?) -> String? {
           let regTags = "(^|&|\\?)+\(param ?? "")=+([^&]*)(&|$)"
           var regex: NSRegularExpression? = nil
           do {
               regex = try NSRegularExpression(
                   pattern: regTags,
                   options: .caseInsensitive)
           } catch {
           }
           // 执行匹配的过程
           let matches = regex?.matches(
               in: url ?? "",
               options: [],
               range: NSRange(location: 0, length: url?.count ?? 0))
           for match in matches ?? [] {
               return (url as NSString?)?.substring(with: match.range(at: 2))
           }
           return nil
       }
    
    func isValidHexColor() -> Bool {
        let hexColorPattern = "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{7})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", hexColorPattern)
        return predicate.evaluate(with: self)
    }
    
    // 判断字符串是否包含中文的函数
    func containsChinese() -> Bool {
        do {
                let regex = try NSRegularExpression(pattern: "[\\u4e00-\\u9fff]+", options: .caseInsensitive)
                let range = NSRange(location: 0, length: self.utf16.count)
                let matches = regex.matches(in: self, options: [], range: range)
                return !matches.isEmpty
            } catch {
                print("Error creating regex: \(error.localizedDescription)")
                return false
            }
    }
    ///获取三个大括号中的内容{{{xxx}}}
    func fetchContentOfThreeBrace2() -> String {
        let text = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let pattern = #"\{{3}(.*?)\}{3}"#
        
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)
            
            if let match = regex.firstMatch(in: text, range: nsRange),
               let range = Range(match.range(at: 1), in: text) {
                return String(text[range])
            }
        } catch {
            print("正则表达式失败: \(error.localizedDescription)")
        }
        
        // 备用方案
        if let startRange = text.range(of: "{{{"),
           let endRange = text.range(of: "}}}") {
            return String(text[startRange.upperBound..<endRange.lowerBound])
        }
        
        return ""
    }
    func fetchContentOfThreeBrace() -> String {
        let text  = self.replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
        // 创建一个正则表达式来匹配被三个大括号包围的文本
        let pattern = #"\{\{\{(.*?)\}\}\}"#
        do {
            // 编译正则表达式
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            // 定义搜索范围为整个字符串
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)
            
            // 查找所有匹配项
            let matches = regex.matches(in: text, options: [], range: nsRange)
            
            // 遍历所有匹配项并打印结果
            for match in matches {
                if let range = Range(match.range(at: 1), in: text) {
                    let matchedText = text[range]
//                    print("正则匹配到的总结文字是：\(matchedText)")
                    return "\(matchedText)"
                }
            }
            
            if let range = text.range(of: "{{{"),let range2 = text.range(of: "}}}") {
                let  tempStr2 = String(text[range.upperBound..<range2.lowerBound])
                print("正则未获取到 fetch by handle is \(String(tempStr2))")
                return tempStr2;
            }else{
                print("正则未匹配到的三个大括号 matches是：\(matches)")
            }
        } catch let error {
            print("正则表达式失败: \(error.localizedDescription)")
        }
        return ""
    }
    
    //获取三个大括号外的所有字符
    func fetchExtractOutsideBraces() -> String {
        // 正则匹配 {{{...}}}
        let pattern = "\\{\\{\\{.*?\\}\\}\\}"
        
        // 创建正则表达式
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return self
        }
        
        let nsRange = NSRange(location: 0, length: self.utf16.count)
        
        // 找到所有 {{{...}}} 的范围
        let matches = regex.matches(in: self, options: [], range: nsRange)
        
        // 将原字符串转为 NSString 方便截取
        let nsInput = self as NSString
        
        var result = ""
        var lastIndex = 0
        
        for match in matches {
            // 取出匹配前的部分
            if match.range.location > lastIndex {
                let substring = nsInput.substring(with: NSRange(location: lastIndex, length: match.range.location - lastIndex))
                result += substring
            }
            // 更新位置
            lastIndex = match.range.location + match.range.length
        }
        
        // 添加最后一个 }}} 后面的部分
        if lastIndex < self.count {
            result += nsInput.substring(from: lastIndex)
        }
        
        return result
    }
    
    
}
