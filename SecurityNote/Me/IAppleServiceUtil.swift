//
//  IHTCAppleServiceUtil.swift
//  iWuBi
//
//  Created by HTC on 2019/4/14.
//  Copyright © 2019 HTC. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

class IAppleServiceUtil: NSObject {
    class func openWebView(url: String, tintColor: UIColor, vc: UIViewController) {
        if #available(iOS 9.0, *) {
            var sf: SFSafariViewController
            if #available(iOS 13.0, *) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                sf = SFSafariViewController.init(url: URL(string: url)!, configuration: config)
            } else {
                sf = SFSafariViewController(url: URL(string: url)!, entersReaderIfAvailable: true)
            }
            if #available(iOS 10.0, *) {
                sf.preferredBarTintColor = tintColor
                sf.preferredControlTintColor = UIColor.white
            }
            if #available(iOS 11.0, *) {
                sf.dismissButtonStyle = .close
            }
            vc.present(sf, animated: true)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL.init(string: url)!)
        }
        
    }
    
    class func shareWithImage(image: UIImage, text: String, url: String,  vc: UIViewController) {
        let iURL = NSURL(string: url) ?? NSURL.init()
        let activityController = UIActivityViewController(activityItems: [image , iURL, text], applicationActivities: nil)
        //if iPhone
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            vc.present(activityController, animated: true, completion: nil)
        } else {
            //if iPad
            // Change Rect to position Popover
            let popup = UIPopoverController.init(contentViewController: activityController);
            popup.present(from: CGRect.init(x: vc.view.frame.width-44, y: 64, width: 0, height: 0), in: vc.view, permittedArrowDirections: .any, animated: true)
        }
    }
    
    class func shareImage(image: UIImage, vc: UIViewController) {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        vc.present(activityController, animated: true, completion: nil)
        //if iPhone
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            vc.present(activityController, animated: true, completion: nil)
        } else {
            //if iPad
            // Change Rect to position Popover
            let popup = UIPopoverController.init(contentViewController: activityController);
            popup.present(from: CGRect.init(x: vc.view.frame.width-44, y: 64, width: 0, height: 0), in: vc.view, permittedArrowDirections: .any, animated: true)
        }
    }
    
    class func openAppstore(url: String, isAssessment: Bool) {
        let iURL = URL.init(string: url + (isAssessment ? "&action=write-review": ""))!
        if UIApplication.shared.canOpenURL(iURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(iURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(iURL)
            }
        }
    }
    
    class func inAppRating(url: String?) {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            openAppstore(url: url ?? "", isAssessment: true)
        }
    }
    
    class func changeAppIconWithName(iconName: String?) {
        if #available(iOS 10.3, *) {
            UIApplication.shared.setAlternateIconName(iconName) { (error) in
                
            }
        } else {
            let alert = UIAlertController(title: "提示",
                                          message: "更换图标需要 iOS10.3 以上系统才能使用~",
                                          preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction.init(title: "知道啦", style: .cancel) { (action: UIAlertAction) in
                
            }
            alert.addAction(cancelAction)
            UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
}

class ImageHandle: NSObject {
    //MARK - 压缩一张图片 最大宽高1280 类似于微信算法
    class func weixinShareImage(image: UIImage) -> UIImage? {
        return ImageHandle.getJPEGImagerImg(image: image, MaxCompressibility: 1280.00)
    }
    
    // 压缩一张图片 自定义最大宽高
    class func getJPEGImagerImg(image: UIImage, MaxCompressibility: CGFloat) -> UIImage? {
        var oldImg_WID = image.size.width
        var oldImg_HEI = image.size.height
        if oldImg_WID > MaxCompressibility || oldImg_HEI > MaxCompressibility {
            //超过设置的最大宽度 先判断那个边最长
            if(oldImg_WID > oldImg_HEI){
                //宽度大于高度
                oldImg_HEI = (MaxCompressibility * oldImg_HEI)/oldImg_WID;
                oldImg_WID = MaxCompressibility;
            }else{
                oldImg_WID = (MaxCompressibility * oldImg_WID)/oldImg_HEI;
                oldImg_HEI = MaxCompressibility;
            }
        }
        
        let newImage = ImageHandle.imageWithImage(image: image, newSize: CGSize.init(width: oldImg_WID, height: oldImg_HEI))
        var dJpeg: Data
        if let jpeg = newImage.jpegData(compressionQuality: 0.5) {
            dJpeg = jpeg
        }else{
            dJpeg = newImage.pngData() ?? Data()
        }
        
        return UIImage.init(data: dJpeg)
    }
    
    // 压缩一张图片 自定义最大宽高
    class func imageWithImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize);
        image.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage ?? UIImage()
    }
    
    
    class func slaveImageWithMaster(masterImage: UIImage, headerImage: UIImage,  footerImage: UIImage) -> UIImage? {
        var size = masterImage.size
        size.height += headerImage.size.height
        size.height += footerImage.size.height
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        
        //Draw header
        headerImage.draw(in: CGRect.init(x: 0, y: 0, width: headerImage.size.width, height: headerImage.size.height))
        
        //Draw master
        masterImage.draw(in: CGRect.init(x: 0, y: headerImage.size.height, width: masterImage.size.width, height: masterImage.size.height))
        
        //Draw masterfootImage
        footerImage.draw(in: CGRect.init(x: 0, y: headerImage.size.height + masterImage.size.height, width: footerImage.size.width, height: footerImage.size.height))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resultImage
    }
}


extension UIViewController {
    func topPresentedViewController() -> UIViewController {
        
        var vc = self
        
        while ((vc.presentedViewController) != nil) {
            vc = vc.presentedViewController!;
        }
        
        return vc
    }
    
    func currentRootViewController() -> UIViewController {
        return UIViewController.keyWindowHTC()!.rootViewController ?? self
    }
    
    /// The app's key window taking into consideration apps that support multiple scenes.
    class func keyWindowHTC() -> UIWindow? {
        var foundWindow: UIWindow? = nil
        for window in UIApplication.shared.windows {
            if (window.isKeyWindow) {
                foundWindow = window;
                break
            }
        }
        
        if  foundWindow == nil {
            foundWindow = UIApplication.shared.keyWindow
        }
        
        if  foundWindow == nil {
            foundWindow = UIApplication.shared.windows.first
        }
        
        // 先兼容iPhone设备
        if UIDevice.current.userInterfaceIdiom == .phone {
            foundWindow = UIApplication.shared.keyWindow
        }
        
        return foundWindow
    }
}
