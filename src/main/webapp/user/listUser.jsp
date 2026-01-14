
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Jelly Belly - Member List</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Jua&family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${cPath}/css/yiseo-theme.css?v=20260109c">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    
    <script type="text/javascript">
        //=============   검색 / page 두가지 경우 모두  Event  처리 ============= 
        function fncGetUserList(currentPage) {
            $("#currentPage").val(currentPage)
            $("form[name='detailForm']").attr("method" , "POST").attr("action" , "/user/listUser").submit();
        }
        
        //============= "검색"  Event  처리 ============= 
        $(function() {
             $( "button.btn-brand" ).on("click" , function() {
                fncGetUserList(1);
            });
         });
        
        //============= (수정!) .user-item-table 행 클릭 시 상세 이동 ============= 
        $(function() {
            // .list-table 안의 .user-item-table 클래스를 가진 <tr>을 클릭하면
            $(".list-table").on("click", ".user-item-table", function() {
                var href = $(this).data("href"); // <tr data-href="..."> 값을 찾음
                if (href) {
                    self.location = href;
                }
            });
        }); 
        
        //============= (수정!) 툴팁(Tooltip) Event 처리 =============
        $(function() {
            // .tooltip-trigger 클래스가 있는 모든 요소에 툴팁 적용!
            $(document).tooltip({
                items: ".tooltip-trigger",
                content: function(callback) {
                    var userId = $(this).data("userid"); // <i data-userid="..."> 값을 찾음
                    
                    // Ajax 요청
                    $.ajax({
                        url : "/user/json/getUser/" + userId ,
                        method : "GET" ,
                        dataType : "json" ,
                        headers : {
                            "Accept" : "application/json",
                            "Content-Type" : "application/json"
                        },
                        success : function(JSONData , status) {
                            // 찐 테마 팝업 스타일 (yiseo-theme.css .product-popover)
                            var displayValue = "<h4>" + (JSONData.userName || '') + "</h4>"
                                        + "<p><strong>아이디:</strong> " + JSONData.userId + "</p>"
                                        + "<p><strong>이메일:</strong> " + (JSONData.email || '없음') + "</p>"
                                        + "<p><strong>등급:</strong> " + (JSONData.role || 'user') + "</p>"
                                        + "<p><strong>가입일:</strong> " + (JSONData.regDateString || '없음') + "</p>";
                            callback(displayValue); // 툴팁 내용 반환
                        },
                        error: function() {
                            callback("정보를 불러오는 데 실패했습니다.");
                        }
                    });
                },
                // 툴팁 스타일 (yiseo-theme.css .product-popover 와 동일하게!)
                classes: {
                    "ui-tooltip": "product-popover" 
                },
                position: {
                    my: "left+15 center",
                    at: "right center"
                },
                track: true // 마우스 따라다니기
            });
        }); 
    </script>
</head>

<body>
    <jsp:include page="/layout/toolbar.jsp" />

    <div class="page-container">
        <header class="page-header">
            <h1>Member List</h1>
        </header>

        <main>
            <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                
                <div class="text-secondary">
                    전체 ${resultPage.totalCount } 건수, 현재 ${resultPage.currentPage} 페이지
                </div>
                
                <form class="d-flex gap-2" name="detailForm">
                     <select class="form-select" name="searchCondition" style="width:auto;">
                        <option value="0"  ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>회원ID</option>
                        <option value="1"  ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>회원명</option>
                    </select>
                    
                    <input type="text" class="form-control" id="searchKeyword" name="searchKeyword"  placeholder="검색어"
                           value="${! empty search.searchKeyword ? search.searchKeyword : '' }" >
                    
                    <button type="button" class="btn btn-brand">검색</button>
                    
                    <input type="hidden" id="currentPage" name="currentPage" value=""/>
                </form>
            </div>

            <table class="table table-hover list-table align-middle">
                <thead>
                    <tr>
                        <th style="width:5%;">No</th>
                        <th style="width:15%;">회원 ID</th>
                        <th style="width:15%;">회원명</th>
                        <th>이메일</th>
                        <th style="width:10%;">간략정보</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="i" value="0" />
                    <c:forEach var="user" items="${list}">
                        <c:set var="i" value="${ i+1 }" />

                        <c:url var="detailUrl" value="/user/getUser">
                            <c:param name="userId" value="${user.userId}" />
                            <c:param name="menu" value="${param.menu}" />
                        </c:url>
                        
                        <tr class="user-item-table" data-href="${detailUrl}">
                            <td class="text-center">${ i }</td>
                            <td>
                                <a href="${detailUrl}">${user.userId}</a>
                            </td>
                            <td>${user.userName}</td>
                            <td>${user.email}</td>
                            <td class="text-center">
                                <i class="bi bi-info-circle-fill text-secondary tooltip-trigger" 
                                   data-userid="${user.userId}"
                                   style="cursor:pointer; font-size: 1.2rem;"></i>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty list}">
                        <tr>
                            <td colspan="5" class="text-center py-5 text-muted">회원이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <div class="page-navigation">
                <c:set var="curr" value="${resultPage.currentPage}" />
                <c:set var="sp"   value="${resultPage.beginUnitPage}" />
                <c:set var="ep"   value="${resultPage.endUnitPage}" />

                <c:forEach var="i" begin="${sp}" end="${ep}">
                    <c:choose>
                        <c:when test="${i == curr}">
                            <strong>${i}</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:fncGetUserList(${i})">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
            
        </main>
    </div>
</body>
</html>