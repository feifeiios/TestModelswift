//
//  MeetingNounceViewController.swift
//  商会
//
//  Created by KingLiu on 16/7/5.
//  Copyright © 2016年 中智创展. All rights reserved.
//

import UIKit

class MeetingNounceViewController: BaseViewController {

    //会议标题
    @IBOutlet weak var notificationTitle: UILabel!
    //通知内容
    @IBOutlet weak var notificationDetail: UILabel!
    //截止日期
    @IBOutlet weak var effectiveDate: UILabel!
    //参与  乐捐
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    //默认说明--有效期内...
    @IBOutlet weak var showLabel: UILabel!
    //修改次数
    @IBOutlet weak var changeTimesLabel: UILabel!
    //参与人数  乐捐人数
    @IBOutlet weak var joinLabel: UILabel!
    @IBOutlet weak var lejuanLabel: UILabel!
    
    @IBOutlet weak var joinCount: UILabel!
    @IBOutlet weak var lejuanCount: UILabel!
    //参与结果显示
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultNSLayoutConstrain: NSLayoutConstraint!
    //横向分割线
    @IBOutlet weak var hengLineView: UIView!
    //竖向分割线
    @IBOutlet weak var shuLineView: UIView!
    
    
    var fromTopString = String()
    //会议表决状态
    var meetingStateString = String()
    //点击参与、乐捐传参
    var mettingUserStr = String()
    
    var model = VoteDetailModel()
    //上一页传值-会议进行状态
    var meetStatus = String()
    
    
    // true 可以操作 fasle 不可操作
    //获取登录身份 是否可以操作  是否是会员 非会员不能操作
    let isEnableOperation = UserInfo().meberFlag()
    
    /** 会员  Member
     *  秘书 secretary
     运营 Operate
     *
     *  @return
     */
    let isMember = UserInfo().meberFlag()
    let isSecretary = UserInfo().getIdentify()
    let isOperate = UserInfo().isAdminFlag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = FF().makeTitle("通知详情")
        self.makeBackpopViewController()
        
