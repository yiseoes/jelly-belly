
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <c:set var="cPath" value="${pageContext.request.contextPath}" />
    <title>Jelly Belly - Purchase</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Jua&family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${cPath}/css/yiseo-theme.css?v=20260109c">
    <script type="text/javascript" src="${cPath}/javascript/calendar.js"></script>
</head>
<body>

    <jsp:include page="/layout/toolbar.jsp" />

    <div class="page-container">
        <header class="page-header">
            <h1>Order</h1>
        </header>

        <main>
            <c:choose>
                <c:when test="${empty product}">
                    <p>상품 정보가 없습니다.</p>
                </c:when>
                <c:otherwise>
                    <div class="purchase-prod-info">
                        <img src="${cPath}/images/uploadFiles/${product.imageFile}"
                             alt="${fn:escapeXml(product.prodName)}"
                             onerror="this.onerror=null; this.src='${cPath}/images/no-image.svg';" />
                        <div class="prod-details">
                            <div class="prod-name">${product.prodName}</div>
                            <div class="prod-price"><fmt:formatNumber value="${product.price}" pattern="#,##0"/> 원</div>
                            <div>상품번호: ${product.prodNo}</div>
                        </div>
                    </div>

                    <form action="${cPath}/purchase/addPurchase" method="post" name="purchaseForm">
                        <input type="hidden" name="prodNo" value="${product.prodNo}"/>

                        <div class="form-container">
                            <div class="row mb-3">
                                <label class="col-md-3 col-form-label">구매자</label>
                                <div class="col-md-9">
                                    <input type="text" class="form-control" value="${sessionScope.user.userId}" readonly />
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-md-3 col-form-label">결제방법</label>
                                <div class="col-md-9">
                                    <select name="paymentOption" class="form-select">
                                        <option value="1">현금구매</option>
                                        <option value="2">신용구매</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-md-3 col-form-label">수령인</label>
                                <div class="col-md-9">
                                    <input type="text" class="form-control" name="receiverName" value="${sessionScope.user.userName}" required>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-md-3 col-form-label">연락처</label>
                                <div class="col-md-9">
                                    <input type="text" class="form-control" name="receiverPhone" value="${sessionScope.user.phone}" required>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-md-3 col-form-label">배송지</label>
                                <div class="col-md-9">
                                    <input type="text" class="form-control" name="dlvyAddr" value="${sessionScope.user.addr}" placeholder="주소" required>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-md-3 col-form-label">요청사항</label>
                                <div class="col-md-9">
                                    <input type="text" class="form-control" name="dlvyRequest" placeholder="부재 시 문 앞에 놓아주세요.">
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-md-3 col-form-label">희망배송일</label>
                                <div class="col-md-9">
                                    <div class="input-with-unit">
                                        <input type="text" class="form-control" id="dlvyDate" name="dlvyDate" readonly="readonly" style="width:150px;" maxLength="10" placeholder="YYYY-MM-DD">
                                        <img src="${cPath}/images/ct_icon_date.svg" width="20" height="20" class="calendar-icon" style="cursor:pointer;"
                                             onclick="show_calendar('document.purchaseForm.dlvyDate', document.purchaseForm.dlvyDate.value)"
                                             onerror="this.style.display='none';">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="button-group">
                            <button type="submit" class="btn btn-brand btn-lg">구매 신청</button>
                            <button type="button" class="btn btn-outline-secondary btn-lg" onclick="location.href='${cPath}/product/getProduct?prodNo=${product.prodNo}'">취소</button>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</body>
</html>