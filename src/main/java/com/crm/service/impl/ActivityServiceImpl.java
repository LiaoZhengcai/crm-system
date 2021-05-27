package com.crm.service.impl;

import com.crm.dao.*;
import com.crm.domain.Activity;
import com.crm.domain.ActivityRemark;
import com.crm.domain.User;
import com.crm.service.ActivityService;
import com.crm.utils.DateTimeUtil;
import com.crm.utils.UUIDUtil;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;
    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private ClueActivityRelationMapper acrMapper;
    @Autowired
    private ContactsActivityRelationMapper carMapper;

    public boolean addActivity(Activity activity) {
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        try {
            activityMapper.addActivity(activity);
            return true;
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    //条件分页查询市场活动信息
    public List<Activity> pageList(int pageNo,int pageSize,Activity activity) {
        //添加分页
        PageHelper.startPage(pageNo,pageSize);
        return activityMapper.pageList(activity);
    }

    //删除市场活动的方法,删除市场活动同的同时，一起删除市场活动关联的备注表信息,关联的线索,关联的联系人
    public boolean doDelete(String[] ids) {
        //删除备注之前做对比，实际查询出来的数量跟实际删除的数量相同才可以。
        try{
            int count1 = activityRemarkMapper.getCountByids(ids);
            int count2 = activityRemarkMapper.deleteByids(ids);
            int count3 = activityMapper.doDelete(ids);
            int count4 = acrMapper.selectCarByActivityId(ids);
            int count5 = acrMapper.deleteCarByActivity(ids);
            int count6 = carMapper.selectCarByActivityId(ids);
            int count7 = carMapper.deleteCarByActivity(ids);
            if(count1==count2&&count3==ids.length&&count4==count5&&count6==count7){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    //获取所有用户信息跟当前市场活动信息
    public Map<String, Object> getUserListAndActivity(String id) {
        List<User> userList = userMapper.getUserList();
        Activity activity = activityMapper.getActivityById(id);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("uList",userList);
        map.put("a",activity);
        return map;
    }

    //执行修改市场活动的方法
    public boolean doUpdate(Activity activity) {
        activity.setEditTime(DateTimeUtil.getSysTime());
        try{
            activityMapper.doUpdate(activity);
            return true;
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    //取当前市场活动，取到市场活动详情页
    public Activity toDetail(String id) {
        Activity activity = activityMapper.toDetail(id);
        return activity;
    }

    //根据市场活动id获取备注信息列表
    public List<ActivityRemark> getRemarkById(String id) {
        List<ActivityRemark> remarkList = activityRemarkMapper.getRemarkById(id);
        return remarkList;
    }

    //删除市场活动备注信息
    public boolean deleteRemark(String id) {
        try {
            int count = activityRemarkMapper.deleteRemark(id);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    //添加市场活动备注的方法
    public boolean savaRemark(ActivityRemark remark) {
        try{
            int count = activityRemarkMapper.savaRemark(remark);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    //修改市场活动备注的方法
    public boolean updateRemark(ActivityRemark remark) {
        try{
            int count = activityRemarkMapper.updateRemark(remark);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    //根据名称模糊查询市场活动
    public List<Activity> showActivityByName(String aname) {
        return activityMapper.showActivityByName(aname);
    }
}
