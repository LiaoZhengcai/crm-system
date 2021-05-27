package com.crm.dao;

import com.crm.domain.TranHistory;

import java.util.List;

public interface TranHistoryMapper {

    int doSave(TranHistory tranHistory);

    List<TranHistory> getHistoryListByTranId(String tranId);

    int doDelete(String[] ids);

    int getHistoryListByids(String[] ids);
}
