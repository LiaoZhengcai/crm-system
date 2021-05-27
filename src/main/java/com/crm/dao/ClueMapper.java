package com.crm.dao;

import com.crm.domain.Clue;

import java.util.List;

public interface ClueMapper {
    int saveClue(Clue clue);
    List<Clue> pageList(Clue clue);
    int doDelete(String[] ids);
    Clue getClueListById(String id);
    int doUpdate(Clue clue);
    Clue toDetail(String id);
    int deleteByClueId(String id);
}
