<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.css">

<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/locales-all.js"></script>
 
 <style>
.modal {
    display: none; /* 초기에는 모달을 숨김 */
    position: fixed;
    z-index: 1;
    left: 50%;
    top: 40%;
    transform: translate(-50%, -50%);
    width: 50%;
    height: 50%;
    overflow: auto;
}

.modal-content {
    background-color: #fefefe;
    margin: 15% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
}

.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}
 
 </style>

 
 <div id="calendar"></div>
 
<div id="modal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <label for="eventTitle">일정 제목:</label>
        <input type="text" id="eventTitle" name="eventTitle" required><br>
        <label for="eventDate">일정 날짜:</label>
        <input type="date" id="eventDate" name="eventDate" required><br>
        <select id="eventRoot" name="eventRoot">
        <option selected>반복 설정</option>
        <option>주</option>
        <option>개월</option>
        <option>년</option>
        </select>
        <div class="eventSelect"></div>
        <br>
        <button id="addEventBtn">일정 추가</button>
    </div>
</div>

<!-- jquery cdn -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

 <script>
 
 document.addEventListener('DOMContentLoaded', function() {
	    var calendarEl = document.getElementById('calendar');
	    var calendar = new FullCalendar.Calendar(calendarEl, {
	        initialView: 'dayGridMonth', // 초기 로드 될때 보이는 캘린더 화면(기본 설정: 달)
	        headerToolbar: { // 헤더에 표시할 툴 바
	            start: 'prev next today',
	            center: 'title',
	            end: 'addEventButton dayGridMonth,dayGridWeek,dayGridDay'
	        },
	        titleFormat: function(date) {
	            return date.date.year + '년 ' + (parseInt(date.date.month) + 1) + '월';
	        },
	        //initialDate: '2021-07-15', // 초기 날짜 설정 (설정하지 않으면 오늘 날짜가 보인다.)
	        selectable: true, // 달력 일자 드래그 설정가능
	        droppable: true,
	        editable: true,
	        nowIndicator: true, // 현재 시간 마크
	        locale: 'ko', // 한국어 설정

	        events: [
	            <c:forEach items="${calendarList}" var="calendar">
	            {
	                title: '${calendar.calendarTodo}',
	                start: '${calendar.calendarDate}',
	            },
	            </c:forEach>
	        ],
	        customButtons: {
	            addEventButton: {
	                text: '일정 추가',
	                click: function() {
	                    var modal = document.getElementById('modal');
	                    var span = document.getElementsByClassName('close')[0];
	                    var modalContent = document.querySelector('.modal-content');

	                    // 모달 열기
	                    modal.style.display = 'block';

	                    // '×' 버튼 또는 모달 외부를 클릭하면 모달 닫기
	                    span.onclick = function() {
	                        modal.style.display = 'none';
	                    };
	                    window.onclick = function(event) {
	                        if (event.target == modal) {
	                            modal.style.display = 'none';
	                        }
	                    };

	                    var selectedWeekdays = []; // 선택된 요일을 담을 배열 
	                   
	                    var eventRootSelect = document.getElementById('eventRoot');
	                    
	                    
	                    eventRootSelect.addEventListener('change', function() {
	                        var selectedOption = eventRootSelect.value;
	                        console.log(selectedOption);
	                        
	                        var eventSelectDiv = document.querySelector('.eventSelect');
	                        
	                        if (selectedOption === '주') {
	                            // 주 옵션을 선택한 경우의 처리
	                        	  var additionalContent =
		                               '<br>' + '<br>' +
		                               '<label for="monday">월</label>' +
		                               '<input type="checkbox" id="monday" name="weekday" value="monday">' +
		                               '<label for="tuesday">화</label>' +
		                               '<input type="checkbox" id="tuesday" name="weekday" value="tuesday">' +
		                               '<label for="wednesday">수</label>' +
		                               '<input type="checkbox" id="wednesday" name="weekday" value="wednesday">' +
		                               '<label for="thursday">목</label>' +
		                               '<input type="checkbox" id="thursday" name="weekday" value="thursday">' +
		                               '<label for="friday">금</label>' +
		                               '<input type="checkbox" id="friday" name="weekday" value="friday">' +
		                               '<label for="saturday">토</label>' +
		                               '<input type="checkbox" id="saturday" name="weekday" value="saturday">' +
		                               '<label for="sunday">일</label>' +
		                               '<input type="checkbox" id="sunday" name="weekday" value="sunday">' +
		                               '<br>' +
		                               '<label for="eventEndDate">일정 종료 날짜:</label>' +
		                               '<input type="date" id="eventEndDate" name="eventEndDate" required><br>' +
		                               '<br>';
		                           eventSelectDiv.innerHTML = additionalContent; // eventSelectDiv에 내용 추가
		                           
	                        }
	                        
	                        else if(selectedOption === '개월'){
	                        	var eventDate = document.getElementById('eventDate').value;
	                        	var dayOfMonth = new Date(eventDate).getDate();
	                        	var monthlyMessage = "매월 " + dayOfMonth +"일";

	                        	//console.log(eventDate)
	                        	//console.log(dayOfMonth)
	                        	//console.log(monthlyMessage) 
	                    
	                        
	                        	var additionalContent = 
	                        		 '<br>' + '<br>' +
	                        	        '<label name="monthMsg">' + monthlyMessage + '</label>' +
	                        	        '<br>'+
                                       '<label>일정 종료 날짜:</label>' +
                                       '<input type="date" id="eventEndDate" name="eventEndDate" required><br>' +
                                       '<br>';
	                        	        
                                       eventSelectDiv.innerHTML = additionalContent; // eventSelectDiv에 내용 추가
	                        }
	                        
	                        else if(selectedOption === '년'){
	                    	    var eventDate = document.getElementById('eventDate').value;
	                    	    var dayOfMonth = new Date(eventDate).getDate();
	                    	    var monthOfYear = new Date(eventDate).getMonth() + 1; // 월은 0부터 시작하므로 1을 더해줌
	                    	    var yearlyMessage = "매년 " + monthOfYear + "월 " + dayOfMonth + "일";


	                    	    var additionalContent = 
	                    	        '<br>' + '<br>' +
	                    	        '<label name="yearMsg">' + yearlyMessage + '</label>' +
	                    	        '<br>' +
	                    	        '<label>일정 종료 날짜:</label>' +
	                    	        '<input type="date" id="eventEndDate" name="eventEndDate" required><br>' +
	                    	        '<br>';

	                    	    eventSelectDiv.innerHTML = additionalContent; // eventSelectDiv에 내용 추가
	                    	};
	                        

								
	                 // 이벤트 리스너 추가
	                    var weekdays = document.getElementsByName('weekday');

	                    for (var i = 0; i < weekdays.length; i++) {
	                        weekdays[i].addEventListener('change', function() {
	                            if (this.checked) {
	                                // 체크된 경우, 배열에 추가
	                                selectedWeekdays.push(this.value);
	                            } else {
	                                // 체크 해제된 경우, 배열에서 제거
	                                var index = selectedWeekdays.indexOf(this.value);
	                                if (index !== -1) {
	                                    selectedWeekdays.splice(index, 1);
	                                }
	                            }
	                            console.log(selectedWeekdays); // 선택된 요일 배열 확인
	                        });
	                    }

	                    }); 
	                    
	                 // "일정 추가" 버튼 클릭 시 동작
	                    document.getElementById('addEventBtn').onclick = function() {
	                        var eventTitle = document.getElementById('eventTitle').value;
	                        var eventDate = document.getElementById('eventDate').value;
	                        console.log(eventTitle);
	                        
	                        var selectOption = document.getElementById('eventRoot').value;
	                        console.log(selectOption);

	                        // 선택된 요일과 종료일자를 이용하여 일정 추가
	                        if(selectOption === '주'){                         
	                            addWeekEvents(eventTitle, eventDate, selectedWeekdays);
	                        } else {
	                            addEvents(eventTitle, eventDate);
	                        }
	                    };
						
	                    
	                  //반복 설정
	                    function addWeekEvents(eventTitle, eventDate, selectedWeekdays) {
	                        // 종료일자를 가져옴
	                        var eventEndDate = document.getElementById('eventEndDate').value;
	                        console.log(eventEndDate);

	                        // 시작일과 종료일 사이의 모든 날짜를 계산
	                        var startDate = new Date(eventDate);
	                        var endDate = new Date(eventEndDate);
	                        var currentDate = new Date(startDate);
	                        var daysToAdd = 1;

	                        // 선택된 요일이 있는지 확인하고 해당 요일에 일정 추가
	                        while (currentDate <= endDate) {
	                            var dayOfWeek = currentDate.getDay();
	                            var dayOfWeekStr = '';

	                            if (dayOfWeek === 0) dayOfWeekStr = 'sunday';
	                            else if (dayOfWeek === 1) dayOfWeekStr = 'monday';
	                            else if (dayOfWeek === 2) dayOfWeekStr = 'tuesday';
	                            else if (dayOfWeek === 3) dayOfWeekStr = 'wednesday';
	                            else if (dayOfWeek === 4) dayOfWeekStr = 'thursday';
	                            else if (dayOfWeek === 5) dayOfWeekStr = 'friday';
	                            else if (dayOfWeek === 6) dayOfWeekStr = 'saturday';

	                            if (selectedWeekdays.includes(dayOfWeekStr)) {
	                                // 선택된 요일에 해당하는 경우에만 일정 추가
	                                var url = 'http://localhost:8080/insert';
	                                var data = {
	                                    id: 'testuser1',
	                                    calendarDate: currentDate.toISOString().slice(0, 10), // ISO 형식의 문자열로 변환하여 전달
	                                    calendarTodo: eventTitle,
	                                };

	                                $.ajax({
	                                    url: url,
	                                    method: 'POST',
	                                    data: data,
	                                    success: function(response) {
	                                        /* modal.style.display = 'none';
	                                        location.reload(); // 일정 추가 후 페이지 새로고침 */
	                                        console.log('일정 추가 성공');
	                                    },
	                                    error: function(xhr, status, error) {
	                                        console.log('일정 추가 실패');
	                                    },
	                                });
	                            }

	                            currentDate.setDate(currentDate.getDate() + daysToAdd);
	                        }
	                    }


	                    //반복 설정
	                    function addEvents(eventTitle, eventDate) {
	                        // 종료일자를 가져옴
	                        var eventEndDateInput = document.getElementById('eventEndDate');
	                        // 종료일자 입력이 없을 경우 시작일과 동일한 날짜로 설정
	                        var eventEndDate = eventEndDateInput ? eventEndDateInput.value : eventDate;
	                        console.log(eventEndDate);

	                        // 시작일과 종료일 사이의 모든 날짜를 계산
	                        var startDate = new Date(eventDate);
	                        var endDate = new Date(eventEndDate);
	                        var currentDate = new Date(startDate);
	                        
	                        //반복할 일 수 
	                        var daysToAdd = 1;

	                        var selectOption = document.getElementById('eventRoot').value;
	                        /* 
	                        if (selectOption === '개월') {
	                            var dayOfMonth = startDate.getDate(); // 시작일의 일
	                            var currentMonth = currentDate.getMonth(); // 현재 날짜의 월

	                            // 매월 특정 일에 해당하는 경우에만 일정 추가
	                            while (currentDate <= endDate) {
	                           
	                                if (currentDate.getDate() === dayOfMonth && currentDate.getMonth() === currentMonth) {
	                                    addEventData(eventTitle, currentDate);
	                                }
	                                currentDate.setDate(currentDate.getDate() + daysToAdd);
	                            }
	                        }

	                        // 년 단위 처리
	                        else if (selectOption === '년') {
	                            var dayOfMonth = startDate.getDate(); // 시작일의 일
	                            var monthOfYear = new Date(eventDate).getMonth(); // 입력한 날짜의 월
	                            var currentYear = currentDate.getFullYear(); // 현재 날짜의 연도

	                            // 매년 특정 월과 일에 해당하는 경우에만 일정 추가
	                            while (currentDate <= endDate) {
	                                if (currentDate.getDate() === dayOfMonth && currentDate.getMonth() === monthOfYear) {
	                                    addEventData(eventTitle, currentDate);
	                                }
	                                currentDate.setDate(currentDate.getDate() + daysToAdd);
	                            }                     
	                        } */
	                        
	                        // 반복해서 실행할 함수
	                          var repeatFunction = function(currentDate) {
	                            // 입력된 날짜와 현재 처리 중인 날짜가 같지 않다면
	                            //현재 처리 중인 날짜, 입력된 날짜 
	                            if (currentDate.toDateString() !== startDate.toDateString()) {
	                                // 요일에 해당하는 경우에만 일정 추가
	                                var dayOfWeek = currentDate.getDay();
	                                var dayOfWeekStr = '';
	                                if (dayOfWeek === 0) dayOfWeekStr = 'sunday';
	                                else if (dayOfWeek === 1) dayOfWeekStr = 'monday';
	                                else if (dayOfWeek === 2) dayOfWeekStr = 'tuesday';
	                                else if (dayOfWeek === 3) dayOfWeekStr = 'wednesday';
	                                else if (dayOfWeek === 4) dayOfWeekStr = 'thursday';
	                                else if (dayOfWeek === 5) dayOfWeekStr = 'friday';
	                                else if (dayOfWeek === 6) dayOfWeekStr = 'saturday';

	                                // 선택된 요일에 해당하는 경우에만 데이터 추가
	                                if (selectedWeekdays.includes(dayOfWeekStr)) {
	                                    addEventData(eventTitle, currentDate);
	                                }
	                                
	                            }
	                            
	                            

	                                // 개월 단위 처리
	                                if(selectOption === '개월'){
			                                var dayOfMonth = startDate.getDate(); // 시작일의 일
			                                var currentMonth = currentDate.getMonth(); // 현재 날짜의 월
	
			                                // 매월 특정 일에 해당하는 경우에만 일정 추가
			                                if (currentDate.getDate() === dayOfMonth && currentDate.getMonth() === currentMonth) {
			                                    addEventData(eventTitle, currentDate);		                                
			                            }
							}
	                                
	                                
	                             // 년 단위 처리
	                               if(selectOption === '년')  {
	                             var dayOfMonth = startDate.getDate(); // 시작일의 일
	                                var monthOfYear = new Date(eventDate).getMonth(); // 입력한 날짜의 월
	                                var currentYear = currentDate.getFullYear(); // 현재 날짜의 연도

	                                // 매년 특정 월과 일에 해당하는 경우에만 일정 추가
	                                if (currentDate.getDate() === dayOfMonth && currentDate.getMonth() === monthOfYear) {
	                                    addEventData(eventTitle, currentDate);
	                                }
	                 }

	                        };

	                        // 시작일부터 종료일까지의 모든 날짜에 대해 처리
	                        var currentDate = new Date(startDate);
	                        while (currentDate <= endDate) {
	                            repeatFunction(currentDate);
	                            currentDate.setDate(currentDate.getDate() + 1); // 다음 날짜로 이동
	                        }
	                    }

	                        
	                    
	                  
	                    
	                    function addEventData(eventTitle, currentDate) {
	                        var url = 'http://localhost:8080/insert';
	                        var data = {
	                            id: 'testuser1',
	                            calendarDate: currentDate.toISOString().slice(0, 10), // ISO 형식의 문자열로 변환하여 전달
	                            calendarTodo: eventTitle,
	                        };

	                        $.ajax({
	                            url: url,
	                            method: 'POST',
	                            data: data,
	                            success: function(response) {
/* 	                                modal.style.display = 'none';
	                                location.reload(); // 일정 추가 후 페이지 새로고침 */
	                                console.log('일정 추가 성공');
	                            },
	                            error: function(xhr, status, error) {
	                                console.log('일정 추가 실패');
	                            },
	                        });

	                        }
                
	                    
	                     
	                    
	                  
	                }
	                
	                }
	    		}
	    });
	    calendar.render();
 
	    
	});

 
</script>
 
</html>