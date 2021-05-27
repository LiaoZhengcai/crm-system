package com.crm.service.impl;

import com.crm.dao.ContactsMapper;
import com.crm.dao.CustomerMapper;
import com.crm.dao.TranMapper;
import com.crm.dao.UserMapper;
import com.crm.domain.Contacts;
import com.crm.domain.Customer;
import com.crm.domain.Tran;
import com.crm.domain.User;
import com.crm.service.CustomerService;
import com.crm.utils.DateTimeUtil;
import com.crm.utils.UUIDUtil;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private ContactsMapper contactsMapper;

    public boolean saveCustomer(Customer customer) {
        customer.setId(UUIDUtil.getUUID());
        customer.setCreateTime(DateTimeUtil.getSysTime());
        try{
            int count = customerMapper.saveCustomer(customer);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public List<Customer> pageList(int pageNo, int pageSize, Customer customer) {
        //添加分页
        PageHelper.startPage(pageNo,pageSize);
        return customerMapper.pageList(customer);
    }

    public boolean doDelete(String[] ids) {
        try{
            int count = customerMapper.doDelete(ids);
            int count1 = contactsMapper.selectContactsByCustomerIds(ids);
            int count2 = contactsMapper.doDeleteByCustomerIds(ids);
            int count3 = tranMapper.selectTranByCustomerIds(ids);
            int count4 = tranMapper.doDeleteByCustomerIds(ids);
            if(count==ids.length&&count1==count2&&count3==count4){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public Map<String, Object> getUserListAndCustomer(String id) {
        List<User> userList = userMapper.getUserList();
        Customer customer = customerMapper.getCustomerById(id);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("uList",userList);
        map.put("c",customer);
        return map;
    }

    public boolean doUpdate(Customer customer) {
        customer.setEditTime(DateTimeUtil.getSysTime());
        try {
            int count = customerMapper.doUpdate(customer);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public Customer toDetail(String id) {
        return customerMapper.toDetail(id);
    }

    public List<Tran> getTranByCustomerId(String id) {
        List<Tran> tranList = tranMapper.getTranByCustomerId(id);
        return tranList;
    }

    public List<Contacts> getContactsByCustomerId(String id) {
        List<Contacts> contactsList = contactsMapper.getContactsByCustomerId(id);
        return contactsList;
    }

    public boolean unbundTran(String id) {
        try{
            int count = tranMapper.deleteById(id);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public boolean unbundContacts(String id) {
        try{
            int count = contactsMapper.doDeleteById(id);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }
}
