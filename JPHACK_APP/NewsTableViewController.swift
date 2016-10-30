//
//  NewsTableViewController.swift
//  JPHACK_APP
//
//  Created by 河辺雅史 on 2016/10/30.
//  Copyright © 2016年 fun. All rights reserved.
//

import UIKit
import APIKit

class NewsTableViewController: UITableViewController {
    var news: [News] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        SVProgressHUD.dismiss()
        
        let request = NewsRequest()
        Session.send(request) { result in
            switch result {
            case .success(let response):
                self.news = response
                print(self.news)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            fatalError("Invalid cell")
        }
        
        let new = self.news[indexPath.row]
        cell.update(withItem: new)
        
        return cell
    }
    
    func postData(url: String) {
//        let urlString = "http://cu76nat-aj3-app000.c4sa.net/users/news"
//        var request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
//        
//        request.httpMethod = "POST"
//        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
//        
//        let str: String = "data=" + url
//        let myData: NSData = str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSData
//        request.httpBody = myData as Data
//        
//        print("*****request*****")
//        print(request)
//        print("*****request*****")
//        
//        // use NSURLSessionDataTask
//        var task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
//            if (error == nil) {
//                var result = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
//                print("*****result*****")
//                print(result)
//            } else {
//                print("*****error*****")
//                print(error)
//            }
//        })
//        task.resume()
        
        
        var json: NSData!
        
        // dictionaryで送信するJSONデータを生成.
        let myDict:NSMutableDictionary = NSMutableDictionary()
        myDict.setObject(url, forKey: "url" as NSCopying)
        // 作成したdictionaryがJSONに変換可能かチェック.
        if JSONSerialization.isValidJSONObject(myDict){
            do {
                // DictionaryからJSON(NSData)へ変換.
                json = try JSONSerialization.data(withJSONObject: myDict, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData!
                // 生成したJSONデータの確認.
                print(NSString(data: json as Data, encoding: String.Encoding.utf8.rawValue)!)
                
            } catch {
                print("*****error*****")
                print(error)
            }
            
        }
        
        // Http通信のリクエスト生成.
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        let url:NSURL = NSURL(string: "http://cu76nat-aj3-app000.c4sa.net/users/news")!
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        let session:URLSession = URLSession(configuration: config)
        
        request.httpMethod = "POST"
        
        // jsonのデータを一度文字列にして、キーと合わせる.
        let data:NSString = "json=\(NSString(data: json as Data, encoding: String.Encoding.utf8.rawValue)!)" as NSString
        
        // jsonデータのセット.
        request.httpBody = data.data(using: String.Encoding.utf8.rawValue)
        print("*****request*****")
        print(request)

        
        let task:URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (_data, response, err) -> Void in
            print("*****response*****")
            print(response)
            print("*****error*****")
            print(err)
        })
        
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = self.news[indexPath.row].urlString
        print("*****title*****")
        print(self.news[indexPath.row].title)
        postData(url: url)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
