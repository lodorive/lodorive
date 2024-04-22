package com.dori.test.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.dori.test.dao.CalendarDao;
import com.dori.test.dto.CalendarDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CalendarController {

    @Autowired
    private CalendarDao calendarDao;

    @GetMapping("/")
    public String home(@RequestParam String id, Model model) {
        List<CalendarDto> calendarList = calendarDao.selectList(id);
        model.addAttribute("calendarList", calendarList);
        log.debug("Calendar list size: {}", calendarList.size());
        return "/WEB-INF/views/calendar.jsp";
    }
}

