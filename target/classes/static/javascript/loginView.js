// /javascript/loginView.js
// [최종 수정!] 
// 1. 로그인 성공 시 이서가 말한 '/main.jsp'로 이동!
// 2. 하드코딩된 모든 URL 앞에 'window.appContextPath'를 붙여서 cPath 문제 완벽 해결!
(function ($) {

  // 💖 cPath 가져오기 (loginView.jsp에서 만든 전역 변수!)
  var cPath = window.appContextPath || "";

  // AJAX 로그인
  function runLoginAjax(id, pw) {
    $("#formError").text("");

    $.ajax({
      url: cPath + "/user/json/login", // 💖 cPath 적용!
      method: "POST",
      dataType: "json",
      contentType: "application/json",
      data: JSON.stringify({ userId: id, password: pw })
    }).done(function (data) {
      // 서버가 돌려준 userId/password가 내가 보낸 값과 일치할 때만 성공으로 간주
      var ok = !!(
        data && data.userId && data.password &&
        data.userId === id && data.password === pw
      );

      if (ok) {
        alert((data.userName ? data.userName : "회원") + "님, 환영합니다!");
        
        // [언니가 수정함! 💖]
        // 이서가 말한 '/main.jsp'로 이동!
        var mainPageUrl = cPath + "/main.jsp"; // 💖 cPath 적용!

        if (window.parent) {
          window.parent.location.href = mainPageUrl;
        } else {
          window.location.href = mainPageUrl;
        }
      } else {
        // ✅ 아이디/비밀번호 불일치 안내
        $("#formError").text("아이디와 비밀번호를 다시 확인해 주세요.");
        $("#password").val("").focus();
      }
    }).fail(function () {
      $("#formError").text("로그인 중 오류가 발생했습니다. 다시 시도해 주세요.");
      $("#password").val("").focus();
    });
  }

  $(function () {
    // ... (중략: input 이벤트 핸들러) ...
    $("#userId, #password").on("input", function () {
      var v = $(this).val();
      if (v !== v.trim()) {
        $(this).val(v.trim());
      }
      $("#formError").text("");
    });

    // ... (중략: 폼 제출 이벤트) ...
    $("#loginForm").on("submit", function (e) {
      e.preventDefault();

      var id = ($("#userId").val() || "").trim();
      var pw = ($("#password").val() || "").trim();

      if (!id && !pw) {
        $("#formError").text("아이디와 비밀번호를 입력해 주세요.");
        $("#userId").focus();
        return;
      }
      if (!id) {
        $("#formError").text("아이디를 입력해 주세요.");
        $("#userId").focus();
        return;
      }
      if (!pw) {
        $("#formError").text("비밀번호를 입력해 주세요.");
        $("#password").focus();
        return;
      }

      if (!FormValidation(this)) {
        return;
      }

      runLoginAjax(id, pw);
    });

    // 회원가입 이동
    $("#linkAddUser, #linkAddUserBtn").on("click", function (e) {
      e.preventDefault();
      
      var registerUrl = cPath + "/user/addUser"; // 💖 cPath 적용!

      if (window.parent) {
        window.parent.location.href = registerUrl;
      } else {
        window.location.href = registerUrl;
      }
    });
  });

})(jQuery);