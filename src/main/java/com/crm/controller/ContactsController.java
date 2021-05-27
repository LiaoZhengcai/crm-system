package com.crm.controller;

import com.crm.domain.Activity;
import com.crm.domain.Contacts;
import com.crm.domain.Customer;
import com.crm.domain.Tran;
import com.crm.service.ContactsService;
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
@RequestMapping(value = "/contacts")
public class ContactsController {
    @Autowired
    private ContactsService contactsService;

    @RequestMapping(value = "/pageList")
    @ResponseBody
    //条件分页查询查询市场活动信息列表,默认pageNo=1,pageSize=5
    public PageInfo pageList(@RequestParam(name = "pageNo",required = true,defaultValue = "1") int pageNo, @RequestParam(name = "pageSize",required = true,defaultValue = "5") int pageSize, Contacts contacts){
        List<Contacts> pageList = contactsService.pageList(pageNo,pageSize,contacts);
        PageInfo pageInfo = new PageInfo(pageList);
        return pageInfo;
    }

    @RequestMapping(value = "/toDetail/{id}")
    //取当前联系人信息，去联系人信息详情页
    public String toDetail(@PathVariable(value = "id") String id, HttpServletRequest request){
        Contacts contacts = contactsService.toDetail(id);
        request.setAttribute("cn",contacts);
        return "workbench/contacts/detail";
    }

    @RequestMapping(value = "/getUserAndCustomerList")
    @ResponseBody
    //添加联系人信息的方法，先取得用户信息和客户信息
    public Map<String,Object> getUserAndCustomerList(){
        return contactsService.getUserAndCustomerList();
    }

    @RequestMapping(value = "/saveContacts")
    @ResponseBody
    //添加联系人信息
    public boolean saveContacts(Contacts contacts){
        if(contactsService.saveContacts(contacts)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/doDeleteByIds")
    @ResponseBody
    //批量删除
    public boolean doDeleteByIds(String[] xz){
        if(contactsService.doDeleteByIds(xz)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/doDeleteById")
    @ResponseBody
    //根据Id单个删除
    public boolean doDeleteByIds(String id){
        if(contactsService.doDeleteById(id)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/getUserAndCustomerAndContacts/{id}")
    @ResponseBody
    //执行修改前先去拿到所有用户信息跟当前要修改的客户信息和联系人信息
    public Map<String,Object> getUserAndCustomerAndContacts(@PathVariable(value = "id") String id){
        return contactsService.getUserAndCustomerAndContacts(id);
    }

    @RequestMapping(value = "/doUpdate")
    @ResponseBody
    //执行修改前先去拿到所有用户信息跟当前要修改的客户信息和联系人信息
    public boolean doUpdate(Contacts contacts){
        if(contactsService.doUpdate(contacts)){
            return true;
        }
        return false;
    }

    //获取关联的交易数据
    @RequestMapping(value = "/getTranByContactsId")
    @ResponseBody
    public List<Tran> getTranByContactsId(String id){
        List<Tran> tranList = contactsService.getTranByContactsId(id);
        return tranList;
    }

    //删除交易信息
    @RequestMapping(value = "/unbundTran")
    @ResponseBody
    public boolean unbundTran(String id){
        return contactsService.unbundTran(id);
    }

    @RequestMapping(value = "/getActivityByContactsId")
    @ResponseBody
    //根据当前联系人找到对应的多个市场活动，ID为tbl_contacts_activity_relation关联表ID，用作解除关联
    public List<Activity> getActivityByContactsId(String id){
        List<Activity> activityList = contactsService.getActivityByContactsId(id);
        return activityList;
    }

    @RequestMapping(value = "/unbundActivity")
    @ResponseBody
    //解除关联交易的方法
    public boolean unbundActivity(String id){
        if(contactsService.unbundActivity(id)){
            return true;
        }
        return false;
    }

    //查询所有市场活动，用作关联选择，去除当前联系人已关联过的市场活动
    @RequestMapping(value = "/findAllActivity")
    @ResponseBody
    public List<Activity> findAllActivity(String contactsId){
        List<Activity> activityList = contactsService.findAllActivity(contactsId);
        return activityList;
    }

    //根据名称模糊查询市场活动的方法，去除当前线索已关联过的市场活动
    @RequestMapping(value = "/getActivityByName")
    @ResponseBody
    public List<Activity> getActivityByName(String aname,String contactsId){
        List<Activity> activityList = contactsService.getActivityByName(aname,contactsId);
        return activityList;
    }

    //关联市场活动的方法
    @RequestMapping(value = "/relaActivity")
    @ResponseBody
    public boolean relaActivity(String[] aids,String cid){
        if(contactsService.relaActivity(aids,cid)){
            return true;
        }
        return false;
    }

}
