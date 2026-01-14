/**
 * Jelly Belly - Common JavaScript Functions
 */

// Form Validation
function FormValidation(form) {
    var elements = form.elements;
    for (var i = 0; i < elements.length; i++) {
        var el = elements[i];

        // Check required fields
        if (el.hasAttribute('required') && !el.value.trim()) {
            var fieldTitle = el.getAttribute('fieldTitle') || el.name || 'This field';
            alert(fieldTitle + ' is required.');
            el.focus();
            return false;
        }

        // Check min length
        var minLen = el.getAttribute('minLength');
        if (minLen && el.value.length < parseInt(minLen)) {
            var fieldTitle = el.getAttribute('fieldTitle') || el.name || 'This field';
            alert(fieldTitle + ' must be at least ' + minLen + ' characters.');
            el.focus();
            return false;
        }
    }
    return true;
}

// Format number with commas
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Parse number from formatted string
function parseFormattedNumber(str) {
    return parseInt(str.replace(/,/g, '')) || 0;
}

// Debounce function
function debounce(func, wait) {
    var timeout;
    return function() {
        var context = this, args = arguments;
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            func.apply(context, args);
        }, wait);
    };
}

// Cookie functions
function setCookie(name, value, days) {
    var expires = "";
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "") + expires + "; path=/";
}

function getCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}

function eraseCookie(name) {
    document.cookie = name + '=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}

// Check if element is in viewport
function isInViewport(element) {
    var rect = element.getBoundingClientRect();
    return (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    );
}

// Show loading indicator
function showLoading(message) {
    message = message || 'Loading...';
    var overlay = document.createElement('div');
    overlay.id = 'loading-overlay';
    overlay.innerHTML = '<div class="loading-content"><div class="spinner"></div><p>' + message + '</p></div>';
    overlay.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(255,255,255,0.9);display:flex;align-items:center;justify-content:center;z-index:9999;';
    document.body.appendChild(overlay);
}

function hideLoading() {
    var overlay = document.getElementById('loading-overlay');
    if (overlay) {
        overlay.remove();
    }
}

console.log('CommonScript.js loaded successfully!');
