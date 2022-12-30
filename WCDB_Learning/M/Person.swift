//
//  Person.swift
//  WCDB_Learning
//
//  Created by Flamingo on 2021/3/29.
//

import Foundation
import WCDBSwift

class Person: TableCodable {
    
    var id: Int?
    var name: String?
    var sex: String?
    var age: Int?

    enum CodingKeys: String, CodingTableKey {
        typealias Root = Person
        
        case id
        case name
        case sex
        case age
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .id: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true)
            ]
        }

        //Index bindings. It is optional.
        //static var indexBindings: [IndexBinding.Subfix: IndexBinding]? {
        //    return [
        //        "_index": IndexBinding(indexesBy: CodingKeys.variable2)
        //    ]
        //}

        //Table constraints for multi-primary, multi-unique and so on. It is optional.
        //static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
        //    return [
        //        "MultiPrimaryConstraint": MultiPrimaryBinding(indexesBy: variable2.asIndex(orderBy: .descending), variable3.primaryKeyPart2)
        //    ]
        //}

        //Virtual table binding for FTS and so on. It is optional.
        //static var virtualTableBinding: VirtualTableBinding? {
        //    return VirtualTableBinding(with: .fts3, and: ModuleArgument(with: .WCDB))
        //}
    }

    //Properties below are needed only the primary key is auto-incremental
    var isAutoIncrement: Bool = false
    var lastInsertedRowID: Int64 = 0
}
