package com.crm.dao;

import com.crm.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    //执行查询受影响条数
    int getCountByids(String[] ids);
    //执行删除受影响条数
    int deleteByids(String[] ids);
    //根据市场活动id获取备注信息列表
    List<ActivityRemark> getRemarkById(String id);
    //删除市场活动备注信息
    int deleteRemark(String id);
    //添加市场活动备注
    int savaRemark(ActivityRemark remark);
    //修改市场活动备注的方法
    int updateRemark(ActivityRemark remark);

}
