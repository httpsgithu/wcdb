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

#import "BackupTestCase.h"
#import <WCDB/CoreConst.h>

@implementation BackupTestCase

- (void)setUp
{
    [super setUp];
    [self insertPresetObjects];
}

- (int)backupFramesIntervalForNonCritical
{
    return WCDB::BackupConfigFramesIntervalForNonCritical;
}

- (int)backupFramesIntervalForCritical
{
    return WCDB::BackupConfigFramesIntervalForCritical;
}

- (NSTimeInterval)backupDelayForCritical
{
    return WCDB::BackupQueueDelayForCritical;
}

- (NSTimeInterval)backupDelayForNonCritical
{
    return WCDB::BackupQueueDelayForNonCritical;
}

- (NSTimeInterval)delayForTolerance
{
    return 1.0;
}

- (int)framesForTolerance
{
    return 10;
}

- (BOOL)tryToMakeHeaderCorrupted
{
    if (![self.database execute:WCDB::StatementPragma().pragma(WCDB::Pragma::walCheckpoint()).with("TRUNCATE")]) {
        TestCaseFailure();
        return NO;
    }
    __block BOOL result = NO;
    [self.database close:^{
        NSFileHandle* fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.path];
        if (fileHandle == nil) {
            TestCaseFailure();
            return;
        }
        [fileHandle writeData:[self.random dataWithLength:self.headerSize]];
        [fileHandle closeFile];
        result = YES;
    }];
    return result;
}

@end