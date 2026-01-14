<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <c:set var="cPath" value="${pageContext.request.contextPath}" />
    <title>Jelly Belly - Oops!</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --brand-color: #FF6B9D;
            --text-main: #5D4E60;
            --text-subtle: #9E8AA0;
            --bg-cream: #FFF8F0;
            --bg-pink: #FFF0F5;
        }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: linear-gradient(135deg, var(--bg-cream) 0%, var(--bg-pink) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        .error-container {
            text-align: center;
            max-width: 500px;
        }

        .error-icon {
            font-size: 6rem;
            margin-bottom: 1rem;
        }

        .error-title {
            font-family: 'Pacifico', cursive;
            font-size: 2.5rem;
            color: var(--brand-color);
            margin-bottom: 1rem;
        }

        .error-message {
            color: var(--text-main);
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }

        .btn-brand {
            background: linear-gradient(135deg, var(--brand-color), #E91E63);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .btn-brand:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(255, 107, 157, 0.4);
            color: white;
        }

        .error-details {
            margin-top: 2rem;
            padding: 1rem;
            background: rgba(255,255,255,0.7);
            border-radius: 12px;
            font-size: 0.85rem;
            color: var(--text-subtle);
            text-align: left;
        }
    </style>
</head>
<body>

    <div class="error-container">
        <div class="error-icon">&#127852;</div>
        <h1 class="error-title">Oops!</h1>
        <p class="error-message">
            Something went wrong while processing your request.<br>
            Don't worry, our candy elves are on it!
        </p>
        <a href="${cPath}/product/main" class="btn-brand">
            Back to Sweet Home
        </a>

        <%-- Debug info (only in development) --%>
        <c:if test="${not empty exception}">
            <div class="error-details">
                <strong>Error Details:</strong><br>
                ${exception.message}
            </div>
        </c:if>
    </div>

</body>
</html>
