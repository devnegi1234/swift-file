//
//  Global.swift
//  Aappii
//
//  Created by Jarvics on 19/05/17.
//  Copyright © 2017 Omninos_Solutions. All rights reserved.
//

import UIKit
import Alamofire

class Global: NSObject {
    
    var imageData1 = Data()
    
    let BaseURL = "http://omninos.com/pestige/api/user/"
    func alamofire_withMethod( method: String, parameters : NSDictionary, completion: @escaping ( _ result : AnyObject) -> (), failure: @escaping (_ fail : AnyObject) -> ()) {
        
        Alamofire.request("\(BaseURL)\(method)", method: .post ,parameters: parameters as? Parameters).responseJSON { response in
            
            if let JSON = response.result.value {
                if let _ = JSON as? NSArray{
                    let result : NSArray = (JSON as? NSArray)!
                    completion(result)
                }else if let _ = JSON as? NSDictionary{
                    let result : NSDictionary = (JSON as? NSDictionary)!
                    completion(result)
                }
            }else{
                failure(response as AnyObject)
                print(response)
            }
        }
    }
    
    
    func createImageArrayPost(method: String, StringParameters : NSDictionary? = nil, additionalArrayParameters : NSDictionary? = nil, signature: UIImage, imagesDataArray : NSArray, completion: @escaping (_ result : AnyObject) -> ()) {
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                self.resizeImage(signature, newHeight: 400)
//                let imgData2 : Data = signature as! Data
//                let imgData2 : Data = (UIImagePNGRepresentation(signature) as Data?)!
              //  let data = UIImagePNGRepresentation(img) as NSData?

                MultipartFormData.append(self.imageData1, withName: "signatuure", fileName: "signatuure.jpg", mimeType: "image/jpg")
                var x = 0
                while x < imagesDataArray.count{
//                    let imgData : Data = imagesDataArray[x] as! Data
                    self.resizeImage(imagesDataArray[x] as! UIImage, newHeight: 400)
                    MultipartFormData.append(self.imageData1, withName: "images[]", fileName: "image\(x).jpg", mimeType: "image/jpg")
                    x += 1
                }
                
                if StringParameters != nil{
                    for (key, value) in StringParameters! {
                        MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
                if additionalArrayParameters != nil{
                    for (key, value) in additionalArrayParameters! {
                        for item in (value as? NSArray)! {
                            MultipartFormData.append((item as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                        }
                    }
                }
                
        }, to: "\(BaseURL)\(method)") { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress { progress in
                    //                    let uploading = Int((progress.fractionCompleted).roundTo(places: 2) * 100)
                    //                    print(Int((progress.fractionCompleted).roundTo(places: 2) * 100))
                    //                    NotificationCenter.default.post(name: Notification.Name("uploadProgress"), object: uploading)
                }
                upload.responseJSON { response in
                    print("\nresponse :\(response)\n")
                    completion(response.result.value as AnyObject)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    
    
    
    func createNewImageArrayPost(method: String, StringParameters : NSDictionary? = nil, additionalArrayParameters : NSDictionary? = nil, signature: UIImage? = nil, imagesDataArray : NSArray, completion: @escaping (_ result : AnyObject) -> ()) {
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
//                self.resizeImage(signature!, newHeight: 400)
                //                let imgData2 : Data = signature as! Data
                //                let imgData2 : Data = (UIImagePNGRepresentation(signature) as Data?)!
                //  let data = UIImagePNGRepresentation(img) as NSData?
                
//                MultipartFormData.append(self.imageData1, withName: "signatuure", fileName: "signatuure.jpg", mimeType: "image/jpg")
                var x = 0
                while x < imagesDataArray.count{
                    //                    let imgData : Data = imagesDataArray[x] as! Data
                    self.resizeImage(imagesDataArray[x] as! UIImage, newHeight: 400)
                    MultipartFormData.append(self.imageData1, withName: "invoice_no[]", fileName: "image\(x).jpg", mimeType: "image/jpg")
                    x += 1
                }
                
                if StringParameters != nil{
                    for (key, value) in StringParameters! {
                        MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
                if additionalArrayParameters != nil{
                    for (key, value) in additionalArrayParameters! {
                        for item in (value as? NSArray)! {
                            MultipartFormData.append((item as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                        }
                    }
                }
                
        }, to: "\(BaseURL)\(method)") { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress { progress in
                    //                    let uploading = Int((progress.fractionCompleted).roundTo(places: 2) * 100)
                    //                    print(Int((progress.fractionCompleted).roundTo(places: 2) * 100))
                    //                    NotificationCenter.default.post(name: Notification.Name("uploadProgress"), object: uploading)
                }
                upload.responseJSON { response in
                    print("\nresponse :\(response)\n")
                    completion(response.result.value as AnyObject)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    
    
    
    func createPost(method: String, StringParameters : NSDictionary? = nil, additionalArrayParameters : NSDictionary? = nil, imagesDataArray : NSMutableArray,  completion: @escaping (_ result : AnyObject) -> ()) {
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                
                var x = 0
                while x < imagesDataArray.count{
                   
                    let imgData : Data = imagesDataArray[x] as! Data
                    MultipartFormData.append(imgData, withName: "invoice_no[]", fileName: "image\(x).jpg", mimeType: "image/jpg")
                    x += 1
                }
                
                if StringParameters != nil{
                    for (key, value) in StringParameters! {
                        MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
                if additionalArrayParameters != nil{
                    for (key, value) in additionalArrayParameters! {
                        for item in (value as? NSArray)! {
                            MultipartFormData.append((item as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                        }
                    }
                }
                
        }, to: "\(BaseURL)\(method)") { (result) in
            
            switch result {
            case .success(let upload,_,_):
                
                upload.uploadProgress { progress in
                    //                    let uploading = Int((progress.fractionCompleted).roundTo(places: 2) * 100)
                    //                    print(Int((progress.fractionCompleted).roundTo(places: 2) * 100))
                    //                    NotificationCenter.default.post(name: Notification.Name("uploadProgress"), object: uploading)
                }
                upload.responseJSON { response in
                    print("\nresponse :\(response)\n")
                    completion(response.result.value as AnyObject)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    
    func alamofire_uploadImage(_ method:String,parameters: NSDictionary,myimage: Data,imagewithname: String, completion:@escaping (_ result : AnyObject) -> ()) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(myimage, withName: imagewithname,fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        },
                         to: "\(BaseURL)\(method)") { (result) in
                            
                            switch result {
                            case .success(let upload, _, _):
                                
                                upload.uploadProgress { progress in
                                    let uploading = Int((progress.fractionCompleted).roundTo(places: 2) * 100)
                                    print(Int((progress.fractionCompleted).roundTo(places: 2) * 100))
                                    NotificationCenter.default.post(name: Notification.Name("uploadProgress"), object: uploading)
                                }
                                
                                upload.responseJSON { response in
                                    
                                    print(response)
                                    completion(response.result.value as AnyObject)
                                    //                        NotificationCenter.default.post(name: Notification.Name("refreshPosts"), object: nil)
                                }
                                
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        }
    }
    
    
    
    //Send Data in Multipart form with dictionary and images
    func createPost(method: String, parameters : NSDictionary? = nil, imagesDataArray : NSArray,audio : NSData? = nil, fileType : String, fileExtension : String, completion: @escaping (_ result : AnyObject) -> ()) {
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                
                var fileXT = String()
                var mimeType = String()
                fileXT = "jpg"
                mimeType = "image/jpg"
                
                
                //         print("\(fileType!)PostFile.\(fileXT)")
                //         print(mimeType)
                
                var x = 0
                while x < imagesDataArray.count{
                    let imgData : Data = imagesDataArray[x] as! Data
                    print("\n\n\n")
                    print(imgData.count)
                    print(imgData)
                    
                    
                    MultipartFormData.append(imgData, withName: "userFiles[]", fileName: "\(fileType)PostFile.\(fileXT)", mimeType: mimeType)
                    x += 1
                }
                
                //String Parameters
                if parameters != nil{
                    for (key, value) in parameters! {
                        MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
                
        }, to: "\(BaseURL)\(method)") { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress { progress in
                    let uploading = Int((progress.fractionCompleted).roundTo(places: 2) * 100)
                    print(Int((progress.fractionCompleted).roundTo(places: 2) * 100))
                    NotificationCenter.default.post(name: Notification.Name("uploadProgress"), object: uploading)
                }
                
                upload.responseJSON { response in
                    
                    print(response)
                    completion(response.result.value as AnyObject)
                    //                        NotificationCenter.default.post(name: Notification.Name("refreshPosts"), object: nil)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    //Send Data in Multipart form with dictionary and images
    func createProfile(method: String, parameters : NSDictionary? = nil, imagesDataArray : NSArray,audio : NSData? = nil, fileType : String, fileExtension : String, completion: @escaping (_ result : AnyObject) -> ()) {
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                
                //                var fileXT = String()
                //                var mimeType = String()
                //                if fileType == "video"{
                //                    fileXT = fileExtension
                //                    mimeType = "video/\(fileExtension)"
                //                }else{
                //                    fileXT = "jpg"
                //                    mimeType = "image/jpg"
                //                }
                
                //         print("\(fileType!)PostFile.\(fileXT)")
                //         print(mimeType)
                
                var x = 0
                while x < imagesDataArray.count{
                    
                    
                    MultipartFormData.append((imagesDataArray[x] as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "product_id[\(x)]")
                    
                    
                    x += 1
                }
                
                //String Parameters
                if parameters != nil{
                    for (key, value) in parameters! {
                        MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
                
                //                //Audio
                //                if audio != nil{
                //                    MultipartFormData.append(audio as! Data, withName: "audio", fileName: "userAudioFiles.mp3", mimeType: "audio/mp3")
                //                }else{
                //                    let value = ""
                //                    MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "audio")
                //                }
                
        }, to: "\(BaseURL)\(method)") { (result) in
            
            switch result {
            case .success(let upload,_,_):
                
                upload.uploadProgress { progress in
                    let uploading = Int((progress.fractionCompleted).roundTo(places: 2) * 100)
                    print(Int((progress.fractionCompleted).roundTo(places: 2) * 100))
                    NotificationCenter.default.post(name: Notification.Name("uploadProgress"), object: uploading)
                }
                
                upload.responseJSON { response in
                    
                    print(response)
                    completion(response.result.value as AnyObject)
                    //                        NotificationCenter.default.post(name: Notification.Name("refreshPosts"), object: nil)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    func createPostimage(method: String, parameters : NSDictionary? = nil, imagesDataArray : NSArray,audio : NSData? = nil, fileType : String, fileExtension : String, completion: @escaping (_ result : AnyObject) -> ()) {
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                
                var fileXT = String()
                var mimeType = String()
                if fileType == "video"{
                    fileXT = fileExtension
                    mimeType = "video/\(fileExtension)"
                }else{
                    fileXT = "jpg"
                    mimeType = "image/jpg"
                }
                
                //         print("\(fileType!)PostFile.\(fileXT)")
                //         print(mimeType)
                
                var x = 0
                while x < imagesDataArray.count{
                    let imgData : Data = imagesDataArray[x] as! Data
                    print("\n\n\n")
                    print(imgData.count)
                    print(imgData)
                    
                    
                    MultipartFormData.append(imgData, withName: "image[]", fileName: "\(fileType)PostFile.\(fileXT)", mimeType: mimeType)
                    x += 1
                }
                
                //String Parameters
                if parameters != nil{
                    for (key, value) in parameters! {
                        MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
                
                //Audio
                if audio != nil{
                    MultipartFormData.append(audio! as Data, withName: "audio", fileName: "userAudioFiles.mp3", mimeType: "audio/mp3")
                }else{
                    let value = ""
                    MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "audio")
                }
                
        }, to: "\(BaseURL)\(method)") { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress { progress in
                    let uploading = Int((progress.fractionCompleted).roundTo(places: 2) * 100)
                    print(Int((progress.fractionCompleted).roundTo(places: 2) * 100))
                    NotificationCenter.default.post(name: Notification.Name("uploadProgress"), object: uploading)
                }
                
                upload.responseJSON { response in
                    
                    print(response)
                    completion(response.result.value as AnyObject)
                    //                        NotificationCenter.default.post(name: Notification.Name("refreshPosts"), object: nil)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    func makeprofile(method: String, StringParameters : NSDictionary? = nil, additionalArrayParameters : NSDictionary? = nil, imagesDataArray : NSArray, completion: @escaping (_ result : AnyObject) -> ()) {
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                
                var x = 0
                while x < imagesDataArray.count{
                    let imgData : Data = imagesDataArray[x] as! Data
                    MultipartFormData.append(imgData, withName: "image[]", fileName: "image\(x).jpg", mimeType: "image/jpg")
                    x += 1
                }
                
                if StringParameters != nil{
                    for (key, value) in StringParameters! {
                        MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
                if additionalArrayParameters != nil{
                    for (key, value) in additionalArrayParameters! {
                        for item in (value as? NSArray)! {
                            MultipartFormData.append((item as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                        }
                    }
                }
                
        }, to: "\(BaseURL)\(method)") { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress { progress in
                    //                    let uploading = Int((progress.fractionCompleted).roundTo(places: 2) * 100)
                    //                    print(Int((progress.fractionCompleted).roundTo(places: 2) * 100))
                    //                    NotificationCenter.default.post(name: Notification.Name("uploadProgress"), object: uploading)
                }
                upload.responseJSON { response in
                    print("\nresponse :\(response)\n")
                    completion(response.result.value as AnyObject)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func resizeImage(_ image: UIImage, newHeight: CGFloat) -> UIImage {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        imageData1 = UIImageJPEGRepresentation(newImage!, 0.5)!  as Data
        UIGraphicsEndImageContext()
        return UIImage(data:imageData1 as Data)!
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


