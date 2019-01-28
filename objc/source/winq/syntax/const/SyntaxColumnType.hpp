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

#ifndef _WCDB_SYNTAXCOLUMNTYPE_HPP
#define _WCDB_SYNTAXCOLUMNTYPE_HPP

#include <WCDB/Enum.hpp>

namespace WCDB {

class String;

namespace Syntax {

enum class ColumnType {
    Null = 0,
    Integer32,
    Integer64,
    Float,
    Text,
    BLOB,
};

bool isIntegerType(const String& type);

} // namespace Syntax

template<>
constexpr const char* Enum::description(const Syntax::ColumnType& columnType)
{
    switch (columnType) {
    case Syntax::ColumnType::Null:
        return "NULL";
    case Syntax::ColumnType::Integer32:
    case Syntax::ColumnType::Integer64:
        return "INTEGER";
    case Syntax::ColumnType::Float:
        return "REAL";
    case Syntax::ColumnType::Text:
        return "TEXT";
    case Syntax::ColumnType::BLOB:
        return "BLOB";
    }
}

} // namespace WCDB

#endif /* _WCDB_SYNTAXCOLUMNTYPE_HPP */