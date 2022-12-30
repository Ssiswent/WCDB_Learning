//
//  PersonListVC.swift
//  WCDB_Learning
//
//  Created by Flamingo on 2021/3/29.
//

import UIKit
import SnapKit
import YPNavigationBarTransition
import SVProgressHUD

let TB_Person = "tb_person"

class PersonListVC: UIViewController {
    
    private var dataArray: [Person]?
    
    var searchBar: UISearchBar!
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setTitle("用户列表")
        setAddBtn()
        setSearchBar()
        setTableView()
        DBManager.shared.createTable(table: TB_Person, of: Person.self)
        dataArray = searchFor()
        tableView.reloadData()
    }
    
    func setAddBtn() {
        let addBtn = UIBarButtonItem.init(image: #imageLiteral(resourceName: "btn_add").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(pushAddVC))
        navigationItem.rightBarButtonItem = addBtn
    }
    
    @objc func pushAddVC() {
        let vc = AddPersonVC()
        vc.addSuccessBlock = { [self] in
            dataArray = searchFor()
            tableView.reloadData()
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showSuccess(withStatus: "添加成功!")
            SVProgressHUD.dismiss(withDelay: 0.5)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 44))
        searchBar.delegate = self
        searchBar.placeholder = "输入想要搜索的名字"
        searchBar.setShowsCancelButton(true, animated: true)
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(KDeviceTopHeight)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    func searchFor(name: String? = "") -> [Person]? {
        let persons: [Person]? = DBManager.shared.getObjects(fromTable: TB_Person, where: Person.Properties.name.like("%\(name ?? "")%"))
        return persons
    }
    
    func setTableView()
    {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - KBottomSafeAreaValue), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(PersonCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-KBottomSafeAreaValue)
        }
    }
}

extension PersonListVC {
    /// 删除动作
    private func deleteAction(indexPath: IndexPath) {
        let cancleAction = UIAlertAction(title: "取消", style: .cancel)
        let confirmAction = UIAlertAction(title: "确定", style: .default) { (action) in
            
            guard let p = self.dataArray?[indexPath.row]  else {
                return
            }
            
            DBManager.shared.deleteFromDb(fromTable: TB_Person, where: p.id)
            SVProgressHUD.showSuccess(withStatus: "删除成功!")
            self.dataArray?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let alert = UIAlertController(title: "", message: "是否删除?", preferredStyle: .alert)
        alert.addAction(cancleAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// 编辑动作
    private func editAction(indexPath: IndexPath) {
        let vc = AddPersonVC()
        vc.editType = .edit
        vc.person = dataArray?[indexPath.row]
        vc.changeSuccessBlock = { [self] in
            dataArray = searchFor()
            tableView.reloadData()
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showSuccess(withStatus: "编辑成功!")
            SVProgressHUD.dismiss(withDelay: 0.5)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PersonListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as PersonCell
        cell.model = dataArray?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
            self.deleteAction(indexPath: indexPath)
        }
        deleteAction.backgroundColor = UIColor(hexString: "#000000", alpha: 0)
        deleteAction.image = #imageLiteral(resourceName: "btn_delete")
        let editAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            self.editAction(indexPath: indexPath)
        }
        editAction.backgroundColor = UIColor(hexString: "#000000", alpha: 0)
        editAction.image = #imageLiteral(resourceName: "btn_edit")
        let actions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        // 禁止侧滑到最左边触发删除或者分享编辑事件
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
}

extension PersonListVC: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataArray = searchFor(name: searchText)
        tableView.reloadData()
    }
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension PersonListVC: NavigationBarConfigureStyle
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

public extension UIViewController {
    func setTitle(_ t: String) {
        title = t
        let titleLabel = UILabel()
        
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
}

public extension UIImage {
    //生成圆形图片
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                              y: (shotest-self.size.height)/2,
                              width: self.size.width,
                              height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
}
