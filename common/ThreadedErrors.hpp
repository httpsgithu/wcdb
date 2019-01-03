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

#ifndef _WCDB_THREADEDERRORS_HPP
#define _WCDB_THREADEDERRORS_HPP

#include <WCDB/Error.hpp>
#include <WCDB/ThreadLocal.hpp>

namespace WCDB {

class ThreadedErrors final {
public:
    static ThreadedErrors *shared();
    const Error &getThreadedError();
    Error &&moveThreadedError();

    void setThreadedError(const Error &error);
    void setThreadedError(Error &&error);

private:
    ThreadLocal<Error> m_errors;
};

} //namespace WCDB

#endif /* _WCDB_THREADEDERRORS_HPP */