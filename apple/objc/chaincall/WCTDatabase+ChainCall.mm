//
// Created by sanhuazhang on 2019/05/02
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

#import <WCDB/WCTChainCall+Private.h>
#import <WCDB/WCTDatabase+ChainCall.h>
#import <WCDB/WCTDatabase+Handle.h>
#import <WCDB/WCTDelete.h>
#import <WCDB/WCTInsert.h>
#import <WCDB/WCTMultiSelect.h>
#import <WCDB/WCTSelect.h>
#import <WCDB/WCTUpdate.h>

@implementation WCTDatabase (ChainCall)

- (WCTInsert *)prepareInsert
{
    return [[[WCTInsert alloc] initWithHandle:[self getHandle]] invalidateWhenDispose];
}

- (WCTDelete *)prepareDelete
{
    return [[[WCTDelete alloc] initWithHandle:[self getHandle]] invalidateWhenDispose];
}

- (WCTUpdate *)prepareUpdate
{
    return [[[WCTUpdate alloc] initWithHandle:[self getHandle]] invalidateWhenDispose];
}

- (WCTSelect *)prepareSelect
{
    return [[[WCTSelect alloc] initWithHandle:[self getHandle]] invalidateWhenDispose];
}

- (WCTMultiSelect *)prepareMultiSelect
{
    return [[[WCTMultiSelect alloc] initWithHandle:[self getHandle]] invalidateWhenDispose];
}

@end
