package com.crm.service.impl;

import com.crm.dao.*;
import com.crm.domain.*;
import com.crm.service.ContactsService;
import com.crm.utils.DateTimeUtil;
import com.crm.utils.UUIDUtil;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    public List<Contacts> pageList(int pageNo, int pageSize, Contacts contacts) {
        PageHelper.startPage(pageNo,pageSize);
        return contactsMapper.pageList(contacts);
    }

    public Contacts toDetail(String id) {
        return contactsMapper.toDetail(id);
    }

    public Map<String, Object> getUserAndCustomerList() {
        Map<String,Object> map = new HashMap<String, Object>();
        List<User> userList = userMapper.getUserList();
        List<Customer> customerList = customerMapper.getCustomerList();
        map.put("u",userList);
        map.put("c",customerList);
        return map;
    }

    public boolean saveContacts(Contacts contacts) {
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        try {
            int count = contactsMapper.saveContacts(contacts);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public boolean doDeleteByIds(String[] ids) {
        try {
            int count = contactsMapper.doDeleteByIds(ids);
            int count1 = contactsActivityRelationMapper.selectCarByContactsIds(ids);
            int count2 = contactsActivityRelationMapper.doDeleteByContactsIds(ids);
            if(count==ids.length&&count1==count2){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public boolean doDeleteById(String id) {
        try {
            int count = contactsMapper.doDeleteById(id);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public Map<String, Object> getUserAndCustomerAndContacts(String id) {
        Map<String,Object> map = new HashMap<String, Object>();
        List<User> userList = userMapper.getUserList();
        List<Customer> customerList = customerMapper.getCustomerList();
        Contacts contacts = contactsMapper.getContactsById(id);
        map.put("u",userList);
        map.put("cu",customerList);
        map.put("co",contacts);
        return map;
    }

    public boolean doUpdate(Contacts contacts) {
        contacts.setEditTime(DateTimeUtil.getSysTime());
        try {
            int count = contactsMapper.doUpdate(contacts);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public List<Contacts> showContactsByName(String cname) {
        return contactsMapper.showContactsByName(cname);
    }

    public List<Tran> getTranByContactsId(String id) {
        return tranMapper.getTranByContactsId(id);
    }

    public boolean unbundTran(String id) {
        try {
            int count = tranMapper.deleteById(id);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public List<Activity> getActivityByContactsId(String id) {
        return contactsActivityRelationMapper.getActivityByContactsId(id);
    }

    public boolean unbundActivity(String id) {
        try{
            int count = contactsActivityRelationMapper.unbundActivity(id);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public List<Activity> findAllActivity(String contactsId) {
        return contactsActivityRelationMapper.findAllActivity(contactsId);
    }

    public List<Activity> getActivityByName(String aname, String contactsId) {
        Map<String,String> map = new HashMap<String, String>();
        map.put("aname",aname);
        map.put("contactsId",contactsId);
        List<Activity> activityList = contactsActivityRelationMapper.getActivityByName(map);
        return activityList;
    }

    public boolean relaActivity(String[] aids, String cid) {
        boolean flag = true;
        for (String aid:aids) {
            //取得每一个aid和cid做关联
            ContactsActivityRelation car = new ContactsActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setActivityId(aid);
            car.setContactsId(cid);
            int count = contactsActivityRelationMapper.relaActivity(car);
            if(count!=1){
                flag = false;
            }
        }
        return flag;
    }
}
