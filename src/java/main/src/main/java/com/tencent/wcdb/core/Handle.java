// Created by qiuwenchen on 2023/4/19.
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
package com.tencent.wcdb.core;

import com.tencent.wcdb.base.CppObject;
import com.tencent.wcdb.base.WCDBException;
import com.tencent.wcdb.winq.Statement;

import org.jetbrains.annotations.NotNull;

public class Handle extends HandleORMOperation implements AutoCloseable {
    private PreparedStatement mainStatement = null;
    private final Database database;

    private boolean writeHint = false;

    Handle(Database database, boolean writeHint) {
        this.database = database;
        this.writeHint = writeHint;
    }

    Handle(long cppObj, Database database) {
        this.cppObj = cppObj;
        this.database = database;
    }

    public long getCppHandle() throws WCDBException {
        if(cppObj == 0) {
            assert database != null;
            cppObj = Database.getHandle(CppObject.get(database), writeHint);
            if(cppObj == 0) {
                throw database.createException();
            }
        }
        return cppObj;
    }

    WCDBException createException() {
        return WCDBException.createException(getError(cppObj));
    }

    static native long getError(long self);

    /**
     * Use {@code sqlite3_prepare} internally to prepare a new statement, and wrap the {@code sqlite3_stmt} generated by {@code sqlite3_prepare} into {@link PreparedStatement} to return.
     * If the statement has been prepared by this function before, and you have not used {@link Handle#invalidate()}, {@link Handle#close()}, {@link Handle#finalizeAllStatements()}.
     * then you can use this function to regain the previously generated {@code sqlite3_stmt}.
     * Note that this function is designed for the situation where you need to use multiple statements at the same time to do complex database operations.
     * You can prepare a new statement without finalizing the previous statements, so that you can save the time of analyzing SQL syntax.
     * If you only need to use one statement, or you no longer need to use the previous statements when you use a new statement,
     * it is recommended to use {@link HandleOperation#execute(Statement)} or {@link Handle#preparedWithMainStatement(Statement)}.
     * @see #preparedWithMainStatement(Statement)
     * @param statement The statement to prepare.
     * @return A wrapper of {@code sqlite3_stmt}.
     * @throws WCDBException of any error occurs.
     */
    @NotNull
    public PreparedStatement getOrCreatePreparedStatement(@NotNull Statement statement) throws WCDBException {
        long cppPreparedStatement = getOrCreatePreparedStatement(getCppHandle(), CppObject.get(statement));
        if(cppPreparedStatement == 0) {
            throw createException();
        }
        return new PreparedStatement(cppPreparedStatement);
    }

    static native long getOrCreatePreparedStatement(long self, long statement);

    /**
     * Use {@code sqlite3_prepare} internally to prepare a new statement, and wrap the {@code sqlite3_stmt} generated by {@code sqlite3_prepare} into {@link PreparedStatement} to return.
     * Note that you should not execute sql string on any migrating or compressing table.
     * @see #preparedWithMainStatement(Statement)
     * @param sql The sql string to prepare.
     * @return A wrapper of {@code sqlite3_stmt}.
     * @throws WCDBException of any error occurs.
     */
    @NotNull
    public PreparedStatement getOrCreatePreparedStatement(@NotNull String sql) throws WCDBException {
        long cppPreparedStatement = getOrCreatePreparedStatementWithSQL(getCppHandle(), sql);
        if(cppPreparedStatement == 0) {
            throw createException();
        }
        return new PreparedStatement(cppPreparedStatement);
    }

    static native long getOrCreatePreparedStatementWithSQL(long self, String sql);

    /**
     * Use {@code sqlite3_prepare} internally to prepare a new statement.
     * You should firstly use {@link PreparedStatement#finalizeStatement()} to finalize the previous statement prepared by this method.
     * If you need to prepare multiple statements at the same time, {@link Handle#getOrCreatePreparedStatement(Statement)} is recommended.
     * @param statement The statement to prepare.
     * @return A wrapper of {@code sqlite3_stmt}.
     * @throws WCDBException of any error occurs.
     */
    @NotNull
    public PreparedStatement preparedWithMainStatement(@NotNull Statement statement) throws WCDBException {
        if(mainStatement == null) {
            mainStatement = new PreparedStatement(getMainStatement(getCppHandle()));
            mainStatement.autoFinalize = true;
        }
        mainStatement.prepare(statement);
        return mainStatement;
    }

