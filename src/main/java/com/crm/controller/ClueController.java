package com.crm.controller;

import com.crm.domain.Activity;
import com.crm.domain.Clue;
import com.crm.domain.Tran;
import com.crm.domain.User;
import com.crm.service.ClueService;
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
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping(value = "/clue")
public class ClueController {
    @Autowired
    private ClueService clueService;
    @Autowired
    private UserService userService;

    @RequestMapping(value = "/getUserList")
    @ResponseBody
    //查询所有用户信息，为添加线索表单所有者赋值
    public List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    //添加线索的方法
    @RequestMapping(value = "/saveClue")
    @ResponseBody
    public boolean saveClue(Clue clue) {
        if(clueService.saveClue(clue)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/pageList")
    @ResponseBody
    //条件分页查询查询市场活动信息列表,默认pageNo=1,pageSize=5
    public PageInfo pageList(@RequestParam(name = "pageNo",required = true,defaultValue = "1") int pageNo, @RequestParam(name = "pageSize",required = true,defaultValue = "5") int pageSize, Clue clue){
        List<Clue> pageList = clueService.pageList(pageNo,pageSize,clue);
        PageInfo pageInfo = new PageInfo(pageList);
        return pageInfo;
    }

    @RequestMapping(value = "/doDelete")
    @ResponseBody
    //执行批量删除的方法
    public boolean doDelete(String[] xz){
        if(clueService.doDelete(xz)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/getUserListAndClue/{id}")
    @ResponseBody
    //执行修改前先去拿到所有用户信息跟当前要修改的线索信息
    public Map<String,Object> getUserListAndActivity(@PathVariable(value = "id") String id){
        Map<String,Object> map = clueService.getUserListAndClue(id);
        return map;
    }

    @RequestMapping(value = "/doUpdate")
    @ResponseBody
    //执行修改的方法
    public boolean doUpdate(Clue clue){
        if (clueService.doUpdate(clue)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/toDetail/{id}")
    //取当前市场活动，市场活动详情页
    public String toDetail(@PathVariable(value = "id") String id, HttpServletRequest request){
        Clue clue = clueService.toDetail(id);
        request.setAttribute("clue",clue);
        return "workbench/clue/detail";
    }

    @RequestMapping(value = "/getActivityByClueId")
    @ResponseBody
    //根据当前线索找到对应的多个市场活动，ID为tbl_clue_activity_relation关联表ID，用作解除关联
    public List<Activity> getActivityByClueId(String id){
        List<Activity> activityList = clueService.getActivityByClueId(id);
        return activityList;
    }

    @RequestMapping(value = "/getAllActivityByClueId")
    @ResponseBody
    //查询当前线索关联的多个市场活动，ID为市场活动表ID
    public List<Activity> getAllActivityByClueId(String id){
        List<Activity> activityList = clueService.getAllActivityByClueId(id);
        return activityList;
    }

    //查询所有市场活动，用作关联选择，去除当前线索已关联过的市场活动
    @RequestMapping(value = "/findAllActivity")
    @ResponseBody
    public List<Activity> findAllActivity(String clueId){
        List<Activity> activityList = clueService.findAllActivity(clueId);
        return activityList;
    }

    //根据名称模糊查询市场活动的方法，去除当前线索已关联过的市场活动
    @RequestMapping(value = "/getActivityByName")
    @ResponseBody
    public List<Activity> getActivityByName(String aname,String clueId){
        List<Activity> activityList = clueService.getActivityByName(aname,clueId);
        return activityList;
    }

    @RequestMapping(value = "/unbundActivity")
    @ResponseBody
    //解除关联的方法
    public boolean unbundActivity(String id){
        if(clueService.unbundActivity(id)){
            return true;
        }
        return false;
    }

    //关联市场活动的方法
    @RequestMapping(value = "/relaActivity")
    @ResponseBody
    public boolean relaActivity(String[] aids,String cid){
        if(clueService.relaActivity(aids,cid)){
            return true;
        }
        return false;
    }

    //线索转换
    @RequestMapping(value = "/doConvert")
    public String doConvert(String clueId, Tran tran,HttpServletRequest request){
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        if(tran.getName()!=null){
            tran.setId(UUIDUtil.getUUID());
            tran.setCreateTime(DateTimeUtil.getSysTime());
            tran.setCreateBy(createBy);
        }
        //1.必须传递的参数clueId，有了这个clueId之后我们才知道要转换哪条记录
        //2.必须传递的参数tran，因为在线索转换的过程中，有可能会临时创建一笔交易
        boolean flag = clueService.doConvert(clueId,tran,createBy);
        if(flag){
            return "redirect:/workbench/clue/index.jsp";
        }
        return "redirect:/clue/toDetail/"+clueId;
    }

}
