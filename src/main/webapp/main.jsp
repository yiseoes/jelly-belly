<%--
  Jelly Belly - Main Page
  Sweet Candy Shop Landing Page
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="cPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Jelly Belly - Sweet Candy Shop</title>

    <style>
        /* Hero Carousel */
        .hero-carousel .carousel-item {
            height: 75vh;
            min-height: 450px;
            position: relative;
            overflow: hidden;
        }
        .hero-carousel .carousel-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: brightness(0.85);
        }
        .hero-carousel .carousel-caption {
            bottom: 50%;
            transform: translateY(50%);
            text-shadow: 2px 2px 10px rgba(0,0,0,0.3);
        }
        .hero-carousel .carousel-caption h2 {
            font-family: 'Pacifico', cursive;
            font-size: 3.5rem;
            color: #fff;
            margin-bottom: 1rem;
        }
        .hero-carousel .carousel-caption p {
            font-size: 1.25rem;
            color: rgba(255,255,255,0.9);
        }

        /* Section Headers */
        .section-header {
            text-align: center;
            margin-bottom: 2.5rem;
            position: relative;
        }
        .section-header h2 {
            font-family: 'Pacifico', cursive;
            font-size: 2.2rem;
            color: #FF6B9D;
            display: inline-block;
            position: relative;
        }
        .section-header h2::before,
        .section-header h2::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 50px;
            height: 3px;
            background: linear-gradient(90deg, #FFB3C6, #FF6B9D);
            border-radius: 2px;
        }
        .section-header h2::before {
            right: 100%;
            margin-right: 20px;
        }
        .section-header h2::after {
            left: 100%;
            margin-left: 20px;
        }
        .section-header p {
            color: #9E8AA0;
            margin-top: 0.5rem;
            font-size: 0.95rem;
        }

        /* Category Cards */
        .category-section {
            padding: 3rem 0;
            background: linear-gradient(135deg, #FFF8F0 0%, #FFF0F5 100%);
        }
        .category-card {
            background: white;
            border-radius: 20px;
            padding: 2rem 1.5rem;
            text-align: center;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(255, 107, 157, 0.1);
            height: 100%;
        }
        .category-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(255, 107, 157, 0.2);
        }
        .category-card .icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        .category-card h5 {
            font-family: 'Playfair Display', serif;
            font-weight: 600;
            color: #5D4E60;
            margin-bottom: 0.5rem;
        }
        .category-card p {
            font-size: 0.85rem;
            color: #9E8AA0;
            margin: 0;
        }

        /* Featured Banner */
        .featured-banner {
            background: linear-gradient(135deg, #FF6B9D 0%, #E91E63 100%);
            padding: 4rem 2rem;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }
        .featured-banner::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.1'%3E%3Cpath d='M30 30c0-11.046-8.954-20-20-20s-20 8.954-20 20 8.954 20 20 20 20-8.954 20-20zm0 0c0 11.046 8.954 20 20 20s20-8.954 20-20-8.954-20-20-20-20 8.954-20 20z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            animation: float 30s linear infinite;
        }
        @keyframes float {
            0% { transform: translate(0, 0) rotate(0deg); }
            100% { transform: translate(-50px, -50px) rotate(360deg); }
        }
        .featured-banner h3 {
            font-family: 'Pacifico', cursive;
            font-size: 2.5rem;
            margin-bottom: 1rem;
            position: relative;
        }
        .featured-banner p {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 1.5rem;
            position: relative;
        }
        .featured-banner .btn {
            background: white;
            color: #FF6B9D;
            border: none;
            padding: 0.8rem 2rem;
            border-radius: 30px;
            font-weight: 600;
            position: relative;
            transition: all 0.3s ease;
        }
        .featured-banner .btn:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
        }

        /* Product Section */
        .product-section {
            padding: 4rem 0;
        }

        /* Footer CTA */
        .footer-cta {
            background: #5D4E60;
            color: white;
            padding: 3rem 2rem;
            text-align: center;
        }
        .footer-cta h4 {
            font-family: 'Pacifico', cursive;
            font-size: 1.8rem;
            margin-bottom: 1rem;
        }
        .footer-cta p {
            opacity: 0.8;
            margin-bottom: 1.5rem;
        }
    </style>
