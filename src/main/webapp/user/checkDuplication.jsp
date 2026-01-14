
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>아이디 중복 확인</title>
    

    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&family=Playfair+Display:ital,wght@0,400..900;1,400..900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${cPath}/css/yiseo-theme.css"> <%-- 찐 테마! --%>
    
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    
    <script type="text/javascript">
        //=============  "중복확인"  Event 처리 =============
        $(function() {
            $("#userId").focus();
            
            // "중복확인" 버튼 (찐 테마 .btn-brand)
            $("button.btn-brand").on("click" , function() {
                if( $("#userId").val() != null && $("#userId").val().length >0) {
                    $("form").attr("method" , "POST");
                    $("form").attr("action" , "/user/checkDuplication");
                    $("form").submit();
                }else {
                    alert('아이디는 반드시 입력하셔야 합니다.');
                }
                $("#userId").focus();
            });
        });
    
        //=============  "사용"  Event 처리 =============
        $(function() {
            // "사용" 버튼 (찐 테마 .btn-brand-outline)
            $("button.btn-brand-outline").on("click" , function() {
                if(opener) {
                    opener.$("input[name='userId']").val("${userId}");
                    opener.$("input[name='password']").focus();
                }
                window.close();
            });
        });
        
        //=============   "닫기"  Event  처리 =============
        $(function() {
            // "닫기" 버튼 (찐 테마 .btn-outline-secondary)
            $("button.btn-outline-secondary").on("click" , function() {
                window.close();
            });
        });
    </script>
</head>

<body>
    <div style="padding: 2rem;">
        <form class="d-flex gap-2 align-items-center">
        
             <label for="userId" class="form-label mb-0">아 이 디</label>
             <input type="text" class="form-control" name="userId" id="userId"  placeholder="아이디"
                    value="${ ! empty result && result ? userId : '' }" style="width: 150px;">
            
             <button type="button" class="btn btn-brand btn-sm">중복확인</button>
            
             <c:if test="${ ! empty result }">
                 <c:if test="${ result =='true' }">
                     <button type="button" class="btn btn-brand-outline btn-sm">사 용</button>
                 </c:if>
             </c:if>
            
             <button type="button" class="btn btn-outline-secondary btn-sm">닫 기</button>
        </form>

        <div class="mt-3">
             <c:if test="${ empty result }">
                 <span class_ ="form-text">입력 후 중복확인</span>
             </c:if>
             <c:if test="${ ! empty result }">
                 <c:if test="${ result =='true' }">
                    <span class="form-text text-success">
                        <strong>사용 가능한 아이디입니다.</strong>
                    </span>
                </c:if>
                <c:if test="${ result=='false' }">
                    <span class="form-text text-danger">
                        <strong>사용 불가능한 아이디입니다.</strong>
                    </span>
                </c:if>
             </c:if>
        </div>
    </div>
</body>
</html>