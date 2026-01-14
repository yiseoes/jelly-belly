
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty purchase}">
    <script>alert('구매정보가 없습니다.'); history.back();</script>
</c:if>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <c:set var="cPath" value="${pageContext.request.contextPath}" />
    <title>Jelly Belly - Edit Order</title>

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
            <h1>Edit Order</h1>
        </header>

        <main>
            <form action="${cPath}/purchase/updatePurchase" method="post" name="updateForm">
                <input type="hidden" name="tranNo" value="${purchase.tranNo}" />

                <div class="form-container">
                    <div class="row mb-3">
                        <label class="col-md-3 col-form-label">구매자 ID</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" value="${purchase.buyer.userId}" readonly />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-md-3 col-form-label">구매자 이름</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" value="${purchase.buyer.userName}" readonly />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-md-3 col-form-label">결제수단</label>
                        <div class="col-md-9">
                            <select name="paymentOption" class="form-select">
                                <option value="1" ${purchase.paymentOption=='1' ? 'selected' : ''}>현금구매</option>
                                <option value="2" ${purchase.paymentOption=='2' ? 'selected' : ''}>신용구매</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-md-3 col-form-label">수령인 이름</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="receiverName" value="${purchase.receiverName}" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-md-3 col-form-label">수령인 연락처</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="receiverPhone" value="${purchase.receiverPhone}" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-md-3 col-form-label">배송지</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="dlvyAddr" value="${purchase.dlvyAddr}" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-md-3 col-form-label">배송 요청사항</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="dlvyRequest" value="${purchase.dlvyRequest}" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label class="col-md-3 col-form-label">배송 희망일</label>
                        <div class="col-md-9">
                            <div class="input-with-unit">
                                <input type="text" class="form-control" id="dlvyDate" name="dlvyDate" value="${purchase.dlvyDate}" readonly="readonly" style="width:150px;" maxLength="10" placeholder="YYYY-MM-DD">
                                <img src="${cPath}/images/ct_icon_date.svg" width="20" height="20" class="calendar-icon" style="cursor:pointer;"
                                     onclick="show_calendar('document.updateForm.dlvyDate', document.updateForm.dlvyDate.value)"
                                     onerror="this.style.display='none';">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-brand btn-lg">수정 완료</button>
                    <button type="button" class="btn btn-outline-secondary btn-lg" onclick="location.href='${cPath}/purchase/getPurchase?tranNo=${purchase.tranNo}'">취소</button>
                </div>
            </form>
        </main>
    </div>
</body>
</html>