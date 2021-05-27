package com.crm.dao;

import com.crm.domain.Customer;

import java.util.List;

public interface CustomerMapper {

    int saveCustomer(Customer customer);

    List<Customer> pageList(Customer customer);

    int doDelete(String[] ids);

    Customer getCustomerById(String id);

    int doUpdate(Customer customer);

    Customer getCustomerByName(String name);

    Customer toDetail(String id);

    List<Customer> getCustomerList();
}
