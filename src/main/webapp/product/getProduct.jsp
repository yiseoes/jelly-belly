
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <c:set var="cPath" value="${pageContext.request.contextPath}" />
    <title>Jelly Belly - Product Details</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Jua&family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${cPath}/css/yiseo-theme.css?v=20260109c">

    <style>
        .detail-image {
            width: 100%;
            aspect-ratio: 1 / 1;
            object-fit: cover;
            border: 1px solid var(--border-color);
        }
        .detail-prod-name {
            font-family: var(--font-serif);
            font-size: 2.25rem;
            font-weight: 600;
            color: var(--text-main);
        }
        .detail-prod-detail {
            font-size: 1rem;
            color: var(--text-main);
            margin-top: 1rem;
            line-height: 1.7;
        }
        .detail-prod-price {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--brand-color);
            margin-top: 1.5rem;
        }
        .detail-meta-table {
            width: 100%;
            margin-top: 1.5rem;
            font-size: 0.9rem;
        }
        .detail-meta-table th {
            width: 100px;
            color: var(--text-subtle);
            padding: 0.5rem 0;
            text-align: left;
        }
        .detail-meta-table td {
            color: var(--text-main);
            padding: 0.5rem 0;
        }
    </style>
</head>

<body>

    <jsp:include page="/layout/toolbar.jsp" />

    <div class="page-container">
    
        <c:choose>
            <c:when test="${not empty product}">
                <%-- 판매상태 코드 정규화 --%>
                <c:set var="pcode" value="${empty product.proTranCode ? '' : fn:trim(product.proTranCode)}" />
                <c:url var="listUrl" value="/product/listProduct">
                    <c:param name="menu" value="${param.menu}" />
                </c:url>

                <header class="page-header">
                    <h1>Take a Bite!</h1>
                    <div class="d-flex gap-2">
                        <c:if test="${!isAdmin}">
                            <c:choose>
                                <c:when test="${pcode == 'SOLD' or pcode == '판매완료'}">
                                    <button type="button" class="btn btn-subtle" disabled style="opacity:.6; cursor:not-allowed;">판매완료</button>
                                </c:when>
                                <c:otherwise>
                                    <a href="${cPath}/purchase/addPurchaseView?prodNo=${product.prodNo}" class="btn btn-brand">구매하기</a>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                        <a href="${listUrl}" class="btn btn-subtle">목록</a>
                        <c:if test="${isAdmin}">
                            <a href="${cPath}/product/updateProduct?prodNo=${product.prodNo}" class="btn btn-brand">수정</a>
                        </c:if>
                    </div>
                </header>

                <div class="row g-4 g-lg-5">
                
                    <div class="col-lg-6">
                        <c:set var="imgSrc" value="${cPath}/images/no-image.svg" />
                        <c:if test="${not empty product.imageFile}">
                            <c:set var="imgSrc" value="${cPath}/images/uploadFiles/${product.imageFile}" />
                        </c:if>
                        <img src="${imgSrc}"
                             alt="상품이미지"
                             class="detail-image"
                             onerror="this.onerror=null; this.src='${cPath}/images/no-image.svg';" />
                    </div>

                    <div class="col-lg-6">
                        <h1 class="detail-prod-name">${product.prodName}</h1>
                        <p class="detail-prod-detail">${product.prodDetail}</p>
                        <div class="detail-prod-price">
                            <fmt:formatNumber value="${product.price}" type="number" /> 원
                        </div>
                        
                        <hr class="my-4" style="border-color: var(--border-color);">
                        
                        <table class="detail-meta-table">
                            <tbody>
                                <tr>
                                    <th>상품번호</th>
                                    <td>${product.prodNo}</td>
                                </tr>
                                <tr>
                                    <th>제조일자</th>
                                    <td>${product.manufactureDay}</td>
                                </tr>
                                <tr>
                                    <th>등록일자</th>
                                    <td>
                                        <fmt:formatDate value="${product.regDate}"
                                                        pattern="yyyy-MM-dd" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <header class="page-header">
                    <h1>오류</h1>
                </header>
                <main>
                    <p>요청하신 상품 정보를 찾을 수 없습니다.</p>
                    <a href="${cPath}/product/listProduct" class="btn btn-subtle">
                        목록으로 돌아가기
                    </a>
                </main>
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>