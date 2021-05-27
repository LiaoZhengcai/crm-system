package com.crm.service.impl;

import com.crm.dao.*;
import com.crm.domain.*;
import com.crm.service.TranService;
import com.crm.utils.DateTimeUtil;
import com.crm.utils.UUIDUtil;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Autowired
    private ActivityMapper activityMapper;
    @Autowired
    private ContactsMapper contactsMapper;

    public List<Tran> pageList(int pageNo, int pageSize, Tran tran) {
        PageHelper.startPage(pageNo,pageSize);
        return tranMapper.pageList(tran);
    }

    public Tran toDetail(String id) {
        return tranMapper.toDetail(id);
    }

    public Map<String, Object> getUserAndCustomer() {
        Map<String,Object> map = new HashMap<String, Object>();
        List<User> userList = userMapper.getUserList();
        List<Customer> customerList = customerMapper.getCustomerList();
        map.put("uList",userList);
        map.put("cList",customerList);
        return map;
    }

    public boolean saveTran(Tran tran) {
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        try{
            int count = tranMapper.doSave(tran);
            //如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setCreateBy(tran.getCreateBy());
            tranHistory.setCreateTime(DateTimeUtil.getSysTime());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setStage(tran.getStage());
            tranHistory.setTranId(tran.getId());
            //添加交易历史
            int count2 = tranHistoryMapper.doSave(tranHistory);
            if(count==1&&count2==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public Map<String, Object> getUserAndCustomerAndTran(String id) {
        Map<String,Object> map = new HashMap<String, Object>();
        List<User> userList = userMapper.getUserList();
        List<Customer> customerList = customerMapper.getCustomerList();
        List<Activity> activityList = activityMapper.getActivityList();
        List<Contacts> contactsList = contactsMapper.getContactsList();
        Tran tran = tranMapper.getTranById(id);
        map.put("uList",userList);
        map.put("cuList",customerList);
        map.put("aList",activityList);
        map.put("coList",contactsList);
        map.put("tran",tran);
        return map;
    }

    public boolean updateTran(Tran tran) {
        boolean flag = true;
        tran.setEditTime(DateTimeUtil.getSysTime());
        String newStage = tran.getStage();
        Tran tran1 = tranMapper.getTranById(tran.getId());
        String oldStage = tran1.getStage();
        try {
            int count = tranMapper.updateTran(tran);
            if(count!=1){
                flag = false;
            }
            //如果修改了交易阶段，就要创建一条交易历史记录
            if(!oldStage.equals(newStage)){
                TranHistory tranHistory = new TranHistory();
                tranHistory.setId(UUIDUtil.getUUID());
                tranHistory.setCreateBy(tran.getEditBy());
                tranHistory.setCreateTime(DateTimeUtil.getSysTime());
                tranHistory.setExpectedDate(tran.getExpectedDate());
                tranHistory.setMoney(tran.getMoney());
                tranHistory.setStage(newStage);
                tranHistory.setTranId(tran.getId());
                int count1 = tranHistoryMapper.doSave(tranHistory);
                if(count1!=1){
                    flag = false;
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return flag;
    }

    public List<TranHistory> getHistoryByTranId(String id) {
        List<TranHistory> historyList = tranHistoryMapper.getHistoryListByTranId(id);
        return historyList;
    }

    public boolean doDelete(String[] ids) {
        try{
            int count = tranMapper.doDelete(ids);
            int count1 = tranHistoryMapper.getHistoryListByids(ids);
            int count2 = tranHistoryMapper.doDelete(ids);
            if(count==ids.length&&count1==count2){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }
}
