package com.crm.service;

import com.crm.domain.Activity;
import com.crm.domain.Clue;
import com.crm.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean saveClue(Clue clue);

    List<Clue> pageList(int pageNo, int pageSize, Clue clue);

    boolean doDelete(String[] ids);

    Map<String, Object> getUserListAndClue(String id);

    boolean doUpdate(Clue clue);

    Clue toDetail(String id);

    List<Activity> getActivityByClueId(String id);

    List<Activity> getAllActivityByClueId(String id);

    List<Activity> findAllActivity(String clueId);

    boolean relaActivity(String[] aids, String cid);

    boolean unbundActivity(String id);

    List<Activity> getActivityByName(String aname, String clueId);

    boolean doConvert(String clueId, Tran tran,String createBy);
}
