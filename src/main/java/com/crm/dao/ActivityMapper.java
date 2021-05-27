package com.crm.dao;

import com.crm.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    //添加市场活动的方法
    boolean addActivity(Activity activity);
    //条件分页查询市场活动的方法
    List<Activity> pageList(Activity activity);
    //删除市场活动的方法,返回受影响条数
    int doDelete(String[] ids);
    //根据id获取市场活动信息
    Activity getActivityById(String id);
    //修改市场活动的方法
    boolean doUpdate(Activity activity);
    //取当前市场活动，市场活动详情页
    Activity toDetail(String id);

    List<Activity> findAllActivity(String clueId);

    List<Activity> getActivityByName(Map<String, String> map);

    List<Activity> showActivityByName(String aname);

    List<Activity> getActivityList();
}
