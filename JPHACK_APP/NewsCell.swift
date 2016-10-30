//
//  NewsCell.swift
//  JPHACK_APP
//
//  Created by 河辺雅史 on 2016/10/30.
//  Copyright © 2016年 fun. All rights reserved.
//

import UIKit
import WebImage

class NewsCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func update(withItem news: News) {
        thumbnailImageView.sd_setImage(with: news.imageURL as URL!)
        titleLabel.text = news.title
    }
}
