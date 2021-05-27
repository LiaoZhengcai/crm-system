package com.crm.service.impl;

import com.crm.dao.*;
import com.crm.domain.*;
import com.crm.service.ClueService;
import com.crm.utils.DateTimeUtil;
import com.crm.utils.UUIDUtil;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private ActivityMapper activityMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;

    public boolean saveClue(Clue clue){
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        try{
            int count = clueMapper.saveClue(clue);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public List<Clue> pageList(int pageNo,int pageSize,Clue clue) {
        //添加分页
        PageHelper.startPage(pageNo,pageSize);
        return clueMapper.pageList(clue);
    }

    public boolean doDelete(String[] ids) {
        try{
            int count = clueMapper.doDelete(ids);
            int count1 = clueActivityRelationMapper.selectCarByClueIds(ids);
            int count2 = clueActivityRelationMapper.doDeleteByClueIds(ids);
            if(count==ids.length&&count1==count2){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public Map<String, Object> getUserListAndClue(String id) {
        List<User> userList = userMapper.getUserList();
        Clue clue = clueMapper.getClueListById(id);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("uList",userList);
        map.put("c",clue);
        return map;
    }

    public boolean doUpdate(Clue clue) {
        clue.setEditTime(DateTimeUtil.getSysTime());
        try{
            int count = clueMapper.doUpdate(clue);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public Clue toDetail(String id) {
        Clue clue = clueMapper.toDetail(id);
        return clue;
    }

    public List<Activity> getActivityByClueId(String id) {
        List<Activity> activityList = clueActivityRelationMapper.getActivityByClueId(id);
        return activityList;
    }

    public List<Activity> getAllActivityByClueId(String id) {
        List<Activity> activityList = clueActivityRelationMapper.getAllActivityByClueId(id);
        return activityList;
    }

    public List<Activity> findAllActivity(String clueId) {
        List<Activity> activityList = activityMapper.findAllActivity(clueId);
        return activityList;
    }

    public List<Activity> getActivityByName(String aname, String clueId) {
        Map<String,String> map = new HashMap<String, String>();
        map.put("aname",aname);
        map.put("clueId",clueId);
        List<Activity> activityList = activityMapper.getActivityByName(map);
        return activityList;
    }

    public boolean unbundActivity(String id) {
        try{
            int count = clueActivityRelationMapper.unbundActivity(id);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public boolean relaActivity(String[] aids, String cid) {
        for (String aid:aids) {
            //取得每一个aid和cid做关联
            ClueActivityRelation car = new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setActivityId(aid);
            car.setClueId(cid);
            int count = clueActivityRelationMapper.relaActivity(car);
            if(count!=1){
                return false;
            }
        }
        return true;
    }

    public boolean doConvert(String clueId, Tran tran,String createBy) {
        boolean flag = true;
        String createTime = DateTimeUtil.getSysTime();
        //通过线索id获取线索对象
        Clue clue = clueMapper.getClueListById(clueId);
        //通过线索对象提取客户信息，当客户不存在，新建客户（根据公司的名称精确查询，判断该客户是否存在）
        String company = clue.getCompany();
        Customer customer = customerMapper.getCustomerByName(company);
        //如果为空，说明没有这个客户，需要创建
        if(customer==null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setAddress(clue.getAddress());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setOwner(clue.getOwner());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setName(company);
            customer.setDescription(clue.getDescription());
            customer.setCreateTime(createTime);
            customer.setCreateBy(createBy);
            customer.setContactSummary(clue.getContactSummary());
            //添加客户
            int count1 = customerMapper.saveCustomer(customer);
            if(count1!=1){
                flag = false;
            }
        }
        //通过线索对象提取联系人信息，保存联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setFullname(clue.getFullname());
        contacts.setEmail(clue.getEmail());
        contacts.setDescription(clue.getDescription());
        contacts.setCustomerId(customer.getId());
        contacts.setCreateTime(createTime);
        contacts.setCreateBy(createBy);
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setAppellation(clue.getAppellation());
        contacts.setAddress(clue.getAddress());
        //添加联系人
        int count2 = contactsMapper.saveContacts(contacts);
        if(count2!=1){
            flag = false;
        }

        //把“线索和市场活动”的关系转换到“联系人和市场活动”的关系
        //查询出与该条线索关联的市场活动，查询与市场活动的关联关系列表
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.getListByClueId(clueId);
        //遍历出每一条与市场活动关联的关联关系记录
        for(ClueActivityRelation clueActivityRelation : clueActivityRelationList){
            //从每一条遍历出来的记录中取出关联的市场活动id
            String activityId = clueActivityRelation.getActivityId();
            //创建 联系人与市场活动的关联关系对象 让第三步生成的联系人与市场活动做关联
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(activityId);
            contactsActivityRelation.setContactsId(contacts.getId());
            //添加联系人与市场活动的关联关系
            int count3 = contactsActivityRelationMapper.doSave(contactsActivityRelation);
            if(count3!=1){
                flag = false;
            }
        }

        //如果有创建交易需求，创建一条交易
        //tran对象在controller里面已经封装好的信息如下：id,money,name,expectedDate,stage,activityId,createBy,createTime
        if(tran.getName()!=null){
            tran.setSource(clue.getSource());
            tran.setOwner(clue.getOwner());
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setDescription(clue.getDescription());
            tran.setCustomerId(customer.getId());
            tran.setContactSummary(clue.getContactSummary());
            tran.setContactsId(contacts.getId());
            tran.setType("新业务");
            //添加交易
            int count4 = tranMapper.doSave(tran);
            if(count4!=1){
                flag = false;
            }

            //如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(createTime);
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setStage(tran.getStage());
            tranHistory.setTranId(tran.getId());
            //添加交易历史
            int count5 = tranHistoryMapper.doSave(tranHistory);
            if(count5!=1){
                flag = false;
            }
        }

        //删除线索和市场活动的关系
        for(ClueActivityRelation clueActivityRelation : clueActivityRelationList){
            int count6 = clueActivityRelationMapper.doDelete(clueActivityRelation);
            if(count6!=1){
                flag = false;
            }
        }

        //删除线索
        int count7 = clueMapper.deleteByClueId(clueId);
        if(count7!=1){
            flag = false;
        }

        return flag;
    }
}






























