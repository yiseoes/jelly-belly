
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Jelly Belly - Edit Profile</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Jua&family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${cPath}/css/yiseo-theme.css?v=20260109c">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    
    <script type="text/javascript">
        //============= "수정"  Event 연결 =============
        $(function() {
            $( "button.btn-brand" ).on("click" , function() {
                fncUpdateUser();
            });
        }); 
        
        //============= "취소"  Event 처리 및  연결 =============
        $(function() {
            $( "button.btn-outline-secondary" ).on("click" , function() {
                $("form")[0].reset();
            });
        }); 
        
        //=============이메일" 유효성Check  Event 처리 =============
        $(function() {
             $("input[name='email']").on("change" , function() {
                 var email=$("input[name='email']").val();
                 if(email != "" && (email.indexOf('@') < 1 || email.indexOf('.') == -1) ){
                    alert("이메일 형식이 아닙니다.");
                 }
            });
        }); 
        
        //============= (중요!) 전화번호 합치기 로직 (100% 보존!) =============
        function fncUpdateUser() {
            var name=$("input[name='userName']").val();
            
            if(name == null || name.length <1){
                alert("이름은  반드시 입력하셔야 합니다.");
                return;
            }
            
            // 전화번호 3칸 -> 1칸 (hidden)으로 합치기
            var value = ""; 
            if( $("input[name='phone2']").val() != ""  &&  $("input[name='phone3']").val() != "") {
                var value = $("select[name='phone1']").val() + "-" 
                                    + $("input[name='phone2']").val() + "-" 
                                    + $("input[name='phone3']").val();
            }
            $("input:hidden[name='phone']").val( value );
                
            $("form").attr("method" , "POST").attr("action" , "/user/updateUser").submit();
        }
    </script>
</head>

<body>
    <jsp:include page="/layout/toolbar.jsp" />

    <div class="page-container">
        <header class="page-header">
            <h1>Edit Profile</h1>
        </header>

        <main>
            <form>
                <div class="form-container">
                    
                    <div class="row mb-3">
                        <label for="userId" class="col-md-3 col-form-label">아 이 디</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="userId" name="userId" value="${user.userId }" readonly>
                            <div class="form-text text-danger">
                                <strong>아이디는 수정불가</strong>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label for="password" class="col-md-3 col-form-label">비밀번호</label>
                        <div class="col-md-9">
                            <input type="password" class="form-control" id="password" name="password" placeholder="변경비밀번호">
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <label for="password2" class="col-md-3 col-form-label">비밀번호 확인</label>
                        <div class="col-md-9">
                            <input type="password" class="form-control" id="password2" name="password2" placeholder="변경비밀번호 확인">
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <label for="userName" class="col-md-3 col-form-label">이름</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="userName" name="userName" value="${user.userName}" placeholder="변경회원이름">
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <label for="addr" class="col-md-3 col-form-label">주소</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="addr" name="addr"  value="${user.addr}" placeholder="변경주소">
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <label for="phone1" class="col-md-3 col-form-label">휴대전화번호</label>
                        <div class="col-md-9">
                            <div class="row g-2">
                                <div class="col-sm-4">
                                    <select class="form-select" name="phone1" id="phone1">
                                        <option value="010" ${ ! empty user.phone1 && user.phone1 == "010" ? "selected" : ""  } >010</option>
                                        <option value="011" ${ ! empty user.phone1 && user.phone1 == "011" ? "selected" : ""  } >011</option>
                                        <option value="016" ${ ! empty user.phone1 && user.phone1 == "016" ? "selected" : ""  } >016</option>
                                        <option value="018" ${ ! empty user.phone1 && user.phone1 == "018" ? "selected" : ""  } >018</option>
                                        <option value="019" ${ ! empty user.phone1 && user.phone1 == "019" ? "selected" : ""  } >019</option>
                                    </select>
                                </div>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="phone2" name="phone2" value="${ ! empty user.phone2 ? user.phone2 : ''}"  placeholder="변경번호">
                                </div>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="phone3" name="phone3" value="${ ! empty user.phone3 ? user.phone3 : ''}"   placeholder="변경번호">
                                </div>
                            </div>
                            <input type="hidden" name="phone" />
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <label for="email" class="col-md-3 col-form-label">이메일</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" id="email" name="email" value="${user.email}" placeholder="변경이메일">
                        </div>
                    </div>
                    
                </div>

                <div class="button-group">
                    <button type="button" class="btn btn-brand btn-lg">수&nbsp;정</button>
                    <button type="button" class="btn btn-outline-secondary btn-lg">취&nbsp;소</button>
                </div>
            </form>
        </main>
    </div>
</body>
</html>