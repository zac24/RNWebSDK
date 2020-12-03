//
//  MFLibViewController.swift
//  RNWebSDK
//
//  Created by Prashant Dwivedi on 03/12/20.
//  Copyright © 2020 Prashant Dwivedi. All rights reserved.
//

import Foundation
import MobileCoreServices
import MediaPlayer
import UIKit
import AVFoundation
import AVKit

public class MFLibViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
//    let mNativeToWebHandler = "OroWebViewInterface"
//    let mNativeOnImageCapture = "onImageCapture"
//    let mNativeFileDownload = "handleDownloadFile"
//    let mNativeFileUpload = "handleUploadFile"
//    let mNativeRecordVideo = "onVideoCapture"
//    let mNativePlayVideo = "handlePlayVideo"
    let mWebPageName : String = "sampleweb"
    let mWebPageExtension : String = "html"
    var fileURL: URL!
    var downloadedFileURL: String = ""
    var originalImage: UIImage!
    var thumbnailImage: UIImage!
    
    let videoPlayer : AVPlayer? = nil
    var playerItem:AVPlayerItem?
    let videoFileName = "/video.mp4"
    
    var videoURL: URL!
    var uploadedFileDetails :[Dictionary<String, AnyObject>] = []
    var totalUploadFileCount: Int!
    
    let sampleCSVData = "a%2Cb%2Cc%0A1%2C2%2Cx%0A2%2C1%2Cx%0A3%2C5%2Cy%0A4%2C6%2Cy%0A"
    
    
    public static func appendString(str:String) -> String {
        return "Hello" + str
    }
    
    public static func openNativeCamera() {
        
        print("Inside Open Camera")
        let vc = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        }else {
            vc.sourceType = .photoLibrary
        }
        
        vc.allowsEditing = true
        let weakSelf = MFLibViewController()
        vc.delegate = weakSelf
        weakSelf.present(vc, animated: true)
    }
    
    public static func recordVideo() {
        
        let vc = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
            vc.mediaTypes = [kUTTypeMovie as String]
            
        }else {
            vc.sourceType = .photoLibrary
        }
        
        vc.allowsEditing = true
        
        let weakSelf = MFLibViewController()
        vc.delegate = weakSelf
        weakSelf.present(vc, animated: true)
        
//        vc.delegate = self
//        present(vc, animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            self.videoURL = selectedVideo
             print("=====self.videoURL======", self.videoURL ?? "Video not available")
            self.thumbnailImage = generateThumbnail(path: selectedVideo)
            sendThumbnailToJS()
        }
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        self.originalImage = image
        
        print("=====self.originalImage======", self.originalImage ?? "Image not available")
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let timestamp = NSDate().timeIntervalSince1970
        let fileName = "\(timestamp).jpeg"
        fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality:  1.0),
           !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                
            } catch {
                print("error saving file:", error)
            }
        }
        sendUrlToJS()
        
    }
    
    func sendThumbnailToJS() {
        if let thumbnailImage = self.thumbnailImage {
            let imageStr = thumbnailImage.jpegData(compressionQuality: 0.3)?.base64EncodedString(options: []) ?? ""
            let url = self.videoURL.path
            let jsMethod = "onVideoCapture(\""+url+"\",\""+imageStr+"\");"
            
//            self.mWebKitView.evaluateJavaScript(jsMethod, completionHandler: { result, error in
//                guard error == nil else {
//                    print(error as Any)
//                    return
//                }
//            })
        }else {
            return
        }
    }
    
    func sendUrlToJS () {
        let imageStr = self.originalImage.jpegData(compressionQuality: 0.3)?.base64EncodedString(options: []) ?? ""
        let url = self.fileURL.path
        let jsMethod = "onImageCapture(\""+url+"\",\""+imageStr+"\");"
        
//        self.mWebKitView.evaluateJavaScript(jsMethod, completionHandler: { result, error in
//            guard error == nil else {
//                print(error as Any)
//                return
//            }
//        })
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            print("====thumbnail========", thumbnailImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
}
