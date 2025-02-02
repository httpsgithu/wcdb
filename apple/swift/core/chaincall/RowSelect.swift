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
import WCDB_Private

/// Chain call for row-selecting
public final class RowSelect: Selectable {
    init(with handle: Handle,
         results columnResultConvertibleList: [ResultColumnConvertible],
         tables: [String],
         isDistinct: Bool) {
        let statement = StatementSelect().select(distinct: isDistinct, columnResultConvertibleList).from(tables)
        super.init(with: handle, statement: statement)
    }

    private func extract(atIndex index: Int) throws -> Value {
        try lazyPrepareStatement()
        switch handle.columnType(atIndex: index) {
        case .integer32:
            return Value(handle.columnValue(atIndex: index, of: Int32.self))
        case .integer64:
            return Value(handle.columnValue(atIndex: index, of: Int64.self))
        case .float:
            return Value(handle.columnValue(atIndex: index, of: Double.self))
        case .text:
            return Value(handle.columnValue(atIndex: index, of: String.self))
        case .BLOB:
            return Value(handle.columnValue(atIndex: index, of: Data.self))
        case .null:
            return Value(nil)
        }
    }

    private func extract() throws -> OneRowValue {
        var row: OneRowValue = []
        try lazyPrepareStatement()
        for index in 0..<handle.columnCount() {
            row.append(try extract(atIndex: index))
        }
        return row
    }

    /// Get next selected row. You can do an iteration using it.
    ///
    ///     while let row = try rowSelect.nextRow() {
    ///         print(row[0].int32Value)
    ///         print(row[1].int64Value)
    ///         print(row[2].doubleValue)
    ///         print(row[3].stringValue)
    ///     }
    ///
    /// - Returns: Array with `Value`. Nil means the end of iteration.
    /// - Throws: `Error`
    public func nextRow() throws -> OneRowValue? {
        guard try next() else {
            return nil
        }
        return try extract()
    }

    /// Get all selected row.
    ///
    /// - Returns: Array with `Array<Value>`
    /// - Throws: `Error`
    public func allRows() throws -> MultiRowsValue {
        var rows: [[Value]] = []
        while try next() {
            rows.append(try extract())
        }
        return rows
    }

    /// Get next selected value. You can do an iteration using it.
    ///
    ///     while let value = try nextValue() {
    ///         print(value.int32Value)
    ///     }
    ///
    /// - Returns: `Value`. Nil means the end of iteration.
    /// - Throws: `Error`
    public func nextValue() throws -> Value? {
        guard try next() else {
            return nil
        }
        return try extract(atIndex: 0)
    }

    /// Get all selected values.
    ///
    /// - Returns: Array with `Value`.
    /// - Throws: `Error`
    public func allValues() throws -> OneColumnValue {
        var values: [Value] = []
        while try next() {
            values.append(try extract(atIndex: 0))
        }
        return values
    }
}
