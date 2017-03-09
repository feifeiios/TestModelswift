//
//  TableViewController.swift
//  TestModelswift
//
//  Created by Zzcz on 2017/2/9.
//  Copyright © 2017年 fly. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var modelArray : [Model]? = []// = <#value#>
    
    override func viewDidLoad() {
        super.viewDidLoad()


        for i in 0...10 {
            /*
             一
             模型对象，属性逐一赋值
             let model = Model.init();
             model.name = "name" + String(i)
             if i%4 == 0 {
             model.job = "teacher"
             
             } else {
             model.job = "sutdent"
             }
             model.image = String(i%4)
             modelArray?.append(model)

             */
            
           /*
             二
             使用构造函数赋值
             let m = Model.init(dict: ["name":"name"+String(i),"job":(i%4 == 0 ? "Teacher" : "Student"),"image":String(i%4)])
             modelArray?.append(m)
             print(m.description)

             */
            
            /*
             三 
             重写setValuesForKeysWithDictionary赋值
            
             */
            let model = Model.init();
            model.setValuesForKeysWithDictionary(["name":"name"+String(i),"job":(i%4 == 0 ? "Teacher" : "Student"),"image":String(i%4)])
            print(model.description)
            modelArray?.append(model)
            
        }
        tableView.reloadData()
      
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray == nil ? 0 : (modelArray?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        /*
         一
         使用函数赋值
         cell.cellForModel(modelArray![indexPath.row])
         */
        /*
         二
         使用set方法赋值
         */
        cell.model = modelArray![indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView();
        view.backgroundColor = UIColor.grayColor()
        
        return view;
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }

}
