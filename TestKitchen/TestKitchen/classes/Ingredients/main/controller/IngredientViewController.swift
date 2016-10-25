//
//  IngredientViewController.swift
//  TestKitchen
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class IngredientViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        //滚动视图或者其子视图放在导航下面，会自动加一个上面的间距，我们要取消这个间距
        automaticallyAdjustsScrollViewInsets = false
        downloadRecommendData()//下载首页的推荐数据
    }

    //下载首页的推荐数据
    func downloadRecommendData() {
        //methodName=SceneHome&token=&user_id=&version=4.5
        let params = ["methodName":"SceneHome","token":"","user_id":"","version":"4.5"]
        let downloader = KTCDownloader()
        downloader.delegate = self
        downloader.postWithUrl(kHostUrl, params: params)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK: KTCDownloader代理方法
extension IngredientViewController: KTCDownloadDelegate{
    //下载失败
    func downloader(downloader: KTCDownloader, didFailWithError error: NSError) {
        print(error)
    }
    //下载成功
    func downloader(downloader: KTCDownloader, didFinishWithData data: NSData?) {
        if let tmpData = data{
            //1.json解析
            let recommendModel = IngreRecommend.parseData(tmpData)
            
            //2.显示UI
            let recommendView = IngreRecommendView(frame: CGRectZero)
            recommendView.model = recommendModel
            view.addSubview(recommendView)
            
            //约束
            recommendView.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 49, 0))
            })
        }else{
            print(data)

        }
    }
}
