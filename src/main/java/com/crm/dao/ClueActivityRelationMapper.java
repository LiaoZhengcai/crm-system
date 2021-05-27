package com.crm.dao;

import com.crm.domain.Activity;
import com.crm.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {
    List<Activity> getActivityByClueId(String id);

    List<Activity> getAllActivityByClueId(String id);

    int relaActivity(ClueActivityRelation car);

    int unbundActivity(String id);

    int deleteCarByActivity(String[] ids);

    int selectCarByActivityId(String[] ids);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int doDelete(ClueActivityRelation clueActivityRelation);

    int selectCarByClueIds(String[] ids);

    int doDeleteByClueIds(String[] ids);
}