        loadData()
    }
    
    
    func customUIAfterLoadData() -> Void {
        
        //标题  内容
        FF().modifyFontLable(notificationTitle, font: FF().FONT_NORMAL_TITLE(), color: FF().COLOR_TEXT())
        FF().modifyFontLable(notificationDetail, font: FF().FONT_TEXT(), color: FF().COLOR_TEXT())
        FF().increaseWordSpacingLable(notificationDetail, title: notificationDetail.text!)
        //截止日期
        FF().modifyFontLable(effectiveDate, font: FF().FONT_SUB_TEXT(), color: FF().COLOR_TEXT())
        //按钮
        FF().modifyFontButton(joinButton, font: FF().FONT_SUB_TITLE(), color: FF().COLOR_TEXT())
        FF().modifyFontButton(cancelButton, font: FF().FONT_SUB_TITLE(), color: FF().COLOR_TEXT())
        joinButton.backgroundColor = FF().COLOR_BUTTON()
        cancelButton.backgroundColor = FF().COLOR_BUTTON()
        FF().setLayerWithButton(joinButton, floatValue: 5)
        FF().setLayerWithButton(cancelButton, floatValue: 5)
        //默认label
        FF().modifyFontLable(showLabel, font: FF().FONT_SUB_TEXT(), color: FF().COLOR_TEXT())
        FF().modifyFontLable(changeTimesLabel, font: FF().FONT_SUB_TEXT(), color: FF().COLOR_TEXT())
        //参与  乐捐  参与人数  乐捐人数
        FF().modifyFontLable(joinLabel, font: FF().FONT_TEXT(), color: FF().COLOR_TEXT())
        FF().modifyFontLable(lejuanLabel, font: FF().FONT_TEXT(), color: FF().COLOR_TEXT())
        FF().modifyFontLable(joinCount, font: FF().FONT_TEXT(), color: FF().COLOR_TEXT())
        FF().modifyFontLable(lejuanCount, font: FF().FONT_TEXT(), color: FF().COLOR_TEXT())
        //分割线
        hengLineView.backgroundColor = UIColor.lightGrayColor()
        shuLineView.backgroundColor = UIColor.lightGrayColor()
        
        //处理结果
        FF().modifyFontLable(resultLabel, font: FF().FONT_NORMAL_TITLE(), color: FF().COLOR_TEXT())
    }
    
    func loadData() -> Void {
        
        let parameters = ["token":UserInfo().token(), "voteId":fromTopString, "bsBoolean":isMember.description, "msBoolean": isSecretary.description, "adBoolean": isOperate.description]
        
        Alamofire.request(.POST, URL().MeetingDetailURL(), parameters: parameters, encoding: .URL)
            .validate()
            .responseJSON{
                response in
                switch response.result{
                case .Success:
                    if let value = response.result.value{
                        
                        let jsonResult = JSON(value)
//                        print("会议通知详情数据结果:\(jsonResult)")
                        if jsonResult["flag"] == false {
                            let info = jsonResult["info"].string
                            if info == FF().unableString() {
                                
                                NSOperationQueue.mainQueue().addOperationWithBlock({
                                    
                                    UIApplication.sharedApplication().keyWindow?.rootViewController = SimpleLogoinViewController()
                                    UIApplication.sharedApplication().keyWindow?.makeKeyAndVisible()
                                    UserInfo().loginout()

                                    DMCAlertCenter.defaultCenter().postAlertWithMessage("会员失去权限")
                                    
                                })
                            }else{
                                DMCAlertCenter.defaultCenter().postAlertWithMessage(info)
                            }
                            return
                        }

                        self.model.voteName = jsonResult["data"]["meetingName"].string!
                        self.model.endTime = jsonResult["data"]["endTime"].string!
                        self.model.voteContent = jsonResult["data"]["meetingContent"].string!
                        self.model.jionCount = jsonResult["data"]["jionCount"].number!
                        self.model.donateCount = jsonResult["data"]["donateCount"].number!
                        self.model.meetingUserId = jsonResult["data"]["meetingUserId"].string!
                        self.model.isReset = jsonResult["data"]["isReset"].string!
                        self.model.excuteStatus = jsonResult["data"]["excuteStatus"].string!
                        self.mettingUserStr = self.model.meetingUserId
                        
                        self.customUIAfterLoadData()
                        self.UpdateNSLayoutWithData()
                        self.setDataWithModel()
                    }
                case .Failure:
                    DMCAlertCenter.defaultCenter().postAlertWithMessage("网络异常")
                }
        }
    }
    
    func UpdateNSLayoutWithData() -> Void {
        
        if isOperate && !isEnableOperation && !isSecretary{//纯运营
            joinButton.hidden = false
            cancelButton.hidden = false
            resultLabel.hidden = true
        }else{
            if meetStatus == "1" {//正在进行
                if model.isReset == "0" || model.isReset == "1" {
                    switch model.excuteStatus {
                    case "0":
                        self.hideButtonOrLabel(joinButton, btn2: cancelButton, label: resultLabel, model: model)
                    case "1":
                        resultLabel.text = "您的处理结果为：参 与"
                        self.hideButtonOrLabel(joinButton, btn2: cancelButton, label: resultLabel, model: model)
                        joinButton.backgroundColor = UIColor.blackColor()
                        joinButton.setTitleColor(FF().COLOR_TITLE(), forState: .Normal)
                    case "2":
                        resultLabel.text = "您的处理结果为：乐 捐"
                        cancelButton.backgroundColor = UIColor.blackColor()
                        cancelButton.setTitleColor(FF().COLOR_TITLE(), forState: .Normal)
                        self.hideButtonOrLabel(joinButton, btn2: cancelButton, label: resultLabel, model: model)
                    default:
                        break
                    }
                }else{//两次表决
                    switch model.excuteStatus {
                    case "0":
                        joinButton.hidden = false
                        cancelButton.hidden = false
                        resultLabel.hidden = true
                    case "1":
                        resultLabel.text = "您的处理结果为：参 与"
                        self.hideButtonOrLabel(joinButton, btn2: cancelButton, label: resultLabel, model: model)
                    case "2":
                        resultLabel.text = "您的处理结果为：乐 捐"
                        self.hideButtonOrLabel(joinButton, btn2: cancelButton, label: resultLabel, model: model)
                    default:
                        break
                    }
                    changeTimesLabel.hidden = true
                }
                
            }else{//已完结
//                resultLabel.text = "您的处理结果为：乐 捐"
                joinButton.hidden = true
                cancelButton.hidden = true
                resultLabel.hidden = false
                changeTimesLabel.hidden = true
                
                switch model.excuteStatus {
                case "1":
                    resultLabel.text = "您的处理结果为：参与"
                case "2":
                    resultLabel.text = "您的处理结果为：乐捐"
                default:
                    break
                }
            }
        }        
    }
    
    func hideButtonOrLabel(btn1: UIButton, btn2: UIButton, label: UILabel, model: VoteDetailModel) -> Void {
        if model.isReset == "1" || model.isReset == "0"{
            btn1.hidden = false
            btn2.hidden = false
            if model.excuteStatus == "0" {
                resultNSLayoutConstrain.constant = 15
                label.hidden = true
            }else{
                resultNSLayoutConstrain.constant = 75
                label.hidden = false
            }
        }else{
            resultNSLayoutConstrain.constant = 15
            btn1.hidden = true
            btn2.hidden = true
            label.hidden = false
        }
        
    }
    
    func setDataWithModel() -> Void {
        notificationTitle.text = model.voteName
        notificationDetail.text = model.voteContent
        
        effectiveDate.text = "投票有效期至 " + model.endTime
        
        joinButton.addTarget(self, action: #selector(buttonClick), forControlEvents: .TouchUpInside)
        cancelButton.addTarget(self, action: #selector(buttonClick), forControlEvents: .TouchUpInside)
        
        joinCount.text = "(" + String(model.jionCount) + ")"
        lejuanCount.text = "(" + String(model.donateCount) + ")"
    }
    
    func buttonClick(btn: UIButton) -> Void {
        if isEnableOperation {
            FF().maskShow()
            var parameters = NSDictionary()
            if btn.tag == 40 {
                parameters = ["token":UserInfo().token(), "voteId":fromTopString, "favour":"1", "meetingUserId":mettingUserStr]
            }else{
                parameters = ["token":UserInfo().token(), "voteId":fromTopString, "favour":"2", "meetingUserId":mettingUserStr]
            }
            Alamofire.request(.POST, URL().MeetingClickURL(), parameters: parameters as? [String : AnyObject], encoding: .URL)
                .validate()
                .responseJSON{
                    response in
                    FF().dismissMask()
                    
                    switch response.result{
                    case .Success:
                        
                        if let value = response.result.value{
                            
                            let jsonResult = JSON(value)
                            //print("点击参与  乐捐以后的数据结果:\n\(jsonResult)")
                            if jsonResult["flag"] == false {
                                let info = jsonResult["info"].string
                                if info == FF().unableString() {
                                    
                                    NSOperationQueue.mainQueue().addOperationWithBlock({
                                        
                                        UIApplication.sharedApplication().keyWindow?.rootViewController = SimpleLogoinViewController()
                                        UIApplication.sharedApplication().keyWindow?.makeKeyAndVisible()
                                        UserInfo().loginout()
                                        
                                        DMCAlertCenter.defaultCenter().postAlertWithMessage("会员失去权限")
                                        
                                    })
                                }else{
                                    DMCAlertCenter.defaultCenter().postAlertWithMessage("暂无权限")
                                }
                                return
                            }else{
//                                NSNotificationCenter.defaultCenter().postNotificationName("MeetingListCallBack", object: self, userInfo: nil)
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                            
                            self.loadData()
                        }
                    case .Failure:
                        DMCAlertCenter.defaultCenter().postAlertWithMessage("网络异常")
                    }
            }
        }else{
            DMCAlertCenter.defaultCenter().postAlertWithMessage("暂无权限")
        }
        
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
