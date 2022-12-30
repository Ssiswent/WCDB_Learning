//
//  DBManager.swift
//  WCDB_Learning
//
//  Created by Flamingo on 2021/3/30.
//

import Foundation
import WCDBSwift

class DBManager: NSObject {
    static let shared = DBManager()
    
    let dataBasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask,
                                                           true).last! + "/Ssiswent/WCDB.db"
    var dataBase: Database?
    
    private override init() {
        super.init()
        dataBase = createDb()
    }
    
    /// 创建数据库对象
    private func createDb() -> Database {
        debugPrint("数据库路径==\(dataBasePath)")
        return Database(withPath: dataBasePath)
    }
    
    /// 创建数据库表
    func createTable<T: TableDecodable>(table: String, of tType: T.Type) {
        do {
            try dataBase?.create(table: table, of: tType)
        } catch let error {
            debugPrint("create table error \(error.localizedDescription)")
        }
    }
    
    /// 插入数据
    func insertToDb<T: TableEncodable>(objects: [T] ,intoTable table: String) {
        do {
            try dataBase?.insert(objects: objects, intoTable: table)
        } catch let error {
            debugPrint("insert obj error \(error.localizedDescription)")
        }
    }
    
    /// 删除数据
    func deleteFromDb(fromTable: String, where condition: Condition? = nil) -> Void {
        do {
            try dataBase?.delete(fromTable: fromTable, where:condition)
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
        }
    }
    
    /// 更新数据
    func update<T: TableEncodable>(
        table: String,
        on propertyConvertibleList: [PropertyConvertible],
        with object: T,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) {
        do {
            try dataBase?.update(table: table, on: propertyConvertibleList, with: object, where: condition, orderBy: orderList, limit: limit, offset: offset)
        } catch let error {
            debugPrint(" update obj error \(error.localizedDescription)")
        }
    }
    
    /// 查询数据
    func getObjects<T: TableDecodable>(
        fromTable table: String,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> [T]? {
        var list:[T]?
        do {
            try list = dataBase?.getObjects(fromTable: table, where: condition, orderBy: orderList, limit: limit, offset: offset)
        } catch let error {
            debugPrint("getObjects error \(error.localizedDescription)")
        }
        return list
    }
}
