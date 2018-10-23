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

#import "WINQTestCase.h"
#import <WCDB/WCDB.h>

@interface IndexedColumnTests : WINQTestCase

@end

@implementation IndexedColumnTests {
    WCDB::Column column;
    WCDB::Expression expression;
    NSString* collation;
    WCDB::Order order;
}

- (void)setUp
{
    [super setUp];
    column = WCDB::Column(@"testColumn");
    expression = column;
    collation = @"testCollation";
    order = WCDB::Order::ASC;
}

- (void)test_default_constructible
{
    WCDB::IndexedColumn constructible __attribute((unused));
}

- (void)test_column
{
    auto testingSQL = WCDB::IndexedColumn(column);

    auto testingTypes = { WCDB::SQL::Type::IndexedColumn, WCDB::SQL::Type::Column };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testColumn");
}

- (void)test_expression
{
    auto testingSQL = WCDB::IndexedColumn(expression);

    auto testingTypes = { WCDB::SQL::Type::IndexedColumn, WCDB::SQL::Type::Expression, WCDB::SQL::Type::Column };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testColumn");
}

- (void)test_collate
{
    auto testingSQL = WCDB::IndexedColumn(column).collate(collation);

    auto testingTypes = { WCDB::SQL::Type::IndexedColumn, WCDB::SQL::Type::Column };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testColumn COLLATE testCollation");
}

- (void)test_order
{
    auto testingSQL = WCDB::IndexedColumn(column).order(order);

    auto testingTypes = { WCDB::SQL::Type::IndexedColumn, WCDB::SQL::Type::Column };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testColumn ASC");
}

WCDB::IndexedColumn acceptable(const WCDB::IndexedColumn& indexedColumn)
{
    return indexedColumn;
}

- (void)test_init
{
    WINQAssertEqual(acceptable(1), @"1");
}

@end