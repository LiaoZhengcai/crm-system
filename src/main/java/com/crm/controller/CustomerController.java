package com.crm.controller;

import com.crm.domain.Contacts;
import com.crm.domain.Customer;
import com.crm.domain.Tran;
import com.crm.domain.User;
import com.crm.service.CustomerService;
import com.crm.service.UserService;
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
@RequestMapping(value = "/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;
    @Autowired
    private UserService userService;

    @RequestMapping(value = "/getUserList")
    @ResponseBody
    //查询所有用户信息，为表单所有者赋值
    public List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    //添加客户的方法
    @RequestMapping(value = "/saveCustomer")
    @ResponseBody
    public boolean saveCustomer(Customer customer) {
        if(customerService.saveCustomer(customer)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/pageList")
    @ResponseBody
    //条件分页查询查询客户信息列表,默认pageNo=1,pageSize=5
    public PageInfo pageList(@RequestParam(name = "pageNo",required = true,defaultValue = "1") int pageNo, @RequestParam(name = "pageSize",required = true,defaultValue = "5") int pageSize, Customer customer){
        List<Customer> pageList = customerService.pageList(pageNo,pageSize,customer);
        PageInfo pageInfo = new PageInfo(pageList);
        return pageInfo;
    }

    @RequestMapping(value = "/doDelete")
    @ResponseBody
    //执行批量删除的方法
    public boolean doDelete(String[] xz){
        if(customerService.doDelete(xz)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/getUserListAndCustomer/{id}")
    @ResponseBody
    //执行修改前先去拿到所有用户信息跟当前要修改的客户信息
    public Map<String,Object> getUserListAndCustomer(@PathVariable(value = "id") String id){
        Map<String,Object> map = customerService.getUserListAndCustomer(id);
        return map;
    }

    @RequestMapping(value = "/doUpdate")
    @ResponseBody
    //执行修改的方法
    public boolean doUpdate(Customer customer){
        if (customerService.doUpdate(customer)){
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/toDetail/{id}")
    //取当前客户信息，去客户信息详情页
    public String toDetail(@PathVariable(value = "id") String id, HttpServletRequest request){
        Customer customer = customerService.toDetail(id);
        request.setAttribute("cu",customer);
        return "workbench/customer/detail";
    }

    //获取关联的交易数据
    @RequestMapping(value = "/getTranByCustomerId")
    @ResponseBody
    public List<Tran> getTranByCustomerId(String id){
        List<Tran> tranList = customerService.getTranByCustomerId(id);
        return tranList;
    }

    //获取关联的联系人数据
    @RequestMapping(value = "/getContactsByCustomerId")
    @ResponseBody
    public List<Contacts> getContactsByCustomerId(String id){
        List<Contacts> contactsList = customerService.getContactsByCustomerId(id);
        return contactsList;
    }

    //删除交易信息
    @RequestMapping(value = "/unbundTran")
    @ResponseBody
    public boolean unbundTran(String id){
        return customerService.unbundTran(id);
    }

    //删除联系人信息
    @RequestMapping(value = "/unbundContacts")
    @ResponseBody
    public boolean unbundContacts(String id){
        return customerService.unbundContacts(id);
    }



}
