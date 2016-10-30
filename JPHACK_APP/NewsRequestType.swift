//
//  NewsRequestType.swift
//  JPHACK_APP
//
//  Created by 河辺雅史 on 2016/10/30.
//  Copyright © 2016年 fun. All rights reserved.
//

import APIKit

protocol NewsRequestType: Request {}

extension NewsRequestType {
    var baseURL: URL {
        return URL(string: "http://cu76nat-aj3-app000.c4sa.net")!
    }
}
