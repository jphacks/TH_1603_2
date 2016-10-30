//
//  NewsRequest.swift
//  JPHACK_APP
//
//  Created by 河辺雅史 on 2016/10/30.
//  Copyright © 2016年 fun. All rights reserved.
//

import APIKit
import Himotoki

struct NewsRequest: NewsRequestType {
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Array<News> {
        return try decodeArray(object)
    }

    typealias Response = [News]
    
    var baseURL: URL {
        return URL(string: "http://cu76nat-aj3-app000.c4sa.net")!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/users/read"
    }
    
//    func responseFromObject(object: AnyObject, URLResponse: HTTPURLResponse) throws -> Response {
//        return try decodeArray(object)
//    }
}


