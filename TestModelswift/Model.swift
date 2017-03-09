//
//  Model.swift
//  TestModelswift
//
//  Created by Zzcz on 2017/2/9.
//  Copyright © 2017年 fly. All rights reserved.
//

import UIKit

class Model: NSObject {
    /*
     swift数据模型 
     声明属性
     赋值方法三种：
     一，属性逐一赋值
     二，在构造函数中赋值
     三，重写setValuesForKeysWithDictionary赋值
     对于构造函数（或是重写setValuesForKeysWithDictionary方法）赋值，操作如下：
          声明一个静态字符串数组，由属性所对应的键（key）构成
          使用for循环遍历静态字符串数组，
          在for循环遍历里，使用key取出dictionary的value，并赋值给Model
          setValue(value: AnyObject?, forKey: <#T##String#>)
        for循环可以写在构造函数中，
        也可以使用重写setValuesForKeysWithDictionary的方法实现
        override func setValuesForKeysWithDictionary(keyedValues: [String : AnyObject]) {}
     */
    var name = ""
    var job = ""
    var image = ""
    
    static let properties = ["name","job","image"]
    
    override init() {
        super.init()
    }
    
    init(dict : [String : AnyObject?]) {
        super.init()
        for key in Model.properties {
            if dict[key] != nil {
                setValue(dict[key]!, forKey: key)
            }
        }
    }
    
    override func setValuesForKeysWithDictionary(keyedValues: [String : AnyObject]) {
        for key in Model.properties {
            if keyedValues[key] != nil {
                setValue(keyedValues[key]!, forKey: key)
            }
        }
    }
    override var description: String {
        let dict = dictionaryWithValuesForKeys(Model.properties)
        return ("\(dict)")
    }
}
