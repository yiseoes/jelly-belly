<%--
  Jelly Belly - Candy Shop Navigation
  Cute & Sweet Navbar Theme
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="cPath" value="${pageContext.request.contextPath}" />

<%-- Google Fonts (Jua for Korean titles, Pacifico for English, Gowun Batang for content) --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Jua&family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">

<%-- Bootstrap 5 CSS --%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<%-- Jelly Belly Theme CSS --%>
<link rel="stylesheet" href="${cPath}/css/yiseo-theme.css?v=20260109c">

<nav class="navbar navbar-expand-lg sticky-top yiseo-navbar">
    <div class="container-fluid" style="max-width: 1100px;">

        <%-- Logo --%>
        <a class="navbar-brand d-flex align-items-center" href="${cPath}/product/main">
            <i class="bi bi-balloon-heart-fill me-2" style="color: #FF6B9D;"></i>
            Jelly Belly
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#jellyNav"
                aria-controls="jellyNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="jellyNav">

            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <%-- Member Menu --%>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-heart me-1"></i> My Page
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#">
                            <i class="bi bi-person-circle me-2"></i>My Info
                        </a></li>
                        <c:if test="${sessionScope.user.role == 'admin'}">
                            <li><a class="dropdown-item" href="#">
                                <i class="bi bi-people me-2"></i>Member List
                            </a></li>
                        </c:if>
                    </ul>
                </li>

                <%-- Admin Menu --%>
                <c:if test="${sessionScope.user.role == 'admin'}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-shop me-1"></i> Manage
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item menu-add-product" href="#">
                                <i class="bi bi-plus-circle me-2"></i>Add Product
                            </a></li>
                            <li><a class="dropdown-item menu-manage-product" href="#">
                                <i class="bi bi-grid me-2"></i>Product List
                            </a></li>
                        </ul>
                    </li>
                </c:if>

                <%-- Shop Menu --%>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-bag-heart me-1"></i> Shop
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item menu-search-product" href="#">
                            <i class="bi bi-search me-2"></i>Browse Candy
                        </a></li>
                        <c:if test="${sessionScope.user.role == 'user'}">
                            <li><a class="dropdown-item menu-purchase-history" href="#">
                                <i class="bi bi-receipt me-2"></i>My Orders
                            </a></li>
                        </c:if>
                        <li><a class="dropdown-item" href="#">
                            <i class="bi bi-clock-history me-2"></i>Recently Viewed
                        </a></li>
                    </ul>
                </li>
            </ul>

            <%-- Login/Logout --%>
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <li class="nav-item">
                            <a href="#" class="btn btn-brand-outline menu-login">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Login
                            </a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item d-flex align-items-center me-3">
                            <span class="text-muted small">
                                <i class="bi bi-heart-fill text-danger me-1"></i>
                                Hello, ${sessionScope.user.userName}!
                            </span>
                        </li>
                        <li class="nav-item">
                            <a href="#" class="btn btn-brand-outline menu-logout">
                                <i class="bi bi-box-arrow-right me-1"></i> Logout
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<%-- jQuery & Bootstrap JS --%>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
    $(function () {
        // Logout
        $(".menu-logout").on("click", function () {
            $(self.location).attr("href", "${cPath}/user/logout");
        });

        // Login
        $(".menu-login").on("click", function () {
            $(self.location).attr("href", "${cPath}/user/loginView.jsp");
        });

        // Member List (Admin)
        $("a:contains('Member List')").on("click", function () {
            self.location = "${cPath}/user/listUser";
        });

        // My Info
        $("a:contains('My Info')").on("click", function () {
            $(self.location).attr("href",
                "${cPath}/user/getUser?userId=${sessionScope.user.userId}");
        });

        // Add Product
        $(".menu-add-product").on("click", function () {
            self.location = "${cPath}/product/addProduct";
        });

        // Product List (Manage)
        $(".menu-manage-product").on("click", function () {
            self.location = "${cPath}/product/listProduct?menu=manage";
        });

        // Browse Products
        $(".menu-search-product").on("click", function () {
            self.location = "${cPath}/product/listProduct?menu=search";
        });

        // Purchase History
        $(".menu-purchase-history").on("click", function () {
            self.location = "${cPath}/purchase/listPurchase";
        });
    });
</script>