</head>

<body>

    <jsp:include page="/layout/toolbar.jsp" />

    <%-- Hero Carousel --%>
    <div id="heroCarousel" class="carousel slide hero-carousel" data-bs-ride="carousel" data-bs-interval="5000">

        <div class="carousel-indicators">
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2" aria-label="Slide 3"></button>
        </div>

        <div class="carousel-inner">
            <%-- Slide 1: Colorful Candies --%>
            <div class="carousel-item active">
                <img src="https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=1600&h=900&fit=crop"
                     class="d-block w-100" alt="Colorful Candies">
                <div class="carousel-caption">
                    <h2>Sweet Dreams Come True</h2>
                    <p>Discover our colorful world of delicious candies</p>
                </div>
            </div>

            <%-- Slide 2: Jelly Beans --%>
            <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1581798269146-84b74435de9d?w=1600&h=900&fit=crop"
                     class="d-block w-100" alt="Jelly Beans">
                <div class="carousel-caption">
                    <h2>Jelly Bean Paradise</h2>
                    <p>Over 50 flavors to explore and enjoy</p>
                </div>
            </div>

            <%-- Slide 3: Chocolate --%>
            <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=1600&h=900&fit=crop"
                     class="d-block w-100" alt="Chocolate Collection">
                <div class="carousel-caption">
                    <h2>Chocolate Heaven</h2>
                    <p>Premium chocolates for every occasion</p>
                </div>
            </div>
        </div>

        <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>

    <%-- Category Section --%>
    <section class="category-section">
        <div class="container">
            <div class="section-header">
                <h2>Sweet Categories</h2>
                <p>Find your favorite treats</p>
            </div>

            <div class="row g-4">
                <div class="col-6 col-md-3">
                    <a href="${cPath}/product/listProduct?menu=search" class="text-decoration-none">
                        <div class="category-card">
                            <div class="icon">&#127852;</div>
                            <h5>Jelly & Gummy</h5>
                            <p>Soft & chewy delights</p>
                        </div>
                    </a>
                </div>
                <div class="col-6 col-md-3">
                    <a href="${cPath}/product/listProduct?menu=search" class="text-decoration-none">
                        <div class="category-card">
                            <div class="icon">&#127851;</div>
                            <h5>Chocolate</h5>
                            <p>Rich & creamy treats</p>
                        </div>
                    </a>
                </div>
                <div class="col-6 col-md-3">
                    <a href="${cPath}/product/listProduct?menu=search" class="text-decoration-none">
                        <div class="category-card">
                            <div class="icon">&#127853;</div>
                            <h5>Lollipops</h5>
                            <p>Sweet on a stick</p>
                        </div>
                    </a>
                </div>
                <div class="col-6 col-md-3">
                    <a href="${cPath}/product/listProduct?menu=search" class="text-decoration-none">
                        <div class="category-card">
                            <div class="icon">&#127856;</div>
                            <h5>Caramel</h5>
                            <p>Buttery goodness</p>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <%-- Best Seller Section --%>
    <section class="product-section">
        <div class="page-container">
            <div class="section-header">
                <h2>Best Sellers</h2>
                <p>Our most loved sweet treats</p>
            </div>

            <div class="row g-3 product-list-grid">
                <c:forEach var="p" items="${bestList}">
                    <div class="col-6 col-md-4 col-lg-3 grid-card">
                        <c:url var="detailUrl" value="/product/getProduct">
                            <c:param name="prodNo" value="${p.prodNo}" />
                            <c:param name="menu" value="search" />
                        </c:url>

                        <a href="${detailUrl}" class="text-decoration-none product-item-grid">
                            <div class="thumb-wrap">
                                <c:set var="imgSrc" value="${cPath}/images/no-image.svg" />
                                <c:if test="${not empty p.imageFile}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(p.imageFile,'http://') or fn:startsWith(p.imageFile,'https://')}">
                                            <c:set var="imgSrc" value="${p.imageFile}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="imgSrc" value="${cPath}/images/uploadFiles/${p.imageFile}" />
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <img class="thumb"
                                     src="${imgSrc}"
                                     alt="${fn:escapeXml(p.prodName)}"
                                     onerror="this.onerror=null; this.src='${cPath}/images/no-image.svg';" />

                                <c:if test="${p.proTranCode == 'SOLD' || p.proTranCode == 'sold'}">
                                    <span class="status-pill-grid">SOLD OUT</span>
                                </c:if>
                            </div>
                            <div class="info p-2">
                                <div class="name"><c:out value="${p.prodName}" /></div>
                                <div class="price price-common">
                                    <fmt:formatNumber value="${p.price}" type="number" /> 원
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>

                <c:if test="${empty bestList}">
                    <div class="col-12 text-center py-5">
                        <div style="font-size: 4rem; margin-bottom: 1rem;">&#127852;</div>
                        <p class="text-muted">Coming soon! Stay tuned for our best sellers.</p>
                        <a href="${cPath}/product/listProduct?menu=search" class="btn btn-brand mt-2">Browse All Products</a>
                    </div>
                </c:if>
            </div>
        </div>
    </section>

    <%-- Featured Banner --%>
    <section class="featured-banner">
        <h3>Sweet Deals Await!</h3>
        <p>Sign up for our newsletter and get 10% off your first order</p>
        <a href="${cPath}/user/addUserView.jsp" class="btn">Join Now</a>
    </section>

    <%-- New Arrivals Section --%>
    <section class="product-section" style="background: #FFF8F0;">
        <div class="page-container">
            <div class="section-header">
                <h2>New Arrivals</h2>
                <p>Fresh from the candy factory</p>
            </div>

            <div class="row g-3 product-list-grid">
                <c:forEach var="p" items="${newList}">
                    <div class="col-6 col-md-4 col-lg-3 grid-card">
                        <c:url var="detailUrl" value="/product/getProduct">
                            <c:param name="prodNo" value="${p.prodNo}" />
                            <c:param name="menu" value="search" />
                        </c:url>

                        <a href="${detailUrl}" class="text-decoration-none product-item-grid">
                            <div class="thumb-wrap">
                                <c:set var="imgSrc" value="${cPath}/images/no-image.svg" />
                                <c:if test="${not empty p.imageFile}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(p.imageFile,'http://') or fn:startsWith(p.imageFile,'https://')}">
                                            <c:set var="imgSrc" value="${p.imageFile}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="imgSrc" value="${cPath}/images/uploadFiles/${p.imageFile}" />
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <img class="thumb"
                                     src="${imgSrc}"
                                     alt="${fn:escapeXml(p.prodName)}"
                                     onerror="this.onerror=null; this.src='${cPath}/images/no-image.svg';" />

                                <c:if test="${p.proTranCode == 'SOLD' || p.proTranCode == 'sold'}">
                                    <span class="status-pill-grid">SOLD OUT</span>
                                </c:if>
                            </div>
                            <div class="info p-2">
                                <div class="name"><c:out value="${p.prodName}" /></div>
                                <div class="price price-common">
                                    <fmt:formatNumber value="${p.price}" type="number" /> 원
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>

                <c:if test="${empty newList}">
                    <div class="col-12 text-center py-5">
                        <div style="font-size: 4rem; margin-bottom: 1rem;">&#127851;</div>
                        <p class="text-muted">New candies are on the way!</p>
                        <a href="${cPath}/product/listProduct?menu=search" class="btn btn-brand mt-2">Browse All Products</a>
                    </div>
                </c:if>
            </div>
        </div>
    </section>

    <%-- Footer CTA --%>
    <section class="footer-cta">
        <h4>Life is Sweet at Jelly Belly</h4>
        <p>Follow us on social media for the latest treats and special offers!</p>
        <div class="d-flex justify-content-center gap-3">
            <a href="#" class="btn btn-brand-outline" style="color: white; border-color: white;">
                <i class="bi bi-instagram"></i>
            </a>
            <a href="#" class="btn btn-brand-outline" style="color: white; border-color: white;">
                <i class="bi bi-facebook"></i>
            </a>
            <a href="#" class="btn btn-brand-outline" style="color: white; border-color: white;">
                <i class="bi bi-twitter"></i>
            </a>
        </div>
    </section>

</body>
</html>
