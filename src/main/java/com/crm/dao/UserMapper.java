package com.crm.dao;

import com.crm.domain.User;

import java.util.List;
import java.util.Map;

public interface UserMapper {
    //处理用户登录，返回当前用户信息
    User login(Map<String,String> map);
    //查询所有用户信息
    List<User> getUserList();
    //修改密码
    int updatePwd(Map<String,String> map);
}
