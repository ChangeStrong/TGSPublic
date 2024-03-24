//
//  Extension+module.swift
//  TGSPublic
//
//  Created by luo luo on 2024/2/15.
//

import Foundation


fileprivate class NoUse {
    
}
extension Bundle{
    static func bundleForModule() -> Bundle{
        let resourceBundle = Bundle(path: Bundle(for: NoUse.self).path(forResource: "TGSPublic", ofType: "bundle") ?? "")
        return resourceBundle!;
    }
    
    static func bundleForImages() -> Bundle{
        let resourceBundle = Bundle(path: Bundle(for: NoUse.self).path(forResource: "TGSPublicImages", ofType: "bundle") ?? "")
        return resourceBundle!;
    }
}

extension String{
    var localeForModule: String {
        let msg = NSLocalizedString(self, tableName: nil, bundle: Bundle.bundleForModule(), value: "", comment: "")
        return msg
    }
}

extension UIImage{
    static func imageForModule(_ name:String) -> UIImage?{
        return  UIImage.init(named: name, in: Bundle.bundleForImages(), with: nil)
    }
}
