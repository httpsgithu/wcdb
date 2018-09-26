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

#ifndef HandlePool_hpp
#define HandlePool_hpp

#include <WCDB/Abstract.h>
#include <WCDB/Config.hpp>
#include <WCDB/ErrorProne.hpp>
#include <WCDB/Lock.hpp>
#include <WCDB/RecyclableHandle.hpp>
#include <WCDB/ThreadedErrors.hpp>
#include <list>

namespace WCDB {

class HandlePool : public ThreadedErrorProne {
#pragma mark - Initialize
public:
    HandlePool() = delete;
    HandlePool(const HandlePool &) = delete;
    HandlePool &operator=(const HandlePool &) = delete;

    HandlePool(const std::string &path);
    const std::string path;

    virtual ~HandlePool();

#pragma mark - Config
public:
    void setConfigs(const std::shared_ptr<Configs> &configs);
    void setConfig(const std::string &name,
                   const std::shared_ptr<Config> &config,
                   int priority = Configs::Priority::Default);
    void removeConfig(const std::string &name);

private:
    std::shared_ptr<Configs> m_configs;

#pragma mark - Concurrency
public:
    void blockade();
    bool isBlockaded() const;
    void unblockade();

    typedef std::function<void(void)> DrainedCallback;
    void drain(const HandlePool::DrainedCallback &onDrained);
    bool isDrained() const;

    static int hardwareConcurrency();
    static int maxConcurrency();

protected:
    bool allowedConcurrent();
    int m_aliveHandleCount;
    mutable SharedLock m_concurrency;

#pragma mark - Handle
public:
    bool canFlowOut();
    RecyclableHandle flowOut();
    void purge();

protected:
    virtual std::shared_ptr<Handle> generateHandle() = 0;
    virtual void handleWillFlowBack(Handle *handle) = 0;

    mutable SharedLock m_lock;

private:
    std::shared_ptr<ConfiguredHandle> generateConfiguredHandle();
    std::shared_ptr<ConfiguredHandle> flowOutConfiguredHandle();
    void flowBackConfiguredHandle(const std::shared_ptr<ConfiguredHandle> &configuredHandle);
    void flowBack(const std::shared_ptr<ConfiguredHandle> &configuredHandle);

    std::list<std::shared_ptr<ConfiguredHandle>> m_handles;
};

} //namespace WCDB

#endif /* HandlePool_hpp */