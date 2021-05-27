package com.crm.service;

import com.crm.domain.Activity;
import com.crm.domain.Contacts;
import com.crm.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    List<Contacts> pageList(int pageNo, int pageSize, Contacts contacts);

    Contacts toDetail(String id);

    Map<String, Object> getUserAndCustomerList();

    boolean saveContacts(Contacts contacts);

    boolean doDeleteByIds(String[] ids);

    boolean doDeleteById(String id);

    Map<String, Object> getUserAndCustomerAndContacts(String id);

    boolean doUpdate(Contacts contacts);

    List<Contacts> showContactsByName(String cname);

    List<Tran> getTranByContactsId(String id);

    boolean unbundTran(String id);

    List<Activity> getActivityByContactsId(String id);

    boolean unbundActivity(String id);

    List<Activity> findAllActivity(String contactsId);

    List<Activity> getActivityByName(String aname, String contactsId);

    boolean relaActivity(String[] aids, String cid);
}
