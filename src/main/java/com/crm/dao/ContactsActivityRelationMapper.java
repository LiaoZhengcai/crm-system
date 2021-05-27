package com.crm.dao;

import com.crm.domain.Activity;
import com.crm.domain.ClueActivityRelation;
import com.crm.domain.ContactsActivityRelation;

import java.util.List;
import java.util.Map;

public interface ContactsActivityRelationMapper {

    int doSave(ContactsActivityRelation contactsActivityRelation);

    List<Activity> getActivityByContactsId(String id);

    int unbundActivity(String id);

    List<Activity> findAllActivity(String contactsId);

    List<Activity> getActivityByName(Map<String, String> map);

    int relaActivity(ContactsActivityRelation contactsActivityRelation);

    int selectCarByActivityId(String[] ids);

    int deleteCarByActivity(String[] ids);

    int selectCarByContactsIds(String[] ids);

    int doDeleteByContactsIds(String[] ids);
}
