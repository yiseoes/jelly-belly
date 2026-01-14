<%--
  Jelly Belly - Welcome Page
  Cute Candy Shop Landing
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cPath" value="${pageContext.request.contextPath}" />

<%-- If logged in, redirect to main --%>
<c:if test="${ ! empty sessionScope.user }">
    <jsp:forward page="/product/main"/>
</c:if>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Jelly Belly - Sweet Candy Shop</title>
</head>

<body>

    <jsp:include page="/layout/toolbar.jsp" />

    <div class="page-container" style="max-width: 700px; margin-top: 5rem;">
        <div class="p-5 rounded-4 text-center" style="background: linear-gradient(135deg, #FFF8F0, #FFF0F5); border: 2px dashed #FFB3C6;">

            <%-- Candy Icon --%>
            <div style="font-size: 5rem; margin-bottom: 1rem;">
                &#127852;&#127851;&#127853;
            </div>

            <%-- Logo --%>
            <h1 style="font-family: 'Pacifico', cursive; font-size: 3.5rem; color: #FF6B9D; margin-bottom: 1rem;">
                Jelly Belly
            </h1>

            <%-- Tagline --%>
            <p class="lead" style="color: #5D4E60; margin: 1.5rem 0 2rem; font-size: 1.1rem;">
                Welcome to the sweetest candy shop in town!<br/>
                Discover delicious jellies, chocolates, lollipops & more.
            </p>

            <%-- CTA Buttons --%>
            <div class="d-flex gap-3 justify-content-center flex-wrap">
                <a class="btn btn-brand btn-lg menu-login" href="#" role="button">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Login
                </a>
                <a class="btn btn-lg menu-add-user" href="${cPath}/user/addUserView.jsp" role="button"
                   style="background: white; border: 2px solid #FF6B9D; color: #FF6B9D; border-radius: 25px; padding: 0.6rem 1.5rem;">
                    <i class="bi bi-person-plus me-2"></i>Sign Up
                </a>
            </div>

            <%-- Guest Browse --%>
            <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px dashed #FFB3C6;">
                <a href="${cPath}/product/listProduct?menu=search" style="color: #9E8AA0; text-decoration: none;">
                    <i class="bi bi-bag-heart me-1"></i>
                    Or browse our candy collection as a guest
                </a>
            </div>
        </div>

        <%-- Fun Facts --%>
        <div class="row g-3 mt-4 text-center">
            <div class="col-4">
                <div style="font-size: 2rem;">&#127852;</div>
                <div style="font-size: 0.85rem; color: #9E8AA0;">50+ Flavors</div>
            </div>
            <div class="col-4">
                <div style="font-size: 2rem;">&#128230;</div>
                <div style="font-size: 0.85rem; color: #9E8AA0;">Fast Delivery</div>
            </div>
            <div class="col-4">
                <div style="font-size: 2rem;">&#127873;</div>
                <div style="font-size: 0.85rem; color: #9E8AA0;">Gift Wrapping</div>
            </div>
        </div>
    </div>

    <script>
        document.querySelector('.menu-add-user')?.addEventListener('click', function(e) {
            e.preventDefault();
            location.href = '${cPath}/user/addUserView.jsp';
        });
    </script>
</body>
</html>
