<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.css">
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
 <link href="https://cdnjs.cloudflare.com/ajax/libs/bootswatch/5.3.2/zephyr/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/css/team.css">
 <!-- 아이콘 사용을 위한 Font Awesome 6 CDN-->
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <title>캘린더</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<script>
    <!-- javascript 작성 공간 -->
    document.addEventListener("DOMContentLoaded", function () {
        // 현재 날짜를 가져오기
        var today = new Date();
        var currentYear = today.getFullYear();
        var currentMonth = today.getMonth();

        // 년도 선택 요소 가져오기
        var dropYear = document.getElementById("dropYear");
        // 년도 옵션 추가
        for (var i = 2020; i <= 2035; i++) {
            var option = document.createElement("option");
            option.text = i;
            option.value = i;
            dropYear.add(option);
        }
        // 현재 년도 선택
        dropYear.value = currentYear;

        // 월 선택 요소 가져오기
        var dropMonth = document.getElementById("dropMonth");
        // 월 옵션 추가
        for (var i = 1; i <= 12; i++) {
            var option = document.createElement("option");
            option.text = i;
            option.value = i;
            dropMonth.add(option);
        }
        // 현재 월 선택
        dropMonth.value = currentMonth +1 ;

        
        
        // 가상의 데이터 배열 
        var eventData = [];

        // 이전 달과 다음 달 버튼
        var prevMonthButton = document.getElementById("prevMonthButton");
        var nextMonthButton = document.getElementById("nextMonthButton");
        
        //조회 버튼
        var queryButton = document.getElementById("queryButton");
        
        //일괄등록 버튼
         var allAddButton = document.querySelector('.allAdd button');

        // 이전 달 버튼 클릭 이벤트 처리
        prevMonthButton.addEventListener("click", function () {
            currentMonth--;
            if (currentMonth < 0) {
                currentMonth = 11;
                currentYear--;
            }
            refreshCalendar();
            displayCurrentMonth();
        });

        // 다음 달 버튼 클릭 이벤트 처리
        nextMonthButton.addEventListener("click", function () {
            currentMonth++;
            if (currentMonth > 11) {
                currentMonth = 0;
                currentYear++;
            }
            refreshCalendar();
            displayCurrentMonth();
        });

     // 조회 버튼 클릭 이벤트 처리
        queryButton.addEventListener("click", function (event) {
            // 기본 제출 동작 방지
            event.preventDefault();

            // 사용자가 선택한 년도와 월 가져오기
            currentYear = parseInt(dropYear.value);
            currentMonth = parseInt(dropMonth.value) -1;
            refreshCalendar();
            displayCurrentMonth();
        });

     

            // "일괄등록" 버튼 요소 가져오기
            var allAddButton = document.querySelector('.allAdd');

            // "일괄등록" 버튼 클릭 이벤트 처리
            allAddButton.addEventListener('click', function() {
                // 모달 요소 가져오기
                var modal = document.getElementById('modal');
                
                // 모달 열기
                modal.style.display = 'block';
                
                // '×' 버튼 요소 가져오기
                var span = modal.querySelector('.close');

                // '×' 버튼 클릭 이벤트 처리
                span.onclick = function() {
                    modal.style.display = 'none';
                };

                // 모달 외부 클릭 이벤트 처리
                window.onclick = function(event) {
                    if (event.target == modal) {
                        modal.style.display = 'none';
                    }
                };
                    
            });
 
            
            //일정 추가 버튼 시 동작
            document.getElementById('addEventBtn').onclick = function() {
                var eventTitle = document.getElementById('eventTitle').value;
                var eventDate = document.getElementById('eventDate').value;
                console.log(eventTitle);
                
                var url = 'http://localhost:8080/insert';
                var data = {
                    id: 'testuser1',
                    calendarDate: eventDate, // ISO 형식의 문자열로 변환하여 전달
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

            };
			

 

        // 현재 달을 표시할 엘리먼트 가져오기
        var currentMonthDisplay = document.getElementById("currentMonthDisplay");

        // 현재 달을 표시하는 함수
        function displayCurrentMonth() {
            var months = [
                "1월", "2월", "3월", "4월", "5월", "6월",
                "7월", "8월", "9월", "10월", "11월", "12월"
            ];
            var currentMonthName = months[currentMonth];
            var displayText = currentYear + "년 " + currentMonthName;
            currentMonthDisplay.textContent = displayText;

        }


        // 날짜 채우기 함수
        function fillCalendar(year, month, calendarId) {
            var calendar = document.getElementById(calendarId);
            calendar.innerHTML = "";

            var daysInMonth = new Date(year, month + 1, 0).getDate();
            var firstDay = new Date(year, month, 1).getDay();

            // 요일 순서를 월요일부터 시작하도록 조정
            if (firstDay === 0) {
                firstDay = 7; // 일요일인 경우 7로 변경
            }

            // 월별 달력 생성
            var table = document.createElement("table");
            calendar.appendChild(table); // table 엘리먼트를 추가

            var tbody = document.createElement("tbody"); // tbody 엘리먼트 생성
            table.appendChild(tbody); // tbody를 table에 추가

            var weekdays = ["월", "화", "수", "목", "금", "토", "일"];

            // 요일 헤더 생성
            var headerRow = tbody.insertRow(); // 요일 헤더를 추가할 행 생성
            for (var i = 0; i < 7; i++) {
                var cell = document.createElement("th"); // th 엘리먼트 생성
                cell.innerHTML = weekdays[i];
                headerRow.appendChild(cell); // th를 요일 헤더 행에 추가
            }

            // 열의 수 계산
            var totalCols = 7; // 요일 열의 수는 고정
            var remainingCols = daysInMonth + firstDay - 1; // 남은 열의 수 계산

            // 필요한 열의 수 계산
            var neededCols = totalCols - (remainingCols % totalCols);

            // 날짜 채우기
            var date = 1;
            for (var i = 0; i < Math.ceil((daysInMonth + firstDay - 1) / totalCols); i++) {
                var row = tbody.insertRow();
                for (var j = 0; j < totalCols; j++) {
                    if (i === 0 && j < firstDay - 1) {
                        var cell = row.insertCell();
                        cell.innerHTML = "";
                    } else {
                        if (date <= daysInMonth) {
                            var cell = row.insertCell();
                            
                         // 서버에서 전달된 캘린더 이벤트 데이터
                            var calendarEvents = [
                                <c:forEach items="${calendarList}" var="calendar">
                                {
                                    title: '${calendar.calendarTodo}',
                                    start: '${calendar.calendarDate}',
                                },
                                </c:forEach>
                            ];

                            // 캘린더 이벤트 데이터를 JavaScript 객체로 파싱
                            var eventData = calendarEvents.map(function(event) {
                                return {
                                    title: event.title,
                                    start: new Date(event.start)
                                };
                            });


                         // 날짜를 표시하는 부분 (기존 코드에서 이 부분 유지)
                            var dateDiv = document.createElement("div");
                            dateDiv.innerHTML = date;
                            dateDiv.classList.add("div-custom");
                            cell.appendChild(dateDiv);

                            // 캘린더 이벤트 데이터를 셀에 추가
                            var event = eventData.find(function(item) {
                                return item.start.getDate() === date && item.start.getMonth() === month;
                            });

                            // 데이터가 있다면 해당 데이터를 추가
                        if (event) {
							    // 이벤트 제목을 표시하는 부분
							    var eventTitle = document.createElement("div");
							    eventTitle.textContent = event.title;
							    eventTitle.classList.add("todoText"); // 클래스 추가
							    cell.appendChild(eventTitle);
							}
                            date++;
                        } else {
                            var cell = row.insertCell();
                            cell.innerHTML = "";
                        }
                    }
                }
            }
        }

        // 달력 새로고침 함수
        function refreshCalendar() {
            eventData = []; // 이벤트 데이터 초기화
            fillCalendar(currentYear, currentMonth, "currentMonthCalendar");

        }

        // 초기 캘린더 표시
        refreshCalendar();

        // 현재 달을 표시
        displayCurrentMonth();

    });

      
</script>

<body>
    <div class="calendarContainer">
    
    <div class="topContainer">
    		<div class="calendarDrop">
            <select id="dropYear">               
            </select>
            <button type="button" id="prevMonthButton"><i class="fa-solid fa-chevron-left"></i></button>
            <select id="dropMonth">             
            </select>
            <button type="button" id="nextMonthButton"><i class="fa-solid fa-chevron-right"></i></button>
            <input type="button" id="queryButton" value="조회"> 
            </div>
            
        <div class="calendarButton">
            <div id="currentMonthDisplay"></div>
        </div>
        
        <div class="allAddEdit">
                 <button class="allAdd" >일괄등록</button>
                <button class="allEdit">일괄수정</button>
         </div>
    
    </div>
    
    
        <table id="currentMonthCalendar" class="row">
            <thead>
                <tr>
                    <th>월</th>
                    <th>화</th>
                    <th>수</th>
                    <th>목</th>
                    <th>금</th>
                    <th>토</th>
                    <th>일</th>
                </tr>
            </thead>
            <tbody>
    
             
 
            </tbody>
        </table>
    
    <div id="modal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <label for="eventTitle">일정 제목:</label>
        <input type="text" id="eventTitle" name="eventTitle" required><br>
        <label for="eventDate">일정 날짜:</label>
        <input type="date" id="eventDate" name="eventDate" required><br>

        <div class="eventSelect"></div>
        <br>
        <button id="addEventBtn">일정 추가</button>
    </div>
    </div>
    </div>
    </body>

</html>