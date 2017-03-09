//
//  TableViewCell.swift
//  TestModelswift
//
//  Created by Zzcz on 2017/2/9.
//  Copyright © 2017年 fly. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    /*
     在cell中使用model赋值两种方法：
     一，直接声明实现一个函数传入Model即可，例如
     func cellForModel(model : Model) -> () {
     在该函数实现中赋值，在cell实例化后，使用cell的对象调用这个函数，
     cell.cellForModel(modelArray![indexPath.row])

     二，使用set和get方法赋值，
     首先声明两个Model类型的变量，便于代码阅读，这两个变量名称最好相似，一下划线区分它俩的不同
     在其中一个变量后面实现set和get方法，在set方法中赋值，
     在cell实例化后，使用cell的对象调用声明的属性赋值即可，例如
     cell.model = modelArray![indexPath.row]
     */
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var job: UILabel!
    var _model : Model?
    
    var model : Model?{
        get{
            return _model
        }
        set{
            icon.image = UIImage(named: newValue!.image)
            name.text = newValue!.name
            job.text = newValue!.job
            _model = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func cellForModel(model : Model) -> () {
        icon.image = UIImage(named: model.image)
        name.text = model.name
        job.text = model.job
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
