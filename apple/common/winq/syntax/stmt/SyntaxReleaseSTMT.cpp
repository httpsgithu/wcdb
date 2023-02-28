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

#include <WCDB/Syntax.h>
#include <WCDB/SyntaxAssertion.hpp>

namespace WCDB {

namespace Syntax {

ReleaseSTMT::~ReleaseSTMT() = default;

bool ReleaseSTMT::isValid() const
{
    return !savepoint.empty();
}

#pragma mark - Identifier
Identifier::Type ReleaseSTMT::getType() const
{
    return type;
}

bool ReleaseSTMT::describle(std::ostream& stream) const
{
    stream << "RELEASE " << savepoint;
    return true;
}

} // namespace Syntax

} // namespace WCDB