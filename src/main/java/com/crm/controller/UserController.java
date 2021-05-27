package com.crm.controller;

import com.crm.domain.User;
import com.crm.service.UserService;
import com.crm.utils.MD5Util;
import com.crm.utils.PrintJson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/user")
public class UserController {

    @Autowired
    public UserService userService;

    @RequestMapping(value = "/doLogin")
    @ResponseBody
    //处理用户登录控制器
    public void doLogin(String loginAct, String loginPwd, HttpServletRequest request, HttpServletResponse response){
        //记录原密码
        String loginPwd2 = loginPwd;
        //将密码转换成MD5格式
        loginPwd = MD5Util.getMD5(loginPwd);
        //接收IP地址
        String ip = request.getRemoteAddr();
        try {
            User user = userService.findLoginUser(loginAct,loginPwd,ip);
            //将未加密的的密码保存到会话中
            user.setLoginPwd(loginPwd2);
            request.getSession().setAttribute("user",user);
            PrintJson.printJsonFlag(response,true);
        }catch (Exception e){
            //用户登录异常,封装错误信息返回给用户
            Map<String,Object> map = new HashMap<String, Object>();
            map.put("success",false);
            map.put("msg", e.getMessage());
            PrintJson.printJsonObj(response,map);
        }
    }
    //处理用户退出，清除会话
    @RequestMapping(value = "/logout")
    public String logout(HttpSession session){
        //清除session
        session.invalidate();
        //重定向到登录页面的跳转方法
        return "redirect:/login.jsp";
    }

    //用户修改密码
    @RequestMapping(value = "/updatePwd")
    @ResponseBody
    public boolean updatePwd(String id,String newPwd){
        newPwd = MD5Util.getMD5(newPwd);
        if(userService.updatePwd(id,newPwd)){
            return true;
        }
        return false;
    }
}
