//
//  String+localized.swift
//  SwiftFrameworkDemo
//
//  Created by mac on 2020/7/6.
//  Copyright © 2020 GL. All rights reserved.
//

import Foundation
public extension String{
    var localized: String {
           return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
       }
       
       func localized(withComment:String) -> String {
           return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
       }
       
       func localized(tableName: String) -> String{
           return NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
       }
    //探测语言en zh-Hans ja
    func detectLanguage() -> String {
        let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
        tagger.string = self

        let detectedLanguage = tagger.dominantLanguage ?? "zh-Hans"
        // 返回 BCP-47 格式的语言代码字符串，如果无法检测语言，则默认为简体中文

        return detectedLanguage
    }
}
