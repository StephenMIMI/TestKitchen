//
//  KTCDownload.swift
//  TestKitchen
//
//  Created by qianfeng on 16/10/24.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import Alamofire

protocol KTCDownloadDelegate: NSObjectProtocol {
    //下载失败
    func downloader(downloader: KTCDownloader, didFailWithError error: NSError)
    //下载成功
    func downloader(downloader: KTCDownloader, didFinishWithData data: NSData?)
}

class KTCDownloader: NSObject {
    weak var delegate: KTCDownloadDelegate?
    //POST请求
    func postWithUrl(urlString: String, params: Dictionary<String, AnyObject>) {
        Alamofire.request(.POST, urlString, parameters: params, encoding: ParameterEncoding.URL, headers: nil).responseData { (response) in
            switch response.result {
            case .Failure(let error):
                //下载失败
                self.delegate?.downloader(self, didFailWithError: error)
            case .Success:
                //下载成功
                self.delegate?.downloader(self, didFinishWithData: response.data)
            }
        }
    }
}
