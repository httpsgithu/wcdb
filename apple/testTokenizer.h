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

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

class testTokenizer final
: public WCDB::AbstractFTSTokenizer {
public:
    testTokenizer(const char *const *azArg,
                                        int nArg,
                                        void *pCtx /* pCtx is only used in FTS5 */);
    ~testTokenizer();
    
    void loadInput(const char *pText,
                   int nText,
                   int flags /* flags is only used in FTS5 */) override final;
    
    int nextToken(const char **ppToken,
                  int *nToken,
                  int *iStart,
                  int *iEnd,
                  int *tflags,   //tflags is only used in FTS5
                  int *iPosition //iPosition is only used in FTS3/4
    ) override final;
};
