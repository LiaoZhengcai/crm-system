package com.crm.service;

import com.crm.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    //处理用户登录，返回当前用户信息
    User findLoginUser(String loginAct, String loginPwd, String ip) throws Exception;
    //查询所有用户的信息
    List<User> getUserList();
    //修改密码的方法
    boolean updatePwd(String id,String newPwd);

}
