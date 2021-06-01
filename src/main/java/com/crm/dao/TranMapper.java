package com.crm.dao;

import com.crm.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranMapper {

    int doSave(Tran tran);

    List<Tran> pageList(Tran tran);

    Tran toDetail(String id);

    Tran getTranById(String id);

    int updateTran(Tran tran);

    int doDelete(String[] ids);

    List<Tran> getTranByCustomerId(String id);

    int deleteById(String id);

    List<Tran> getTranByContactsId(String id);

    int selectTranByCustomerIds(String[] ids);

    int doDeleteByCustomerIds(String[] ids);

    int getTotal();

    List<Map<String, Object>> getChars();
}
