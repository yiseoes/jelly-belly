<%--
  Jelly Belly - Login Page
  Sweet Login Form
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <c:set var="cPath" value="${pageContext.request.contextPath}" />
    <script>
        window.appContextPath = "${pageContext.request.contextPath}";
    </script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jelly Belly - Login</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Jua&family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

    <style>
        :root {
            --brand-color: #FF6B9D;
            --brand-dark: #E91E63;
            --brand-light: #FFB3C6;
            --focus-color: #FFB3C6;
            --border-color: #F5E1E9;
            --text-main: #5D4E60;
            --text-subtle: #9E8AA0;
            --bg-cream: #FFF8F0;
            --bg-pink: #FFF0F5;

            --kakao-bg: #FEE500;
            --kakao-text: #191919;
            --naver-bg: #03C75A;
            --naver-text: #FFFFFF;
        }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            color: var(--text-main);
            background: linear-gradient(135deg, var(--bg-cream) 0%, var(--bg-pink) 100%);
            background-attachment: fixed;
            min-height: 100vh;
        }

        .page-container {
            width: 100%;
            max-width: 420px;
            margin: 0 auto;
            padding: 2rem 1.5rem 4rem;
        }

        .login-card {
            background: white;
            border-radius: 24px;
            padding: 2.5rem 2rem;
            box-shadow: 0 8px 30px rgba(255, 107, 157, 0.15);
        }

        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-header .icon {
            font-size: 3rem;
            margin-bottom: 0.5rem;
        }

        .page-header h1 {
            font-family: 'Jua', 'Pacifico', cursive;
            font-size: 2.5rem;
            color: var(--brand-color);
            margin: 0;
        }

        .page-header h1 a {
            text-decoration: none;
            color: inherit;
        }

        .page-header p {
            color: var(--text-subtle);
            font-size: 0.9rem;
            margin-top: 0.5rem;
        }

        .form-control {
            border-radius: 12px;
            border: 2px solid var(--border-color);
            padding: 0.85rem 1rem;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            border-color: var(--brand-color);
            box-shadow: 0 0 0 4px rgba(255, 107, 157, 0.15);
        }

        .btn-brand {
            border-radius: 12px;
            background: linear-gradient(135deg, var(--brand-color), var(--brand-dark));
            border: none;
            color: #fff;
            padding: 0.85rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-brand:hover {
            background: linear-gradient(135deg, var(--brand-dark), var(--brand-color));
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(255, 107, 157, 0.3);
            color: white;
        }

        .sub-links {
            text-align: center;
            margin-top: 1.5rem;
            margin-bottom: 2rem;
        }

        .sub-links a, .sub-links span, .sub-links button {
            color: var(--text-subtle);
            font-size: 0.9rem;
            text-decoration: none;
            margin: 0 0.5rem;
        }

        .sub-links a:hover, .sub-links button:hover {
            color: var(--brand-color);
        }

        .sub-links button {
            background: none;
            border: none;
            padding: 0;
            cursor: pointer;
        }

        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            color: var(--text-subtle);
            font-size: 0.8rem;
            text-transform: uppercase;
            margin-bottom: 1.5rem;
        }

        .divider::before, .divider::after {
            content: "";
            flex: 1;
            border-bottom: 1px dashed var(--border-color);
        }

        .divider:not(:empty)::before { margin-right: 1em; }
        .divider:not(:empty)::after { margin-left: 1em; }

        .btn-social {
            border-radius: 12px;
            padding: 0.75rem;
            font-weight: 500;
            text-decoration: none;
            text-align: center;
            transition: all 0.2s ease;
        }

        .btn-kakao {
            background-color: var(--kakao-bg);
            border: 1px solid var(--kakao-bg);
            color: var(--kakao-text);
        }

        .btn-kakao:hover {
            background-color: #e6cf00;
            color: var(--kakao-text);
            transform: translateY(-1px);
        }

        .btn-naver {
            background-color: var(--naver-bg);
            border: 1px solid var(--naver-bg);
            color: var(--naver-text);
        }

        .btn-naver:hover {
            background-color: #02b350;
            color: var(--naver-text);
            transform: translateY(-1px);
        }

        .btn-google {
            background-color: #fff;
            border: 2px solid var(--border-color);
            color: var(--text-main);
        }

        .btn-google:hover {
            background-color: var(--bg-pink);
            border-color: var(--brand-light);
            color: var(--text-main);
            transform: translateY(-1px);
        }

        .form-check-input:checked {
            background-color: var(--brand-color);
            border-color: var(--brand-color);
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 2rem;
            color: var(--text-subtle);
            text-decoration: none;
            font-size: 0.9rem;
        }

        .back-link:hover {
            color: var(--brand-color);
        }
    </style>
