
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <c:set var="cPath" value="${pageContext.request.contextPath}" />
    <title>Jelly Belly - Update Product</title>
    
    <script type="text/javascript" src="${cPath}/javascript/calendar.js"></script>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Jua&family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="${cPath}/css/yiseo-theme.css?v=20260109c">
</head>
<body>
    
    <jsp:include page="/layout/toolbar.jsp" />

    <div class="page-container">
    
        <c:choose>
            <c:when test="${not empty product}">
                <header class="page-header">
                    <h1>Edit Candy</h1>

                </header>
                
                <main>

                    <form name="productForm" action="${cPath}/product/updateProduct" method="post" enctype="multipart/form-data" class="mt-4">
                        <input type="hidden" name="prodNo" value="${product.prodNo}" />
                        <input type="hidden" name="imageFile" value="${product.imageFile}" />
                        
                        <input type="hidden" name="searchCondition" value="${param.searchCondition}" />
                        <input type="hidden" name="searchKeyword" value="${param.searchKeyword}" />
                        <input type="hidden" name="currentPage" value="${param.currentPage}" />
                        <input type="hidden" name="view" value="${param.view}" />
                    
                        <div class="mb-3">
                            <label for="prodName" class="form-label">
                                상품명 <span class="required-mark">*</span>
                            </label>

                            <input type="text" 
                                   class="form-control"
                                   id="prodName"
                                   name="prodName" 
                                   value="<c:out value='${product.prodName}'/>" 
                                   required />
                        </div>

                        <div class="mb-3">
                            <label for="prodDetail" class="form-label">
                                상품 상세 정보 <span class="required-mark">*</span>
                            </label>

                            <textarea id="prodDetail"
                                      name="prodDetail" 
                                      class="form-control" 
                                      rows="5"
                                      required><c:out value='${product.prodDetail}'/></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="manufactureDay" class="form-label">
                                제조일자 <span class="required-mark">*</span>
                            </label>
                            <div class="input-group" style="max-width: 250px;">

                                <input type="text" 
                                       class="form-control"
                                       id="manufactureDay"
                                       name="manufactureDay" 
                                       readonly="readonly"
                                       maxLength="10" 
                                       placeholder="YYYY-MM-DD" 
                                       value="${product.manufactureDay}" 
                                       required>
                                <span class="input-group-text" style="cursor:pointer;"
                                      onclick="show_calendar('document.productForm.manufactureDay', document.productForm.manufactureDay.value)">
                                    <img src="${cPath}/images/ct_icon_date.svg" width="20" height="20" alt="calendar"
                                         onerror="this.parentElement.innerHTML='&#128197;';">
                                </span>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="price" class="form-label">
                                가격 <span class="required-mark">*</span>
                            </label>
                            <div class="input-group" style="max-width: 250px;">

                                <input type="text" 
                                       class="form-control"
                                       id="price"
                                       name="price" 
                                       value="<fmt:formatNumber value="${product.price}" groupingUsed="true" />" 
                                       required 
                                       inputmode="numeric" 
                                       pattern="[0-9,]*">
                                <span class="input-group-text">원</span>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="imageFile" class="form-label">상품 이미지</label>
                            <input type="file" 
                                   class="d-none"
                                   id="imageFile"
                                   name="fName"
                                   accept=".jpg,.jpeg,.png,.gif,.jfif">
                            
                            <div class="d-flex align-items-center gap-2">
                                <label for="imageFile" class="btn btn-subtle mb-0">이미지 변경</label>

                                <span id="imageFileName" class="text-muted">
                                    <c:out value="${empty product.imageFile ? '선택된 파일 없음' : product.imageFile}" />
                                </span>
                            </div>
                            

                            <c:if test="${not empty product.imageFile}">
                                <img id="imagePreview" src="${cPath}/images/uploadFiles/${product.imageFile}" alt="미리보기" class="image-preview" />
                            </c:if>
                            <c:if test="${empty product.imageFile}">
                                <img id="imagePreview" alt="미리보기" style="display:none;" class="image-preview" />
                            </c:if>
                        </div>
                        
                        <hr class="my-4">

                        <div class="d-flex justify-content-end gap-2">
                            <button type="submit" class="btn btn-brand">완료</button>
                            <button type="button" class="btn btn-subtle" onclick="location.href='${cPath}/product/getProduct?prodNo=${product.prodNo}'">취소</button>
                        </div>
                        
                    </form>
                </main>
            </c:when>
            
            <c:otherwise>
                <header class="page-header">
                    <h1>오류</h1>
                </header>
                <main>
                    <p>상품 정보를 찾을 수 없습니다.</p>
                    <a href="${cPath}/product/listProduct" class="btn btn-subtle">
                        목록으로 돌아가기
                    </a>
                </main>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
    (function(){
      // 파일 업로드 UI 처리
      var fileInput = document.getElementById('imageFile');
      if(fileInput) {
        fileInput.addEventListener('change', function(e) {
            var file = this.files && this.files[0];
            var fileNameSpan = document.getElementById('imageFileName');
            var imagePreview = document.getElementById('imagePreview');

            if (file) {
                fileNameSpan.textContent = file.name;
                var reader = new FileReader();
                reader.onload = function(event) {
                    imagePreview.src = event.target.result;
                    imagePreview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
        });
      }
      
      // 폼 제출 관련 스크립트
      var form = document.forms['productForm'];
      if(!form) return;

      var price = form.querySelector("[name='price']");
      if(price){
        price.addEventListener("input", function(){
          var raw = this.value.replace(/[^0-9]/g,"");
          this.value = raw ? Number(raw).toLocaleString() : "";
        });
      }

      var sending = false;
      form.addEventListener("submit", function(e){
        if(sending){ e.preventDefault(); return false; }
        if(price){ price.value = price.value.replace(/[^0-G]/g,""); }
        sending = true;
        setTimeout(function(){ sending=false; }, 1500);
      });
    })();
    </script>
</body>
</html>