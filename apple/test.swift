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
import WCDB

class test: WCDB.Tokenizer {

    required init(args: [String]) {
    }

    func load(input: UnsafePointer<Int8>?, length: Int, flags: Int/* flags is only used in FTS5 */) {
    }

    func nextToken(ppToken: UnsafeMutablePointer<UnsafePointer<Int8>?>,
                   pnBytes: UnsafeMutablePointer<Int32>,
                   piStart: UnsafeMutablePointer<Int32>,
                   piEnd: UnsafeMutablePointer<Int32>,
                   pFlags: UnsafeMutablePointer<Int32>?,// pFlags is only used in FTS5
                   piPosition: UnsafeMutablePointer<Int32>?// iPosition is only used in FTS3/4
    ) -> WCDB.TokenizerErrorCode {
        if /* done */ {
            return .Done
        }
        return.OK
    }
}
