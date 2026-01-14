
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Jelly Belly - My Profile</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Jua&family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${cPath}/css/yiseo-theme.css?v=20260109c">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

    <script type="text/javascript">
        //============= 회원정보수정 Event  처리 ============= 
        $(function() {
            // "수정" 버튼 클릭 시
            $( "button.btn-brand" ).on("click" , function() {
                self.location = "${cPath}/user/updateUser?userId=${user.userId}"
            });
        });
    </script>
</head>

<body>
    <jsp:include page="/layout/toolbar.jsp" />

    <div class="page-container">
        <header class="page-header">
            <h1>My Profile</h1>
        </header>

        <main>

            <table class="table table-bordered detail-table">
                <tr>
                    <th>아 이 디</th>
                    <td>${user.userId}</td>
                </tr>
                <tr>
                    <th>이 름</th>
                    <td>${user.userName}</td>
                </tr>
                <tr>
                    <th>주소</th>
                    <td>${user.addr}</td>
                </tr>
                <tr>
                    <th>휴대전화번호</th>
                    <td>${ !empty user.phone ? user.phone : ''}</td>
                </tr>
                <tr>
                    <th>이 메 일</th>
                    <td>${user.email}</td>
                </tr>
                <tr>
                    <th>가입일자</th>
                    <td>${user.regDate}</td>
                </tr>
            </table>

            <div class="button-group">
                <button type="button" class="btn btn-brand btn-lg">회원정보수정</button>
            </div>
        </main>
    </div>
</body>
</html>