/**
 * Jelly Belly - Calendar Date Picker
 * Simple calendar popup for date selection
 */

var calendarWindow = null;

function show_calendar(fieldName, currentValue) {
    var width = 280;
    var height = 320;
    var left = (screen.width - width) / 2;
    var top = (screen.height - height) / 2;

    // Close existing calendar window
    if (calendarWindow && !calendarWindow.closed) {
        calendarWindow.close();
    }

    // Store the field reference
    window.calendarTargetField = fieldName;

    // Parse current date or use today
    var date = new Date();
    if (currentValue && currentValue.match(/^\d{4}-\d{2}-\d{2}$/)) {
        var parts = currentValue.split('-');
        date = new Date(parts[0], parts[1] - 1, parts[2]);
    }

    // Open calendar popup
    calendarWindow = window.open('', 'calendar',
        'width=' + width + ',height=' + height + ',left=' + left + ',top=' + top +
        ',scrollbars=no,resizable=no,menubar=no,toolbar=no');

    renderCalendar(date.getFullYear(), date.getMonth());
}

function renderCalendar(year, month) {
    if (!calendarWindow || calendarWindow.closed) return;

    var doc = calendarWindow.document;

    var firstDay = new Date(year, month, 1);
    var lastDay = new Date(year, month + 1, 0);
    var startDayOfWeek = firstDay.getDay();
    var daysInMonth = lastDay.getDate();

    var monthNames = ['1월', '2월', '3월', '4월', '5월', '6월',
                      '7월', '8월', '9월', '10월', '11월', '12월'];
    var dayNames = ['일', '월', '화', '수', '목', '금', '토'];

    var html = '<!DOCTYPE html><html><head><meta charset="UTF-8">';
    html += '<title>날짜 선택</title>';
    html += '<style>';
    html += 'body { font-family: "Noto Sans KR", sans-serif; margin: 0; padding: 10px; background: linear-gradient(135deg, #FFF8F0 0%, #FFF0F5 100%); }';
    html += '.calendar-header { display: flex; justify-content: space-between; align-items: center; padding: 10px; background: linear-gradient(135deg, #FF6B9D, #E91E63); color: white; border-radius: 12px 12px 0 0; }';
    html += '.calendar-header button { background: rgba(255,255,255,0.2); border: none; color: white; padding: 5px 12px; cursor: pointer; border-radius: 6px; font-size: 14px; }';
    html += '.calendar-header button:hover { background: rgba(255,255,255,0.3); }';
    html += '.calendar-title { font-size: 16px; font-weight: 600; }';
    html += '.calendar-table { width: 100%; border-collapse: collapse; background: white; border-radius: 0 0 12px 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(255,107,157,0.15); }';
    html += '.calendar-table th { padding: 8px; text-align: center; background: #FFB3C6; color: #5D4E60; font-weight: 500; font-size: 12px; }';
    html += '.calendar-table td { padding: 6px; text-align: center; cursor: pointer; transition: all 0.2s; }';
    html += '.calendar-table td:hover { background: #FFF0F5; }';
    html += '.calendar-table td.day { border-radius: 50%; }';
    html += '.calendar-table td.day:hover { background: #FF6B9D; color: white; }';
    html += '.calendar-table td.sun { color: #E91E63; }';
    html += '.calendar-table td.sat { color: #2196F3; }';
    html += '.calendar-table td.today { background: #FFB3C6; border-radius: 50%; font-weight: 600; }';
    html += '.calendar-table td.empty { cursor: default; }';
    html += '.calendar-table td.empty:hover { background: transparent; }';
    html += '</style></head><body>';

    // Header with navigation
    html += '<div class="calendar-header">';
    html += '<button onclick="opener.renderCalendar(' + year + ', ' + (month - 1) + ')">&lt;</button>';
    html += '<span class="calendar-title">' + year + '년 ' + monthNames[month] + '</span>';
    html += '<button onclick="opener.renderCalendar(' + year + ', ' + (month + 1) + ')">&gt;</button>';
    html += '</div>';

    // Calendar table
    html += '<table class="calendar-table"><thead><tr>';
    for (var d = 0; d < 7; d++) {
        var dayClass = d === 0 ? 'sun' : (d === 6 ? 'sat' : '');
        html += '<th class="' + dayClass + '">' + dayNames[d] + '</th>';
    }
    html += '</tr></thead><tbody>';

    var today = new Date();
    var todayStr = today.getFullYear() + '-' +
                   String(today.getMonth() + 1).padStart(2, '0') + '-' +
                   String(today.getDate()).padStart(2, '0');

    var dayCount = 1;
    for (var row = 0; row < 6; row++) {
        if (dayCount > daysInMonth) break;

        html += '<tr>';
        for (var col = 0; col < 7; col++) {
            if (row === 0 && col < startDayOfWeek) {
                html += '<td class="empty"></td>';
            } else if (dayCount > daysInMonth) {
                html += '<td class="empty"></td>';
            } else {
                var dateStr = year + '-' +
                              String(month + 1).padStart(2, '0') + '-' +
                              String(dayCount).padStart(2, '0');
                var dayClass = 'day';
                if (col === 0) dayClass += ' sun';
                if (col === 6) dayClass += ' sat';
                if (dateStr === todayStr) dayClass += ' today';

                html += '<td class="' + dayClass + '" onclick="opener.selectDate(\'' + dateStr + '\')">' + dayCount + '</td>';
                dayCount++;
            }
        }
        html += '</tr>';
    }

    html += '</tbody></table>';
    html += '</body></html>';

    doc.open();
    doc.write(html);
    doc.close();
}

function selectDate(dateStr) {
    if (window.calendarTargetField) {
        try {
            var field = eval(window.calendarTargetField);
            if (field) {
                field.value = dateStr;
            }
        } catch (e) {
            console.error('Calendar: Could not set date', e);
        }
    }

    if (calendarWindow && !calendarWindow.closed) {
        calendarWindow.close();
    }
}

console.log('calendar.js loaded successfully!');
