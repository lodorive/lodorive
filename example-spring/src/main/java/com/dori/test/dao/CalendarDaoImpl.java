package com.dori.test.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dori.test.dto.CalendarDto;


@Repository
public class CalendarDaoImpl implements CalendarDao{

	@Autowired
	private SqlSession  sqlSession;
	
	@Override
	public void insert(CalendarDto calendarDto) {
		sqlSession.insert("com.dori.test.dao.CalendarDao.add", calendarDto);
	}
	

	@Override
	public List<CalendarDto> selectList(String id) { 
	    return sqlSession.selectList("com.dori.test.dao.CalendarDao.selectList", id);
	}

	
}
