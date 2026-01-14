
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <c:set var="cPath" value="${pageContext.request.contextPath}" />
    <title>Jelly Belly - Order Details</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Jua&family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${cPath}/css/yiseo-theme.css?v=20260109c">
</head>
<body>

    <jsp:include page="/layout/toolbar.jsp" />

    <div class="page-container">
        <header class="page-header">
            <h1>Order Info</h1>
        </header>

        <main>
            <c:if test="${empty purchase}">
                <p>구매 정보가 없습니다.</p>
            </c:if>

            <c:if test="${not empty purchase}">
                <table class="table table-bordered detail-table">
                    <tr><th>거래번호</th><td>${purchase.tranNo}</td></tr>
                    <tr>
                        <th>거래상태</th>
                        <td class="code-emphasis">
                            <c:choose>
                                <c:when test="${purchase.tranCode=='1'}">상품준비중</c:when>
                                <c:when test="${purchase.tranCode=='2'}">배송중</c:when>
                                <c:when test="${purchase.tranCode=='3'}">배송완료</c:when>
                                <c:otherwise>상태미정</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr><th>구매자 ID</th><td>${purchase.buyer.userId}</td></tr>
                    <tr><th>상품명</th><td>${purchase.purchaseProd.prodName}</td></tr>

                    <tr>
                        <th>결제수단</th>
                        <td>
                            <c:set var="paymentOptionTrimmed" value="${fn:trim(purchase.paymentOption)}" />
                            <c:choose>
                                <c:when test="${paymentOptionTrimmed == '1'}">현금구매</c:when>
                                <c:when test="${paymentOptionTrimmed == '2'}">신용구매</c:when>
                                <c:otherwise>확인불가</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    
                    <tr><th>수령인</th><td>${purchase.receiverName}</td></tr>
                    <tr><th>연락처</th><td>${purchase.receiverPhone}</td></tr>
                    <tr><th>배송지</th><td>${purchase.dlvyAddr}</td></tr>
                    <tr><th>요청사항</th><td>${purchase.dlvyRequest}</td></tr>
                    <tr><th>배송희망일</th><td>${purchase.dlvyDate}</td></tr>
                </table>

                <div class="button-group">
                    <button type="button" class="btn btn-brand btn-lg" onclick="location.href='${cPath}/purchase/updatePurchase?tranNo=${purchase.tranNo}'">구매정보 수정</button>
                    <button type="button" class="btn btn-outline-secondary btn-lg" onclick="location.href='${cPath}/purchase/listPurchase'">내 구매목록</button>
                </div>
            </c:if>
        </main>
    </div>
</body>
</html>