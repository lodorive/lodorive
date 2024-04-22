package com.dori.test.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class CalendarDto {

	private String id;
	private Date calendarDate;
	private String calendarTodo;
	
}
