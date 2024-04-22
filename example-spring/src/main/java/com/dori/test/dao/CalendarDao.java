package com.dori.test.dao;

import java.util.List;

import com.dori.test.dto.CalendarDto;

public interface CalendarDao {

	void insert(CalendarDto calendarDto);
	List<CalendarDto> selectList (String id);
}
