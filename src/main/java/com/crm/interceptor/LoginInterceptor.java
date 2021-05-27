package com.crm.interceptor;

import com.crm.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
            String path = request.getServletPath();
            //把跟登录有关的URL都放行
            if ("/login.jsp".equals(path) || "/user/doLogin".equals(path)){
                return true;
            }else{
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                //如果User不为空，说明登录过，不拦截
                if (user != null){
                    return true;
                }else{
                    //获取当前请求的路径
                    String basePath = request.getScheme() + "://" + request.getServerName() + ":"  + request.getServerPort()+request.getContextPath();
                    //如果有ajax请求，需要特殊处理。
                    if("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))){
                        //告诉ajax我是重定向
                        response.setHeader("SESSIONSTATUS", "TIMEOUT");
                        //告诉ajax我重定向的路径
                        response.setHeader("CONTEXTPATH", basePath+"/login.jsp");
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        return false;
                    }else{
                        response.sendRedirect(request.getContextPath() + "/login.jsp");
                        return false;
                    }

                }
        }
    }
}
