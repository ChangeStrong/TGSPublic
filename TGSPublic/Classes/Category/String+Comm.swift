//
//  String+Comm.swift
//  SwiftFrameworkDemo
//
//  Created by gleeeli on 2020/8/3.
//  Copyright © 2020 GL. All rights reserved.
//

import Foundation
let KUrlCodingReservedCharacters = "!*'();:|@&=+$,/?%#[]{}"
public extension String{
    /// url编码
    ///
    /// - Returns: NSString
    func urlEncode() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: KUrlCodingReservedCharacters).inverted)
        
    }
    
   
    
    func urlEncodeOnlyUTF8() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "").inverted)! 
        
    }
    func urlEncodeForKF() -> String {
        guard let encodedPath = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            LLog(TAG: TAG(self), "URL encoding failed.!! path=\(self)");
            return self
        }
        return encodedPath
    }
    //将链接替换为文件名
    func replaceUrlToFileName() -> String {
//        let filename = self.replacingOccurrences(of: "/\\:*?\"<>|", with: "_")
        let filename = self.replacingOccurrences(of: "[^a-zA-Z0-9._]", with: "_", options: .regularExpression)
        return filename;
    }
    
    /// url解码
    ///
    /// - Returns: NSString
    func urlDecode() -> NSString? {
        return self.removingPercentEncoding as NSString?
    }
    
    //GBK()转UTF16字符串
    //let gbkData = text.data(using: String.Encoding.isoLatin1)
  static func conventGBKToUTF16(_ gbkData:Data) -> String? {
        //获取GBK编码, 使用GB18030是因为它向下兼容GBK
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding2 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
        //从GBK编码的Data里初始化NSString, 返回的NSString是UTF-16编码(即OC默认的编码)
        if let str = NSString(data: gbkData, encoding: encoding2) {
           return str as String
        } else {
            LLog(TAG: TAG(self), "gbk to utf16 failture.!");
            return nil
        }
    }
    
    static func isNull(str:String?) -> Bool {
        if str == nil {
            return true
        }
        if str!.isEmpty {
            return true;
        }
        if str == "<null>" {
            return true;
        }
        return false;
    }
    
    func appendingPathComponent2(_ temp:String) -> String {
        return self + "/" + temp;
    }
    //移除首个目录
    func removeFirstComponent2() -> String? {
        var temps = self.split(separator: "/")
        
        if temps.count == 0 {
            LLog(TAG: TAG(self), "not contain any other character.!");
            return nil
        }
        temps.removeFirst();
        let tempStr =  temps.joined(separator: "/")
          return tempStr;
    }
    
    func removeLastComponent2() -> String? {
        var temps = self.split(separator: "/")
        if temps.count == 0 {
            LLog(TAG: TAG(self), "not contain any other character.!");
            return nil
        }
        temps.removeLast();
        var tempStr =  temps.joined(separator: "/")
        if self.hasPrefix("/") && tempStr.hasPrefix("/")==false{
            //解决路径最前面是/问题
            tempStr = "/"+tempStr;
        }
     
        return tempStr;
    }
    //获取路径最后的 文件名或者文件夹名
    func fetchLastComponent2() -> String {
        let temps = self.split(separator: "/")
        if temps.count == 0 {
            LLog(TAG: TAG(self), "not contain any other character.!");
            return self
        }
        return String(temps.last!);
    }
    
    func fetchFirstComponent2() -> String? {
        var temps = self.split(separator: "/")
        if temps.count == 0 {
            LLog(TAG: TAG(self), "not contain any other character.!");
            return nil
        }
       return String(temps.first!)
    }
    
    func fetchFileSuffix() -> String {
        let tempStr:String = self.fetchLastComponent2();
        if tempStr.contains(".") == false {
            return ""
        }
        let array2 = tempStr.split(separator: ".")
        if array2.count == 0 {
            //是文件夹没有.
            return "";
        }
        return "\(array2.last!)"
    }
    
    /**
          匹配字符串中所有的URL
          */
      func  getUrls() -> [ String ] {
             var  urls = [ String ]()
             // 创建一个正则表达式对象
             do {
                 let  dataDetector = try  NSDataDetector (types:
                                                            NSTextCheckingTypes ( NSTextCheckingResult.CheckingType . link .rawValue))
                 // 匹配字符串，返回结果集
                 let  res = dataDetector.matches(in: self,
                                                 options:  NSRegularExpression.MatchingOptions (rawValue: 0),
                     range:  NSMakeRange (0, self.count))
                 // 取出结果
                 for  checkingRes  in  res {
                     urls.append((self  as  NSString ).substring(with: checkingRes.range))
                 }
             }
             catch {
                 print (error)
             }
             return  urls
         }
    
    //是否是纯Int类型数据
    static func isPurnInt(string: String) -> Bool {
           let scan: Scanner = Scanner(string: string)
           var val:Int = 0
           return scan.scanInt(&val) && scan.isAtEnd
    
       }
    //是否是纯数字
    func isNumeric() -> Bool {
        let pattern = "^[0-9]+$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            return !matches.isEmpty
        }
        return false
    }
    
    //包含数字
     func containsNumber() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[0-9].*", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    //将字符串中首先碰到的连续数字取出来
    static func extractFirstContinuousNumber(input: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: "[0-9]+", options: .caseInsensitive)
            if let match = regex.firstMatch(in: input, options: [], range: NSMakeRange(0, input.count)) {
                let range = Range(match.range, in: input)
                if let range = range {
                    return String(input[range])
                }
            }
        } catch {
            return nil
        }
        return nil
    }
    //只提取取中文和英文字符
    func filterChineseAndEnglishCharacters() -> String {
        // 定义一个正则表达式，匹配中文字符和英文字符
        let regexPattern = "([\\u4e00-\\u9fa5a-zA-Z0-9])"
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
        
        // 查找所有匹配项
        let nsString = self as NSString
        let results = regex.matches(in: self, range: NSRange.init(location: 0, length: nsString.length))
        
        // 提取匹配项并构建结果字符串
        var resultString = ""
        for result in results {
            let range = result.range
            let substring = nsString.substring(with: range)
            resultString.append(substring)
        }
        
        return resultString
    }
    //提取字符串中从遇到的第一个中文或英文字符开始，并移除末尾非中文或英文的所有字符,并且保留数字
    func filterChineseAndEnglishCharacters2() -> String {
        // 定义一个正则表达式模式，匹配中文、英文字符和数字
        let validCharacterPattern = "[\\u4e00-\\u9fa5a-zA-Z0-9]"
        
        // 将输入字符串转换为字符数组，方便逐字符处理
        var characters = Array(self)
        var startIndex: Int? = nil
        var endIndex: Int? = nil
        
        // 找到第一个有效字符的位置（中文、英文或数字）
        for (index, char) in characters.enumerated() {
            if String(char).range(of: validCharacterPattern, options: .regularExpression) != nil {
                startIndex = index
                break
            }
        }
        
        // 如果没有找到任何有效字符，返回空字符串
        guard let validStartIndex = startIndex else {
//            var   tempStr = self
//            if self.count > 50 {
//                //名字过长只取前五十个
//                tempStr = String(self[self.startIndex..<self.index(self.startIndex, offsetBy: 50)])
//            }
//            //移除空格这些
//            tempStr = tempStr.trimmingCharacters(in: .whitespacesAndNewlines)
            return self
        }
        
        // 从字符串末尾开始，找到最后一个有效字符的位置
        for i in stride(from: characters.count - 1, through: validStartIndex, by: -1) {
            if String(characters[i]).range(of: validCharacterPattern, options: .regularExpression) != nil {
                endIndex = i
                break
            }
        }
        
        // 如果没有有效的结束位置，说明字符串中只有一个有效字符
        let validEndIndex = endIndex ?? validStartIndex
        
        // 提取有效子字符串
        let result = String(characters[validStartIndex...validEndIndex])
        return result
    }
    //移除不兼容iOS和安卓的文件命名字符
    func sanitizeFileNameCrossPlatform() -> String {
        // 定义跨平台非法字符集合
        let invalidCharacters = CharacterSet(charactersIn: "/\\?%*|\"<>:")
        
        // 移除非法字符
        let sanitizedString = self
            .components(separatedBy: invalidCharacters)
            .joined()
        
        // 去掉首尾空白字符
        return sanitizedString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //此方法会保留空格和图片占位符号
    func fetchFirstLineStr2() -> String {
        var tempStr = self.replacingOccurrences(of: "￼", with: "") // 移除其中的图片占位符
        
        // 将字符串按换行符分割成数组
        let lines = tempStr.components(separatedBy: .newlines)
        
        var firstLine: String = ""
        var foundVisibleCharacter = false
        
        for tempStr in lines {
            // 去除首尾的空白字符-和不兼容iOS和安卓文件命名的字符
            let  line = tempStr.sanitizeFileNameCrossPlatform()
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
             
            // 检查是否有可见字符
            if !trimmedLine.isEmpty {
                // 找到第一个包含可见字符的行
                firstLine = line
                
                
                // 从第一个可见字符开始保留原始字符串（包括后续的空格）
                var startIndex: String.Index?
                for (index, char) in line.enumerated() {
                    if !char.isWhitespace {
                        startIndex = line.index(line.startIndex, offsetBy: index)
                        break
                    }
                }
                
                if let startIndex = startIndex {
                    firstLine = String(line[startIndex...])
                }
                
                foundVisibleCharacter = true
                break // 找到包含可见字符的行，跳出循环
            }
        }
        
        // 如果没有找到任何可见字符的行，则处理整个字符串
        if !foundVisibleCharacter {
            if tempStr.count > 50 {
                // 名字过长只取前五十个字符
                tempStr = String(tempStr[tempStr.startIndex..<tempStr.index(tempStr.startIndex, offsetBy: 50)])
            }
            
            // 去除首尾的空白字符
            tempStr = tempStr.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if tempStr.isEmpty {
                tempStr = "unkhow"
            }
            
            return tempStr
        }
        
        // 返回找到的第一行（保留了第一个可见字符及其后的所有内容，包括空格）
        return firstLine
    }
    
}

public extension String {
    func toNSRange(_ range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
    }
    
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
    
    //提取前几个文字 ，这个字符串可能是中文、英文或者日文 。 这两个文字不能是特殊字符 ，如果是英文的话， 提取前两个单词的首字母 ，如果没有两个单词那就提取一个单词 ，且这个单词如果长度超过两个也只取这个单词的前两个字母
    func extractFirstTwoCharacters(count:Int) -> String {
        // 使用正则表达式匹配中文、英文、和日文字符
        let regex = try! NSRegularExpression(pattern: "([\\p{Script=Hani}\\p{Script=Hira}\\p{Script=Kana}]+|[A-Za-z]+)", options: [])
        let matches = regex.matches(in: self, options: [], range: NSRange(self.startIndex..., in: self))
        
        var extractedText = ""
        
        for match in matches.prefix(count) {
            if let range = Range(match.range, in: self) {
                let text = String(self[range])
                // 提取字符的前两个字母
                let firstTwoCharacters = String(text.prefix(count))
                extractedText += firstTwoCharacters
            }
            break
        }
        
        if extractedText.isEmpty {
            // 如果没有匹配到字符，则提取输入字符串的前两个字符
            extractedText = String(self.prefix(count))
        }
        
        return extractedText
    }
}
