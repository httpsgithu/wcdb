//
// Created by qiuwenchen on 2022/5/30.
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

#include "CommonTableExpressionBridge.h"
#include "CommonTableExpression.hpp"
#include "ObjectBridge.hpp"
#include "StatementSelect.hpp"
#include "WinqBridge.hpp"

CPPCommonTableExpression WCDBCommonTableExpressionCreate(const char* _Nullable tableName)
{
    return WCDBCreateCPPBridgedObject(CPPCommonTableExpression,
                                      WCDB::CommonTableExpression(tableName));
}

void WCDBCommonTableExpressionAddColumn(CPPCommonTableExpression expression, CPPColumn column)
{
    WCDBGetObjectOrReturn(expression, WCDB::CommonTableExpression, cppCTE);
    WCDBGetObjectOrReturn(column, WCDB::Column, cppColumn);
    cppCTE->column(*cppColumn);
}

void WCDBCommonTableExpressionAsSelection(CPPCommonTableExpression expression,
                                          CPPStatementSelect select)
{
    WCDBGetObjectOrReturn(expression, WCDB::CommonTableExpression, cppCTE);
    WCDBGetObjectOrReturn(select, WCDB::StatementSelect, cppSelect);
    cppCTE->as(*cppSelect);
}
