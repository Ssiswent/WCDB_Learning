//
//  AddPersonVC.swift
//  WCDB_Learning
//
//  Created by Flamingo on 2021/3/29.
//

import UIKit
import WCDBSwift
import YPNavigationBarTransition
import SVProgressHUD

class AddPersonVC: UIViewController {
    
    @IBOutlet weak var nameTextF: UITextField!
    @IBOutlet weak var sexTextF: UITextField!
    @IBOutlet weak var ageTextF: UITextField!
    
    var addSuccessBlock: (() -> Void)?
    var changeSuccessBlock: (() -> Void)?
    
    enum PersonEditType {
        case edit
        case add
    }
    var editType: PersonEditType = .add
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setNavBtn()
        if editType == .add {
            setTitle("添加用户")
        } else if editType == .edit {
            setTitle("编辑用户")
            if let p = person {
                nameTextF.text = p.name
                sexTextF.text = p.sex
                if let age = p.age {
                    ageTextF.text = "\(age)"
                }
            }
        }
    }
    
    func setNavBtn() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "btn_back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(popBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "btn_confirm").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addPerson))
    }
    
    @objc func popBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addPerson() {
        guard let name = nameTextF.text,
              let sex = sexTextF.text,
              let ageText = ageTextF.text,
              let age = Int(ageText) else {
            
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showError(withStatus: "信息填写不全或有误")
            SVProgressHUD.dismiss(withDelay: 1)
            return
        }
        let p = person ?? Person()
        p.name = name
        p.sex = sex
        p.age = age
        
        if editType == .add {
            //数据库中新增一个人物
            DBManager.shared.insertToDb(objects: [p], intoTable: TB_Person)
            if addSuccessBlock != nil {
                addSuccessBlock!()
            }
        } else if editType == .edit {
            //修改一个数据库中的人物
            DBManager.shared.update(table: TB_Person,
                                    on: Person.Properties.all,
                                    with: p)
            if changeSuccessBlock != nil {
                changeSuccessBlock!()
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension AddPersonVC: NavigationBarConfigureStyle
{
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        YPNavigationBarConfigurations(rawValue: 0)
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        .black
    }
    
    //    func yp_navigationBackgroundColor() -> UIColor! {
    //        .white
    //    }
}
