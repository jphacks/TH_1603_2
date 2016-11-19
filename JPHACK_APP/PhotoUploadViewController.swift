//
//  PhotoUploadViewController.swift
//  JPHACK_APP
//
//  Created by 河辺雅史 on 2016/10/29.
//  Copyright © 2016年 fun. All rights reserved.
//

import UIKit
import Photos

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

class PhotoUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {    
    @IBOutlet weak var myImageView: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onButtonAlbumOpen(_ sender: AnyObject) {
        let ipc: UIImagePickerController = UIImagePickerController();
        ipc.delegate = self
        UIImagePickerControllerSourceType.photoLibrary
        self.present(ipc, animated:true, completion:nil)
    }
    
    func resize(image: UIImage, width: Int, height: Int) -> UIImage {
        let size: CGSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        let resizeImage = resize(image: self.image!, width: 480, height: 320)
        myImageView.image = resizeImage
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        var body = NSMutableData()
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    //画像のアップロード処理
    func myImageUploadRequest(){
        //myUrlには自分で用意したphpファイルのアドレスを入れる
        let myUrl = NSURL(string:"http://cu76nat-aj3-app000.c4sa.net/images/add")
        let request = NSMutableURLRequest(url:myUrl! as URL)
        request.httpMethod = "POST"
        //下記のパラメータはあくまでもPOSTの例
        let param = [
            "userId" : "12345"
        ]
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = UIImageJPEGRepresentation(self.image, 1)
        if(imageData==nil) { return; }
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as Data as NSData, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            // レスポンスを出力
            print("******* response = \(response)")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
//            SVProgressHUD.showSuccess(withStatus: "アップロード完了")
        }
        task.resume()
    }
        
    @IBAction func onButtonImageUpload(_ sender: AnyObject) {
        if((self.image) != nil) {
            self.myImageUploadRequest()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
