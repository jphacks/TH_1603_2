//
//  ViewController.swift
//  JPHACK_APP
//
//  Created by 河辺雅史 on 2016/10/29.
//  Copyright © 2016年 fun. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    var mySession : AVCaptureSession!
    var myDevice : AVCaptureDevice!
    var myImageOutput: AVCaptureStillImageOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mySession = AVCaptureSession()
        let devices = AVCaptureDevice.devices()
        
        for device in devices! {
            if((device as AnyObject).position == AVCaptureDevicePosition.back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        let videoInput = try! AVCaptureDeviceInput.init(device: myDevice)
        mySession.addInput(videoInput)
        myImageOutput = AVCaptureStillImageOutput()
        mySession.addOutput(myImageOutput)
        
        let myVideoLayer = AVCaptureVideoPreviewLayer.init(session: mySession)
        myVideoLayer?.frame = self.view.bounds
        myVideoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        self.view.layer.addSublayer(myVideoLayer!)
        
        mySession.startRunning()
        
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        myButton.backgroundColor = UIColor.red
        myButton.layer.masksToBounds = true
        myButton.setTitle("撮影", for: .normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        myButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        self.view.addSubview(myButton);
    }
    
    func onClick(sender: UIButton){
        let myVideoConnection = myImageOutput.connection(withMediaType: AVMediaTypeVideo)
        
        self.myImageOutput.captureStillImageAsynchronously(from: myVideoConnection, completionHandler: {(imageDataBuffer, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            let myImageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: imageDataBuffer!, previewPhotoSampleBuffer: nil)
            let myImage = UIImage(data: myImageData!)
            UIImageWriteToSavedPhotosAlbum(myImage!, nil, nil, nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