    /**
     * Use {@code sqlite3_prepare} internally to prepare a new statement.
     * Note that you should not execute sql string on any migrating or compressing table.
     * @see #preparedWithMainStatement(Statement)
     * @param sql The sql string to prepare.
     * @return A wrapper of {@code sqlite3_stmt}.
     * @throws WCDBException of any error occurs.
     */
    @NotNull
    public PreparedStatement preparedWithMainStatement(@NotNull String sql) throws WCDBException {
        if(mainStatement == null) {
            mainStatement = new PreparedStatement(getMainStatement(getCppHandle()));
            mainStatement.autoFinalize = true;
        }
        mainStatement.prepare(sql);
        return mainStatement;
    }

    static native long getMainStatement(long self);

    /**
     * Use {@code sqlite3_finalize} to finalize all {@code sqlite3_stmt} generate by current handle.
     * {@link Handle#invalidate()} will internally call the current function.
     */
    public void finalizeAllStatements() {
        if(cppObj > 0){
            finalizeAllStatements(cppObj);
        }
    }


    static native void finalizeAllStatements(long self);

    /**
     * Recycle the sqlite db handle inside, and the current handle will no longer be able to perform other operations.
     * If you use obtain current handle through {@link Database#getHandle()}, you need to call its invalidate method when you are done with it, otherwise you will receive an Assert Failure.
     */
    public void invalidate() {
        mainStatement = null;
        if(cppObj != 0) {
            releaseCPPObject(cppObj);
            cppObj = 0;
            writeHint = false;
        }
    }

    /**
     * Sample to {@link Handle#invalidate()}
     */
    @Override
    public void close() {
        invalidate();
    }

    static native int tableExist(long self, String tableName);

    static native boolean execute(long self, long statement);

    static native boolean executeSQL(long self, String sql);

    /**
     * The wrapper of {@code sqlite3_changes}.
     * @return changes.
     */
    public int getChanges() throws WCDBException {
        return getChanges(getCppHandle());
    }

    static native int getChanges(long self);

    /**
     * The wrapper of {@code sqlite3_total_changes}.
     * @return changes.
     */
    public int getTotalChanges() throws WCDBException {
        return getTotalChanges(getCppHandle());
    }

    static native int getTotalChanges(long self);

    /**
     * The wrapper of {@code sqlite3_last_insert_rowid}.
     * @return the rowid of the last inserted row.
     * @throws WCDBException if any error occurs.
     */
    public long getLastInsertedRowId() throws WCDBException {
        return getLastInsertedRowId(getCppHandle());
    }

    static native long getLastInsertedRowId(long self);

    static native boolean isInTransaction(long self);

    static native boolean beginTransaction(long self);

    static native boolean commitTransaction(long self);

    static native void rollbackTransaction(long self);

    @Override
    Handle getHandle(boolean writeHint) {
        return this;
    }

    @Override
    Database getDatabase() {
        return database;
    }

    @Override
    boolean autoInvalidateHandle() {
        return false;
    }

    private boolean onTransaction(long cppHandle, Transaction transaction) {
        Handle handle = new Handle(cppHandle, database);
        boolean ret;
        try {
            ret = transaction.insideTransaction(handle);
        } catch (WCDBException e) {
            ret = false;
        }
        return ret;
    }

    native boolean runTransaction(long self, Transaction transaction);

    private int onPausableTransaction(long cppHandle, PausableTransaction transaction, boolean isNewTransaction) {
        Handle handle = new Handle(cppHandle, database);
        int ret;
        try {
            ret = transaction.insideTransaction(handle, isNewTransaction) ? 1 : 0;
        } catch (WCDBException e) {
            ret = 2;
        }
        return ret;
    }

    native boolean runPausableTransaction(long self, PausableTransaction transaction);


    public static class CancellationSignal extends CppObject {
        public CancellationSignal() {
            cppObj = createCancellationSignal();
        }
        /**
         * Cancel all operations of the attached handle.
         */
        public void cancel() {
            cancelSignal(cppObj);
        }
    }

    private static native long createCancellationSignal();
    private static native void cancelSignal(long signal);

    /**
     * The wrapper of {@code sqlite3_progress_handler}.
     * You can asynchronously cancel all operations on the current handle through {@link CancellationSignal}.
     * Note that you can use {@link CancellationSignal} in multiple threads,
     * but you can only use the current handle in the thread that you got it.
     * @param signal A signal to cancel operation.
     * @throws WCDBException if any error occurs.
     */
    public void attachCancellationSignal(@NotNull CancellationSignal signal) throws WCDBException {
        attachCancellationSignal(getCppHandle(), CppObject.get(signal));
    }

    private static native void attachCancellationSignal(long self, long signal);

    /**
     * Detach the attached {@link CancellationSignal}.
     * {@link CancellationSignal} can be automatically detached when the current handle deconstruct.
     */
    public void detachCancellationSignal() {
        if(cppObj != 0) {
            detachCancellationSignal(cppObj);
        }
    }

    private static native void detachCancellationSignal(long self);

}