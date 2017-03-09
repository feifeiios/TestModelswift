# TestModelswift
数据模型


使用swift给模型赋值：
赋值方法三种：
     一，属性逐一赋值
     二，在构造函数中赋值
     三，重写setValuesForKeysWithDictionary赋值
     对于构造函数（或是重写setValuesForKeysWithDictionary方法）赋值，操作如下：
          声明一个静态字符串数组，由属性所对应的键（key）构成
          使用for循环遍历静态字符串数组，
          在for循环遍历里，使用key取出dictionary的value，并赋值给Model
          setValue(value: AnyObject?, forKey: String)
        for循环可以写在构造函数中，
        也可以使用重写setValuesForKeysWithDictionary的方法实现
代码：
class Model: NSObject {
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
 }
调用：
         /*一
        模型对象，属性逐一赋值
         */
        let model = Model.init();
        model.name = "Lily"
        model.job = "teacher"
        model.image = "icon"
        
        /*
        二
        使用构造函数赋值
         */
        let m = Model.init(dict: ["name":"lily","job":"Student","image":"icon"])
        
        /*
         三
         重写setValuesForKeysWithDictionary赋值
         
         */
        let model = Model.init();
        model.setValuesForKeysWithDictionary(["name":"lily","job":"Student","image":"icon"])
        
swift中的set和get方法
声明：
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
    
使用：
        cell.model = modelArray![indexPath.row]

使用swift用模型给view赋值
以TableViewCell为例，
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
代码示例：
class TableViewCell: UITableViewCell {
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
 
    func cellForModel(model : Model) -> () {
        icon.image = UIImage(named: model.image)
        name.text = model.name
        job.text = model.job
    }

}

调用代码示例：
        /*
         一
         使用函数赋值
         */
        cell.cellForModel(modelArray![indexPath.row])

        /*
         二
         使用set方法赋值
         */
        cell.model = modelArray![indexPath.row]



