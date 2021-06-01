package com.crm.service.impl;

import com.crm.dao.UserMapper;
import com.crm.domain.User;
import com.crm.exception.LoginException;
import com.crm.service.UserService;
import com.crm.utils.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
//@Transactional(isolation = Isolation.READ_COMMITTED)
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    //处理用户登录，返回当前用户信息
    public User findLoginUser(String loginAct, String loginPwd, String ip) throws LoginException{
        Map<String,String> map = new HashMap<String, String>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userMapper.login(map);
        if(user==null){
            throw new LoginException("账号密码错误");
        }
        //如果不为空，继续判断账号时效是否过期
        String expirTime = user.getExpireTime();
        String currenTime = DateTimeUtil.getSysTime();
        //对比系统当前时间，如果小于0，说明小于当前系统时间，为过失效账号
        if(expirTime.compareTo(currenTime)<0){
            throw new LoginException("账号已失效");
        }
        //判断是否为锁定状态
        String lockState = user.getLockState();
        if("0".equals(lockState)){
            throw new LoginException("账号已锁定，请联系管理员");
        }
        //判断IP地址是否有效
        String allowIps = user.getAllowIps();
        if(!allowIps.contains(ip)){
            throw new LoginException("此IP:"+ip+"为无效IP，请联系管理员");
        }
        return  user;
    }

    //查询所有用户的信息
    public List<User> getUserList() {
        List<User> userList = userMapper.getUserList();
        return userList;
    }

    public boolean updatePwd(String id, String newPwd) {
        Map<String,String> map = new HashMap<String, String>();
        map.put("id",id);
        map.put("newPwd",newPwd);
        try{
            int count = userMapper.updatePwd(map);
            if(count==1){
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

}
