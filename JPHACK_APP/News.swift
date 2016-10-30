//
//  News.swift
//  JPHACK_APP
//
//  Created by 河辺雅史 on 2016/10/30.
//  Copyright © 2016年 fun. All rights reserved.
//

import Foundation
import Himotoki

struct News {
    let title: String
    let urlString: String
    let imageURL: NSURL
}

extension News: Decodable {
    static let URLTransformer = Transformer<String, NSURL> { URLString throws -> NSURL in
        if let URL = NSURL(string: URLString) {
            return URL
        }
        throw customError("Invalid URL string: \(URLString)")
    }
    
    static func decode(_ e: Extractor) throws -> News {
        return try News(title: e <| "title",
                        urlString: e <| "url",
                        imageURL: URLTransformer.apply(e <| "image"))
    }
}
