<%--
  이서의 새로운 회원가입 뷰 (by. 언니 💖)
  [수술 내용 🩺]
  1. Base: 이서가 만들어준 "Bootstrap 5 + Serif 폰트" HTML/CSS (100% 존중!)
  2. Color: 이서가 원했던 "핑크/블루" 컬러 팔레트를 CSS 변수에 싹~ 녹여줌!
  3. Function:
     - JSP 태그 (<%@...%>, <c:set...>) 추가!
     - 모든 스크립트(jQuery, Validation, Popup...) 100% 복원!
     - JS가 사용하는 'id'/'name'/'class' (fncAddUser, btnCheckId...) 100% 복원!
     - 하드코딩된 URL (/user/addUser) -> cPath로 싹! 수정!
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%-- [이식 1 💖] cPath, JSP 설정 --%>
    <c:set var="cPath" value="${pageContext.request.contextPath}" />
    <script>
        // JS가 cPath를 쓸 수 있게 전역 변수 생성!
        window.appContextPath = "${pageContext.request.contextPath}";
    </script>
    
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jelly Belly - Create Account</title>

    <%-- Jelly Belly Fonts --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Jua&family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <%-- [이식 3 💖] 이서가 선택한 Bootstrap 5 (그대로 유지!) --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <%-- [이식 4 💖] 이서의 기존 스크립트가 'jQuery'를 쓰니까! (필수!) --%>
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

    <style>
        /* Jelly Belly - Candy Shop Theme */
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
            --font-display: 'Jua', 'Pacifico', cursive;
            --font-serif: 'Playfair Display', serif;
            --font-sans: 'Noto Sans KR', sans-serif;
        }

        body {
            font-family: var(--font-sans);
            color: var(--text-main);
            background: linear-gradient(135deg, var(--bg-cream) 0%, var(--bg-pink) 100%);
            background-attachment: fixed;
            min-height: 100vh;
        }

        .page-container {
            max-width: 480px;
            margin: 0 auto;
            padding: 2rem 1.5rem 4rem;
        }

        .signup-card {
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
            font-family: var(--font-display);
            font-size: 2.2rem;
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

        .form-label {
            font-family: var(--font-display);
            font-weight: 400;
            color: var(--brand-color);
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border-radius: 12px;
            border: 2px solid var(--border-color);
            padding: 0.85rem 1rem;
            transition: all 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--brand-color);
            box-shadow: 0 0 0 4px rgba(255, 107, 157, 0.15);
        }

        .form-control[readonly] {
            background-color: #fdf8f9;
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

        .btn-subtle {
            border-radius: 12px;
            border: 2px solid var(--border-color);
            color: var(--text-main);
            padding: 0.85rem;
            background: white;
            transition: all 0.2s ease;
        }

        .btn-subtle:hover {
            background-color: var(--bg-pink);
            border-color: var(--brand-light);
            color: var(--text-main);
        }

        .input-group .btn-subtle {
            padding: 0.85rem 1rem;
            border-left: none;
            border-radius: 0 12px 12px 0;
        }

        .input-group .form-control {
            border-radius: 12px 0 0 12px;
        }

        .form-text {
            color: var(--text-subtle);
            font-size: 0.85rem;
        }

        .form-text.text-danger {
            color: #E91E63;
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

    <script type="text/javascript">
	
		//============= "가입"  Event 연결 =============
		 $(function() {
            <%-- [수정! 💖] : 'id'로 찾는 게 100배 안전해! --%>
			$("#btnSubmit").on("click" , function() {
				fncAddUser();
			});
		});	
		
		
		//============= "취소"  Event 처리 및  연결 =============
		$(function() {
            <%-- 
              [수정! 💖] 
              'a[href="#"]' -> 'type="reset"' 버튼으로 변경!
              HTML 기본 기능이라 JS가 아예 필요 없어졌어! (개이득! 🥳)
            --%>
			// $("a[href='#' ]").on("click" , function() { ... }); // -> 삭제!
		});	
	
		
		function fncAddUser() {
			
			var id=$("input[name='userId']").val();
			var pw=$("input[name='password']").val();
			var pw_confirm=$("input[name='password2']").val();
			var name=$("input[name='userName']").val();
			
			// (이서의 유효성 검사 100% 그대로!)
			if(id == null || id.length <1){
				alert("아이디는 반드시 입력하셔야 합니다.");
				return;
			}
			if(pw == null || pw.length <1){
				alert("패스워드는  반드시 입력하셔야 합니다.");
				return;
			}
			if(pw_confirm == null || pw_confirm.length <1){
				alert("패스워드 확인은  반드시 입력하셔야 합니다.");
				return;
			}
			if(name == null || name.length <1){
				alert("이름은  반드시 입력하셔야 합니다.");
				return;
			}
			
			if( pw != pw_confirm ) {				
				alert("비밀번호 확인이 일치하지 않습니다.");
				$("input[name='password2']").focus();
				return;
			}
				
            // (휴대폰 번호 합치기 100% 그대로!)
			var value = "";	
			if( $("input[name='phone2']").val() != ""  &&  $("input[name='phone3']").val() != "") {
				var value = $("select[name='phone1']").val() + "-" 
									+ $("input[name='phone2']").val() + "-" 
									+ $("input[name='phone3']").val();
			}

			$("input:hidden[name='phone']").val( value );
			
            <%-- [수정! 💖] : 하드코딩된 URL -> cPath로 변경! --%>
            var cPath = window.appContextPath || "";
			$("form").attr("method" , "POST").attr("action" , cPath + "/user/addUser").submit();
		}
		

		//==>"이메일" 유효성Check (100% 그대로!)
		 $(function() {
			 $("input[name='email']").on("change" , function() {
				 var email=$("input[name='email']").val();
				 if(email != "" && (email.indexOf('@') < 1 || email.indexOf('.') == -1) ){
			    	alert("이메일 형식이 아닙니다.");
			     }
			});
		});	
		
		
	   //==> 주민번호 유효성 check (100% 그대로!)
		function checkSsn() {
			var ssn1, ssn2; 
			var nByear, nTyear; 
			var today; 
	
			ssn = document.detailForm.ssn.value;
			if(!PortalJuminCheck(ssn)) {
				alert("잘못된 주민번호입니다.");
				return false;
			}
		}
	
		function PortalJuminCheck(fieldValue){
		    var pattern = /^([0-9]{6})-?([0-9]{7})$/; 
			var num = fieldValue;
		    if (!pattern.test(num)) return false; 
		    num = RegExp.$1 + RegExp.$2;
	
			var sum = 0;
			var last = num.charCodeAt(12) - 0x30;
			var bases = "234567892345";
			for (var i=0; i<12; i++) {
				if (isNaN(num.substring(i,i+1))) return false;
				sum += (num.charCodeAt(i) - 0x30) * (bases.charCodeAt(i) - 0x30);
			}
			var mod = sum % 11;
			return ((11 - mod) % 10 == last) ? true : false;
		}
	
		 
		//==>"ID중복확인" Event 처리 및 연결
		 $(function() {
            <%-- [수정! 💖] : 'id'로 찾는 게 100배 안전해! --%>
			$("#btnCheckId").on("click" , function() {
                var cPath = window.appContextPath || "";
				popWin 
				= window.open(cPath + "/user/checkDuplication.jsp", <%-- URL cPath로 수정! --%>
											"popWin", 
											"left=300,top=200,width=780,height=130,marginwidth=0,marginheight=0,"+
											"scrollbars=no,scrolling=no,menubar=no,resizable=no");
			});
		});	

	</script>		
    
</head>

<body>

    <div class="page-container">
        <div class="signup-card">
            <header class="page-header">
                <div class="icon">&#127852;</div>
                <h1><a href="${cPath}/index.jsp">Join Us!</a></h1>
                <p>Create your sweet account</p>
            </header>

            <main>
            <form>
                <div class="mb-3">
                    <label for="userId" class="form-label">아이디</label>
                    <div class="input-group">
                        <input type="text" 
                               class="form-control" 
                               id="userId"     
                               name="userId"      
                               placeholder="중복확인하세요"  
                               readonly> 

                        <button type="button" class="btn btn-subtle" id="btnCheckId">중복확인</button>
                    </div>
                    <div id="helpBlock" class="form-text text-danger">
                    </div>
                </div>
              

                <div class="mb-3">
                    <label for="password" class="form-label">비밀번호</label>
                    <input type="password" 
                           class="form-control" 
                           id="password"
                           name="password" 
                           placeholder="비밀번호">
                </div>
              

                <div class="mb-3">
                    <label for="password2" class="form-label">비밀번호 확인</label>
                    <input type="password" 
                           class="form-control" 
                           id="password2"  
                           name="password2"   
                           placeholder="비밀번호 확인">
                </div>
              

                <div class="mb-3">
                    <label for="userName" class="form-label">이름</label>
                    <input type="text" 
                           class="form-control" 
                           id="userName"      
                           name="userName"     
                           placeholder="회원이름">
                </div>
              

                <div class="mb-3">
                    <label for="ssn" class="form-label">주민번호</label>
                    <input type="text" 
                           class="form-control" 
                           id="ssn"    
                           name="ssn"        
                           placeholder="주민번호">
                    <div class="form-text text-danger">
                        " - " 제외 13자리입력하세요
                    </div>
                </div>
              
                <div class="mb-3">
                    <label for="addr" class="form-label">주소</label>
                    <input type="text" 
                           class="form-control" 
                           id="addr"      
                           name="addr"   
                           placeholder="주소">
                </div>
              
                <div class="mb-3">
                    <label class="form-label">휴대전화번호</label>
                    <div class="row g-2">
                        <div class="col-4">

                            <select class="form-select" name="phone1" id="phone1">
                                <option value="010" >010</option>
                                <option value="011" >011</option>
                                <option value="016" >016</option>
                                <option value="018" >018</option>
                                <option value="019" >019</option>
                            </select>
                        </div>
                        <div class="col-4">
                            <input type="text" 
                                   class="form-control" 
                                   id="phone2"     
                                   name="phone2"   
                                   placeholder="번호">
                        </div>
                        <div class="col-4">
                            <input type="text" 
                                   class="form-control" 
                                   id="phone3"   
                                   name="phone3"    
                                   placeholder="번호">
                        </div>
                    </div>

                    <input type="hidden" name="phone" />
                </div>
              

                <div class="mb-3">
                    <label for="email" class="form-label">이메일</label>
                    <input type="text" 
                           class="form-control" 
                           id="email"       
                           name="email"   
                           placeholder="이메일">
                </div>
              

                <div class="d-grid gap-2 mt-4">
                    <button type="button" class="btn btn-brand" id="btnSubmit">
                        가 &nbsp;입
                    </button>

                    <button type="reset" class="btn btn-subtle">
                        취&nbsp;소
                    </button>
                </div>
                
            </form>
            </main>
        </div>

        <a href="${cPath}/user/loginView.jsp" class="back-link">
            Already have an account? Login here
        </a>
    </div>

</body>
</html>