package com.crm.controller;

import com.crm.domain.Activity;
import com.crm.domain.Contacts;
import com.crm.domain.Tran;
import com.crm.domain.TranHistory;
import com.crm.service.*;
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
@RequestMapping(value = "/tran")
public class TranController {
    @Autowired
    private TranService tranService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;

    @RequestMapping(value = "/pageList")
    @ResponseBody
    //条件分页查询查询市场活动信息列表,默认pageNo=1,pageSize=5
    public PageInfo pageList(@RequestParam(name = "pageNo",required = true,defaultValue = "1") int pageNo, @RequestParam(name = "pageSize",required = true,defaultValue = "5") int pageSize, Tran tran){
        List<Tran> pageList = tranService.pageList(pageNo,pageSize,tran);
        PageInfo pageInfo = new PageInfo(pageList);
        return pageInfo;
    }

    @RequestMapping(value = "/toDetail/{id}")
    //取当前交易信息，去交易信息详情页
    public String toDetail(@PathVariable(value = "id") String id, HttpServletRequest request){
        Tran tran = tranService.toDetail(id);
        request.setAttribute("t",tran);
        return "workbench/transaction/detail";
    }

    //取用户信息跟客户信息去到创建交易页面
    @RequestMapping(value = "/toSave")
    public String toSave(HttpServletRequest request){
        Map<String,Object> map = tranService.getUserAndCustomer();
        request.setAttribute("ucList",map);
        return "workbench/transaction/save";
    }

    //添加交易
    @RequestMapping(value = "/saveTran")
    public String saveTran(Tran tran){
        if(tranService.saveTran(tran)){
            return "redirect:/tran/toSave";
        }
        return "redirect:/workbench/transaction/index.jsp";
    }


    //根据名称查找市场活动源
    @RequestMapping(value = "/showActivityByName")
    @ResponseBody
    public List<Activity> showActivityByName(String aname){
        List<Activity> activityList = activityService.showActivityByName(aname);
        return activityList;
    }

    //根据名称查找联系人信息
    @RequestMapping(value = "/showContactsByName")
    @ResponseBody
    public List<Contacts> showContactsByName(String cname){
        List<Contacts> contactsList = contactsService.showContactsByName(cname);
        return contactsList;
    }

    //获取数据取到修改页面
    @RequestMapping(value = "/getUserAndCustomerAndTran/{id}")
    public String getUserAndCustomerAndTran(@PathVariable(value = "id") String id,HttpServletRequest request){
        Map<String,Object> map = tranService.getUserAndCustomerAndTran(id);
        request.setAttribute("uct",map);
        return "workbench/transaction/edit";
    }

    //执行修改的方法
    @RequestMapping(value = "/updateTran")
    public String updateTran(Tran tran){
        tranService.updateTran(tran);
        return "redirect:/workbench/transaction/index.jsp";
    }

    //根据当前交易Id查询交易历史
    @RequestMapping(value = "/getHistoryByTranId")
    @ResponseBody
    public List<TranHistory> getHistoryByTranId(String id){
        List<TranHistory> historyList = tranService.getHistoryByTranId(id);
        return historyList;
    }

    //执行删除的方法
    @RequestMapping(value = "/doDelete")
    @ResponseBody
    public boolean doDelete(String[] xz){
        if(tranService.doDelete(xz)){
            return true;
        }
        return false;
    }

}
