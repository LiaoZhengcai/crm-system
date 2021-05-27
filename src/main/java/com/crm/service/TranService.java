package com.crm.service;

import com.crm.domain.Tran;
import com.crm.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {

    List<Tran> pageList(int pageNo, int pageSize, Tran tran);

    Tran toDetail(String id);

    Map<String, Object> getUserAndCustomer();

    boolean saveTran(Tran tran);

    Map<String, Object> getUserAndCustomerAndTran(String id);

    boolean updateTran(Tran tran);

    List<TranHistory> getHistoryByTranId(String id);

    boolean doDelete(String[] ids);
}
