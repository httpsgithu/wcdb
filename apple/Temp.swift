//
// Created by qiuwenchen on 2023/3/8.
//

/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import WCDBSwift

class Temp: WCDBSwift.TableCodable {
    //Your own properties
    var variable1: Int = 0
    var variable2: String? // Optional if it would be nil in some WCDB selection.
    var variable3: Double? // Optional if it would be nil in some WCDB selection.
    let invalid: Int = 0 // An initialized constant property is not allowed.
    let unbound: Date? = nil

    enum CodingKeys: String, CodingTableKey {
        typealias Root = Temp

        //List the properties which should be bound to table.
        case variable1 = "custom_name"
        case variable2
        case variable3

        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        //static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
        //    return [
        //        .variable1: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true),
        //        .variable2: ColumnConstraintBinding(isUnique: true)
        //    ]
        //}

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

    //Properties below are needed when the primary key is auto-increment.
    //var isAutoIncrement: Bool = false
    //var lastInsertedRowID: Int64 = 0
}
