
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <c:set var="cPath" value="${pageContext.request.contextPath}" />
    <title>Jelly Belly - My Orders</title>

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
            <h1>My Orders</h1>
        </header>

        <main>
            <c:choose>
                <c:when test="${empty list}">
                    <p>구매 내역이 없습니다.</p>
                </c:when>
                <c:otherwise>

                    <table class="table table-hover list-table align-middle">
                        <thead>
                            <tr>
                                <th>거래번호</th>
                                <th>상품번호</th>
                                <th>상품명</th>
                                <th>가격</th>
                                <th>거래상태</th>
                                <th>상품상태</th>
                                <th>상세</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${list}">
                                <tr>
                                    <td>${p.tranNo}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty p.purchaseProd}">${p.purchaseProd.prodNo}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty p.purchaseProd}">${p.purchaseProd.prodName}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty p.purchaseProd and not empty p.purchaseProd.price}">
                                                <fmt:formatNumber value="${p.purchaseProd.price}" type="number"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:set var="tcode" value="${fn:trim(p.tranCode)}"/>
                                        <c:choose>
                                            <c:when test="${tcode=='1'}">상품준비중 <span class="muted">(1)</span></c:when>
                                            <c:when test="${tcode=='2'}">배송중 <span class="muted">(2)</span></c:when>
                                            <c:when test="${tcode=='3'}">배송완료 <span class="muted">(3)</span></c:when>
                                            <c:otherwise>상태미정
                                                <c:if test="${not empty tcode}">
                                                    <span class="muted">(${tcode})</span>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty p.purchaseProd and not empty p.purchaseProd.proTranCode}">
                                                ${p.purchaseProd.proTranCode}
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:url var="detailUrl" value="/purchase/getPurchase">
                                            <c:param name="tranNo" value="${p.tranNo}"/>
                                        </c:url>
                                        <a href="${detailUrl}">보기</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="page-navigation">
                        <c:set var="curr" value="${empty currentPage ? resultPage.currentPage : currentPage}" />
                        <c:set var="ps"   value="${empty pageSize    ? resultPage.pageSize   : pageSize}" />
                        <c:set var="sp"   value="${empty startPage   ? resultPage.beginUnitPage : startPage}" />
                        <c:set var="ep"   value="${empty endPage     ? resultPage.endUnitPage   : endPage}" />

                        <c:forEach var="i" begin="${sp}" end="${ep}">
                            <c:choose>
                                <c:when test="${i == curr}">
                                    <strong>${i}</strong>
                                </c:when>
                                <c:otherwise>
                                    <c:url var="pageUrl" value="/purchase/listPurchase">
                                        <c:param name="currentPage" value="${i}"/>
                                        <c:param name="pageSize"    value="${ps}"/>
                                    </c:url>
                                    <a href="${pageUrl}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</body>
</html>