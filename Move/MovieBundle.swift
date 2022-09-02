//
//  MovieBundle.swift
//  Move
//
//  Created by 송경진 on 2022/09/02.
//

import Foundation

extension Bundle{
    var url : String{
        guard let file = self.path(forResource: "Security", ofType: "plist") else{
            return ""
        }
        guard let resourse = NSDictionary(contentsOfFile: file) else{
            return ""
        }
        guard let url = resourse["url"] as? String else{
            fatalError("url error")
        }
        return url
    }
}
