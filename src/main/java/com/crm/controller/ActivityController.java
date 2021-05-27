package com.crm.controller;

import com.crm.domain.Activity;
import com.crm.domain.ActivityRemark;
import com.crm.domain.User;
import com.crm.service.ActivityService;
import com.crm.service.UserService;
import com.crm.utils.DateTimeUtil;
import com.crm.utils.UUIDUtil;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/activity")
public class ActivityController {
    @Autowired
    private ActivityService activityService;
    @Autowired
    private UserService userService;

    @RequestMapping(value = "/getUserList")
    @ResponseBody
    //查询所有用户信息，为表单所有者赋值
    public List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping(value = "/addActivity")
    @ResponseBody
    //添加活动信息
    public boolean addActivity(Activity activity){
        if(activityService.addActivity(activity)){
            return true;
        }else{
            return false;
        }
    }

    @RequestMapping(value = "/pageList")
    @ResponseBody
    //条件分页查询查询市场活动信息列表,默认pageNo=1,pageSize=5
    public PageInfo pageList(@RequestParam(name = "pageNo",required = true,defaultValue = "1") int pageNo,@RequestParam(name = "pageSize",required = true,defaultValue = "5") int pageSize, Activity activity){
        List<Activity> pageList = activityService.pageList(pageNo,pageSize,activity);
        PageInfo pageInfo = new PageInfo(pageList);
        return pageInfo;
    }

    @RequestMapping(value = "/doDelete")
    @ResponseBody
    //执行批量删除的方法
    public boolean doDelete(String[] xz){
        if(activityService.doDelete(xz)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/getUserListAndActivity/{id}")
    @ResponseBody
    //执行修改前先去拿到所有用户信息跟当前要修改的市场活动信息
    public Map<String,Object> getUserListAndActivity(@PathVariable(value = "id") String id){
        Map<String,Object> map = activityService.getUserListAndActivity(id);
        return map;
    }

    @RequestMapping(value = "/doUpdate")
    @ResponseBody
    //执行修改的方法
    public boolean doUpdate(Activity activity){
        if (activityService.doUpdate(activity)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/toDetail/{id}")
    //取当前市场活动，市场活动详情页
    public String toDetail(@PathVariable(value = "id") String id, HttpServletRequest request){
        Activity activity = activityService.toDetail(id);
        request.setAttribute("activity",activity);
        return "workbench/activity/detail";
    }

    @RequestMapping(value = "/getRemarkById")
    @ResponseBody
    //根据当前市场活动获取当前市场活动的备注信息
    public List<ActivityRemark> getRemarkById(String id){
        List<ActivityRemark> ramarkList = activityService.getRemarkById(id);
        return ramarkList;
    }

    @RequestMapping(value = "/deleteRemark")
    @ResponseBody
    //删除市场活动的操作
    public boolean deleteRemark(String id){
        if(activityService.deleteRemark(id)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/savaRemark")
    @ResponseBody
    //添加市场活动备注的操作
    public Map<String,Object> savaRemark(ActivityRemark remark){
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateTimeUtil.getSysTime());
        remark.setEditFlag("0");
        //添加成功返回当前添加的备注信息用于响应拼接动态html
        boolean flag = activityService.savaRemark(remark);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",flag);
        map.put("rm",remark);
        return map;
    }

    @RequestMapping(value = "/updateRemark")
    @ResponseBody
    //修改市场活动备注的操作
    public Map<String,Object> updateRemark(ActivityRemark remark){
        remark.setEditTime(DateTimeUtil.getSysTime());
        remark.setEditFlag("1");
        //修改成功返回当前修改的备注信息用于响应拼接动态html
        boolean flag = activityService.updateRemark(remark);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",flag);
        map.put("rm",remark);
        return map;
    }

}
