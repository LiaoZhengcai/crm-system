package com.crm.dao;

import com.crm.domain.Contacts;
import com.crm.domain.Tran;

import java.util.List;

public interface ContactsMapper {

    int saveContacts(Contacts contacts);

    List<Contacts> pageList(Contacts contacts);

    Contacts toDetail(String id);

    int doDeleteByIds(String[] ids);

    int doDeleteById(String id);

    Contacts getContactsById(String id);

    int doUpdate(Contacts contacts);

    List<Contacts> showContactsByName(String cname);

    List<Contacts> getContactsList();

    List<Contacts> getContactsByCustomerId(String id);

    int selectContactsByCustomerIds(String[] ids);

    int doDeleteByCustomerIds(String[] ids);
}
