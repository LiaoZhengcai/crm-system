package com.crm.service;

import com.crm.domain.Activity;
import com.crm.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    //添加市场活动的方法
    boolean addActivity(Activity activity);

    //条件分页查询市场活动信息
    List<Activity> pageList(int pageNo,int pageSize,Activity activity);

    //删除市场活动的方法
    boolean doDelete(String[] ids);

    //获取所有用户信息跟当前市场活动信息
    Map<String,Object> getUserListAndActivity(String id);

    //执行修改市场活动的方法
    boolean doUpdate(Activity activity);

    //取当前市场活动，市场活动详情页
    Activity toDetail(String id);

    //根据市场活动id获取备注信息列表
    List<ActivityRemark> getRemarkById(String id);

    //删除市场活动备注信息
    boolean deleteRemark(String id);

    //添加市场活动备注的方法
    boolean savaRemark(ActivityRemark remark);

    //修改市场活动备注的方法
    boolean updateRemark(ActivityRemark remark);

    List<Activity> showActivityByName(String aname);
}
