package com.crm.service;

import com.crm.domain.Contacts;
import com.crm.domain.Customer;
import com.crm.domain.Tran;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    boolean saveCustomer(Customer customer);

    List<Customer> pageList(int pageNo, int pageSize, Customer customer);

    boolean doDelete(String[] ids);

    Map<String, Object> getUserListAndCustomer(String id);

    boolean doUpdate(Customer customer);

    Customer toDetail(String id);

    List<Tran> getTranByCustomerId(String id);

    List<Contacts> getContactsByCustomerId(String id);

    boolean unbundTran(String id);

    boolean unbundContacts(String id);
}
