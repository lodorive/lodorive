package com.dori.test.controller;

import java.sql.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.dori.test.dao.CalendarDao;
import com.dori.test.dto.CalendarDto;

@RestController
public class RestContorller {

	@Autowired
	private CalendarDao calendarDao;
	

	@PostMapping("insert")
	public void add(@RequestParam String id, @RequestParam String calendarTodo, 
			@RequestParam Date calendarDate) {
		CalendarDto calendarDto = new CalendarDto();
		calendarDto.setId("testuser1");
		calendarDto.setCalendarDate(calendarDate);
		calendarDto.setCalendarTodo(calendarTodo);
		calendarDao.insert(calendarDto);		
	}
	
}
