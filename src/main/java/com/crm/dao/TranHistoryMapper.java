package com.crm.dao;

import com.crm.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranHistoryMapper {

    int doSave(TranHistory tranHistory);

    List<TranHistory> getHistoryListByTranId(String tranId);

    int doDelete(String[] ids);

    int getHistoryListByids(String[] ids);

    List<Map<String,Object>> getTranHistory();
}
