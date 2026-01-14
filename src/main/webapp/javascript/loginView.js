/**
 * Jelly Belly - Login View JavaScript
 * Handles login form submission and validation
 */

(function() {
    'use strict';

    var cPath = window.appContextPath || '';

    // DOM Ready
    document.addEventListener('DOMContentLoaded', function() {
        initLoginForm();
        initRememberId();
    });

    /**
     * Initialize login form
     */
    function initLoginForm() {
        var form = document.getElementById('loginForm');
        var btnLogin = document.getElementById('btnLogin');
        var formError = document.getElementById('formError');

        if (!form || !btnLogin) return;

        // Handle form submission
        btnLogin.addEventListener('click', function(e) {
            e.preventDefault();
            handleLogin();
        });

        // Also handle Enter key
        form.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                handleLogin();
            }
        });
    }

    /**
     * Handle login submission
     */
    function handleLogin() {
        var userId = document.getElementById('userId');
        var password = document.getElementById('password');
        var formError = document.getElementById('formError');
        var rememberId = document.getElementById('rememberId');

        // Clear previous errors
        if (formError) formError.textContent = '';

        // Validate
        if (!userId || !userId.value.trim()) {
            showError('아이디를 입력해주세요.');
            if (userId) userId.focus();
            return;
        }

        if (!password || !password.value.trim()) {
            showError('비밀번호를 입력해주세요.');
            if (password) password.focus();
            return;
        }

        // Save ID if remember is checked
        if (rememberId && rememberId.checked) {
            setCookie('savedUserId', userId.value.trim(), 30);
        } else {
            eraseCookie('savedUserId');
        }

        // Submit login via AJAX
        submitLogin(userId.value.trim(), password.value);
    }

    /**
     * Submit login request
     */
    function submitLogin(userId, password) {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', cPath + '/user/login', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            // Login successful - redirect to main page
                            window.location.href = cPath + '/product/main';
                        } else {
                            showError(response.message || '로그인에 실패했습니다.');
                        }
                    } catch (e) {
                        // If not JSON, assume success and redirect
                        window.location.href = cPath + '/product/main';
                    }
                } else if (xhr.status === 401) {
                    showError('아이디 또는 비밀번호가 일치하지 않습니다.');
                } else {
                    showError('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                }
            }
        };

        xhr.onerror = function() {
            showError('네트워크 오류가 발생했습니다.');
        };

        xhr.send('userId=' + encodeURIComponent(userId) + '&password=' + encodeURIComponent(password));
    }

    /**
     * Show error message
     */
    function showError(message) {
        var formError = document.getElementById('formError');
        if (formError) {
            formError.textContent = message;
            formError.style.display = 'block';
        } else {
            alert(message);
        }
    }

    /**
     * Initialize Remember ID feature
     */
    function initRememberId() {
        var userId = document.getElementById('userId');
        var rememberId = document.getElementById('rememberId');

        if (!userId || !rememberId) return;

        // Load saved ID
        var savedId = getCookie('savedUserId');
        if (savedId) {
            userId.value = savedId;
            rememberId.checked = true;
        }
    }

    // Cookie utilities
    function setCookie(name, value, days) {
        var expires = '';
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = '; expires=' + date.toUTCString();
        }
        document.cookie = name + '=' + (value || '') + expires + '; path=/';
    }

    function getCookie(name) {
        var nameEQ = name + '=';
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) === ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
        }
        return null;
    }

    function eraseCookie(name) {
        document.cookie = name + '=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
    }

})();

console.log('loginView.js loaded successfully!');
