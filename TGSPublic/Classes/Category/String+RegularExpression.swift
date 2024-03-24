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
    
    func isLink() -> Bool {
        let urlRegex = "^(http|https)://[a-zA-Z0-9\\.-]+\\.[a-zA-Z]{2,4}(:[0-9]{1,5})?(/.*)?$"
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlRegex)
        return urlPredicate.evaluate(with: self)
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
    
}