</head>
<body>

    <div class="page-container">

        <div class="login-card">
            <header class="page-header">
                <div class="icon">&#127852;</div>
                <a href="${cPath}/" class="text-decoration-none"><h1>Login</h1></a>
                <p>Welcome back to Jelly Belly!</p>
            </header>

            <main>
                <form id="loginForm" onsubmit="return false;" novalidate>

                    <div id="formError" class="text-danger mb-3" style="min-height: 1.2rem; font-size: 0.9rem; text-align: center;"></div>

                    <div class="mb-3">
                        <input type="text"
                               id="userId"
                               name="userId"
                               class="form-control"
                               placeholder="ID"
                               required>
                    </div>

                    <div class="mb-3">
                        <input type="password"
                               id="password"
                               name="password"
                               class="form-control"
                               placeholder="Password"
                               required>
                    </div>

                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="rememberId">
                        <label class="form-check-label" for="rememberId" style="color: var(--text-main); font-size: 0.9rem;">
                            Remember ID
                        </label>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" id="btnLogin" class="btn btn-brand">
                            <i class="bi bi-box-arrow-in-right me-2"></i>Login
                        </button>
                    </div>
                </form>

                <div class="sub-links">
                    <a href="#">Forgot Password?</a>
                    <span>/</span>
                    <button type="button" id="linkAddUserBtn">Sign Up</button>
                </div>

                <div class="divider">OR</div>

                <div class="d-grid gap-2">
                    <a id="btnKakao" class="btn btn-social btn-kakao" href="#">
                        <i class="bi bi-chat-fill me-2"></i>Login with Kakao
                    </a>
                    <a id="btnNaver" class="btn btn-social btn-naver" href="#" target="_top">
                        <strong class="me-2">N</strong>Login with Naver
                    </a>
                    <a id="btnGoogle" class="btn btn-social btn-google" href="#">
                        <i class="bi bi-google me-2"></i>Login with Google
                    </a>
                </div>
            </main>
        </div>

        <a href="${cPath}/" class="back-link">
            <i class="bi bi-arrow-left me-1"></i>Back to Home
        </a>
    </div>

    <script src="${cPath}/javascript/CommonScript.js?v=login-hook-2"></script>
    <script src="${cPath}/javascript/loginView.js?v=2"></script>

    <script type="text/javascript">
        (function () {
            var origin = window.location.protocol + '//' + window.location.hostname + (window.location.port ? ':' + window.location.port : '');
            function guessContextPath() {
                var p = window.location.pathname || '';
                if (!p) return '';
                var parts = p.split('/');
                if (parts.length >= 3) {
                    return (parts[1] && parts[1] !== 'user') ? ('/' + parts[1]) : '';
                }
                return '';
            }
            var cPath = guessContextPath();
            var redirectKakao  = origin + cPath + '/user/kakao/callback';
            var redirectGoogle = origin + cPath + '/user/google/callback';
            var naverLoginUrl  = origin + cPath + '/user/naver/login';

            var kakaoAuth =
                'https://kauth.kakao.com/oauth/authorize'
                + '?client_id=' + encodeURIComponent('YOUR_KAKAO_CLIENT_ID')  // TODO: 실제 카카오 REST API 키로 교체
                + '&redirect_uri=' + encodeURIComponent(redirectKakao)
                + '&response_type=code'
                + '&scope=' + encodeURIComponent('profile_nickname account_email')
                + '&prompt=login';

            var googleAuth =
                'https://accounts.google.com/o/oauth2/v2/auth'
                + '?client_id=' + encodeURIComponent('YOUR_GOOGLE_CLIENT_ID')  // TODO: 실제 구글 클라이언트 ID로 교체
                + '&redirect_uri=' + encodeURIComponent(redirectGoogle)
                + '&response_type=code'
                + '&scope=' + encodeURIComponent('https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile')
                + '&prompt=select_account'
                + '&access_type=offline'
                + '&include_granted_scopes=true';

            var btnK = document.getElementById('btnKakao');
            var btnG = document.getElementById('btnGoogle');
            var btnN = document.getElementById('btnNaver');

            if (btnK) btnK.setAttribute('href', kakaoAuth);
            if (btnG) btnG.setAttribute('href', googleAuth);
            if (btnN) btnN.setAttribute('href', naverLoginUrl);

            // Sign up button
            var linkBtn = document.getElementById('linkAddUserBtn');
            if (linkBtn) {
                linkBtn.addEventListener('click', function() {
                    location.href = '${cPath}/user/addUserView.jsp';
                });
            }
        })();
    </script>

</body>
</html>
