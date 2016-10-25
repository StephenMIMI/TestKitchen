//
//  MainTabBarViewController.swift
//  TestKitchen
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    //tabbar的背景
    private var bgView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //创建视图控制器
        createViewControllers()
    }
    
    //创建视图控制器
    func createViewControllers() {
        //从controllers.json文件里面读取数据
        let path = NSBundle.mainBundle()
        .pathForResource("Controllers", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        var nameArray = [String]()//视图控制器名字的数组
        var imageArray = [String]()//图片名字
        var titleArray = [String]()//标题文字
        do{
            //可能抛异常的代码
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
            if json.isKindOfClass(NSArray) {
                let tmpArray = json as! Array<Dictionary<String,String>>
                
                //遍历获取视图控制器的名字
                for tmpDict in tmpArray {
                    let ctrlname = tmpDict["ctrlname"]
                    let image = tmpDict["image"]
                    let title = tmpDict["title"]
                    nameArray.append(ctrlname!)
                    imageArray.append(image!)
                    titleArray.append(title!)
                }
            }
        }catch(let error) {
            //捕获错误信息
            print(error)
        }
        
        //如果获取数组有错误,提供默认值
        if nameArray.count == 0 {
            nameArray = ["IngredientViewController","CommunityViewController","MallViewController","FoodClassViewController","ProfileViewController"]
            imageArray = ["home","community","title","shike","mine"]
            titleArray = ["食材","社区","商城","食课","我的"]
        }
        
        //视图控制器数组
        var ctrlArray = Array<UINavigationController>()
        for i in 0..<nameArray.count {
            let name = "TestKitchen."+nameArray[i]
            //使用类名创建类的对象
            let ctrl = NSClassFromString(name) as! UIViewController.Type
            let vc = ctrl.init()
            //导航
            let navCtrl = UINavigationController(rootViewController: vc)
            ctrlArray.append(navCtrl)
        }
        viewControllers = ctrlArray
        //隐藏系统的tabbar
        tabBar.hidden = true
        createMyTabBar(imageArray, titles: titleArray)
    }

    func createMyTabBar(imageNames: Array<String>, titles: Array<String>) {
        //1.创建背景视图
        bgView = UIView.createView()
        bgView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        //设置边框
//        bgView?.layer.borderColor = UIColor.blackColor().CGColor
//        bgView?.layer.borderWidth = 1
        view.addSubview(bgView!)
        bgView?.snp_makeConstraints(closure: { [weak self](make) in
            make.left.right.bottom.equalTo(self!.view)
            make.height.equalTo(49)
        })
        
        //循环创建按钮
        let width = screenWidth/CGFloat(imageNames.count)
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]+"_normal"
            let selectName = imageNames[i]+"_select"
            //2.1 创建button
            let btn = UIButton.createBtn(nil, bgImageName: imageName, highlightImageName: nil, selectImageName: selectName, target: self, action: #selector(btnClick(_:)))
                btn.tag = 100+i
            bgView?.addSubview(btn)
            
            //设置位置
            btn.snp_makeConstraints(closure: { [weak self](make) in
                make.top.bottom.equalTo(self!.bgView!)
                make.width.equalTo(width)
                make.left.equalTo(width*CGFloat(i))
            })
            
            //2.2显示标题
            let titleLabel = UILabel.createLabel(titles[i], textAlignment: .Center, font: UIFont.systemFontOfSize(10))
            titleLabel.textColor = UIColor.lightGrayColor()
            titleLabel.tag = 400
            btn.addSubview(titleLabel)
            
            titleLabel.snp_makeConstraints(closure: { (make) in
                make.left.bottom.right.equalTo(btn)
                make.height.equalTo(15)
            })
            //默认选中第一个按钮
            if i == 0 {
                btn.selected = true
                titleLabel.textColor = UIColor.brownColor()
            }
        }
        
    }
    
    func btnClick(curBtn: UIButton) {
        let index = curBtn.tag-100
        //1.1取消选中之前的按钮
        let lastBtn = bgView?.viewWithTag(100+selectedIndex) as! UIButton
        lastBtn.selected = false
        lastBtn.userInteractionEnabled = true
        
        let lastLabel = lastBtn.viewWithTag(400) as! UILabel
        lastLabel.textColor = UIColor.lightGrayColor()
        
        //1.2选中当前的按钮
        curBtn.selected = true
        
        //1.3切换视图控制器
        selectedIndex = index
        curBtn.userInteractionEnabled = false
        
        let curLabel = curBtn.viewWithTag(400) as! UILabel
        curLabel.textColor = UIColor.brownColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
