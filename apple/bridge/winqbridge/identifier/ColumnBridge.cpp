//
// Created by qiuwenchen on 2022/5/26.
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

#include "ColumnBridge.h"
#include "Column.hpp"
#include "Expression.hpp"
#include "ObjectBridge.hpp"
#include "Schema.hpp"

CPPColumn WCDBColumnCreateAll()
{
    return WCDBCreateCPPBridgedObject(CPPColumn, WCDB::Column::all());
}

CPPColumn WCDBColumnCreateRowId()
{
    return WCDBCreateCPPBridgedObject(CPPColumn, WCDB::Column::rowid());
}

CPPColumn WCDBColumnCreateWithName(const char* _Nullable name, const void* _Nullable binding)
{
    return WCDBCreateCPPBridgedObject(
    CPPColumn,
    new WCDB::Column(WCDB::UnsafeStringView(name),
                     static_cast<const WCDB::BaseBinding*>(binding)));
}

void WCDBColumnInTable(CPPColumn column, const char* _Nullable table)
{
    WCDBGetObjectOrReturn(column, WCDB::Column, cppColumn);
    cppColumn->table(table);
}

void WCDBColumnOfSchema(CPPColumn column, CPPSchema schema)
{
    WCDBGetObjectOrReturn(column, WCDB::Column, cppColumn);
    WCDBGetObjectOrReturn(schema, WCDB::Schema, cppSchema);
    cppColumn->schema(*cppSchema);
}

CPPExpression WCDBColumnAsExpressionOperand(CPPColumn column)
{
    WCDBGetObjectOrReturnValue(column, WCDB::Column, cppColumn, CPPExpression());
    return WCDBCreateCPPBridgedObject(CPPExpression, new WCDB::Expression(*cppColumn));
}
