//
//  Extension+module.swift
//  TGSPublic
//
//  Created by luo luo on 2024/2/15.
//

import Foundation

extension String{
    class NoUse {}
    static func bundleForModule() -> Bundle{
        let resourceBundle = Bundle(path: Bundle(for: NoUse.self).path(forResource: "TGSPublic", ofType: "bundle") ?? "")
        return resourceBundle!;
    }
    
    static func bundleForImages() -> Bundle{
        let resourceBundle = Bundle(path: Bundle(for: NoUse.self).path(forResource: "TGSPublicImages", ofType: "bundle") ?? "")
        return resourceBundle!;
    }
    
    var localeForModule: String {
        let msg = NSLocalizedString(self, tableName: nil, bundle: String.bundleForModule(), value: "", comment: "")
        return msg
    }
}

extension UIImage{
    static func imageForModule(_ name:String) -> UIImage?{
        return  UIImage.init(named: name, in: String.bundleForImages(), with: nil)
    }
}
