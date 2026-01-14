
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <meta charset="UTF-8" />
    <c:set var="cPath" value="${pageContext.request.contextPath}" />
    <title>Jelly Belly - Candy Shop</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=Jua&family=Pacifico&family=Noto+Sans+KR:wght@400;500;700&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${cPath}/css/yiseo-theme.css?v=20260109c">
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
    <script src="${cPath}/javascript/CommonScript.js"></script>

    <%-- 이 페이지의 JS (오토컴플릿, 무한스크롤 등) --%>
    <script type="text/javascript">
    // ============================================
    //  페이징 / 검색 (기존 함수 유지)
    // ============================================
    function fncGetUserList(currentPage) {
        var form =
            document.getElementById("searchForm") ||
            document.forms["searchForm"] ||
            document.forms["detailForm"] ||
            document.querySelector("form");

        if (!form) {
            var qs = new URLSearchParams(location.search);
            qs.set("currentPage", currentPage || 1);
            location.href = location.pathname + "?" + qs.toString();
            return;
        }

        var cp = form.querySelector('input[name="currentPage"]');
        if (!cp) {
            cp = document.createElement("input");
            cp.type = "hidden";
            cp.name = "currentPage";
            cp.id = "currentPage";
            form.appendChild(cp);
        }
        cp.value = currentPage || 1;

        form.method = "GET";
        form.submit();
    }


    $(function () {

        // ==============================
        // 보기 전환 (리스트 / 그리드)
        // ==============================
        $('#btn-view-list').on('click', function () {
            $('.view-switcher button').removeClass('active');
            $(this).addClass('active');
            $('.product-list-grid').hide();
            $('.product-list-table').show();
            $('input[name="view"]').val('list');
        });

        $('#btn-view-grid').on('click', function () {
            $('.view-switcher button').removeClass('active');
            $(this).addClass('active');
            $('.product-list-table').hide();
            $('.product-list-grid').show();
            $('input[name="view"]').val('grid');
        });

        // ==============================
        // 테이블 행 클릭 → 상세 (내부 a, 토글 버튼 제외)
        // ==============================
        $('.product-list-table').on('click', '.product-item-table', function (e) {
            if ($(e.target).closest('a, .tran-toolbar').length) {
                return;
            }
            var href = $(this).data('href');
            if (href) {
                window.location.href = href;
            }
        });

        // ==============================
        // 그리드 카드 클릭 → 팝업 상세
        // ==============================
        $('.product-list-grid').on('click', '.product-item-grid', function (event) {
            event.preventDefault();

            var prodNo = $(this).data('prodno');
            if (!prodNo) return;

            $.ajax({
                url: "${cPath}/product/json/getProduct/" + prodNo,
                type: "GET",
                dataType: "json"
            }).done(function (product) {
                var regDateText = product.regDate || "정보 없음";
                var content = ''
                    + '<h4>' + (product.prodName || '') + '</h4>'
                    + '<p class="price"><strong>가격:</strong> '
                    + Number(product.price || 0).toLocaleString()
                    + ' 원</p>'
                    + '<p><strong>상태:</strong> '
                    + (product.proTranCode || '판매중') + '</p>'
                    + '<p><strong>상세:</strong> '
                    + (product.prodDetail || '상세 정보 없음') + '</p>'
                    + '<p><strong>등록일:</strong> '
                    + regDateText + '</p>';
                $('#product-popover')
                    .html(content)
                    .css({
                        left: event.pageX + 15,
                        top: event.pageY + 15
                    })
                    .show();
            }).fail(function () {
                alert("상세 정보를 불러오는 데 실패했어요");
            });
        });

        // 팝업 외부 클릭 시 닫기
        $(document).on('click', function (event) {
            if (!$(event.target).closest('.product-item-grid, #product-popover').length) {
                $('#product-popover').hide();
            }
        });

        // ==============================
        // 배송상태 토글
        // ==============================
        $(document).on('click', '.tran-toolbar .tran-btn', function (e) {
            e.preventDefault();
            e.stopPropagation(); 
            var $btn = $(this);
            var code = $btn.data('code');
            var prodNo = $btn.closest('.tran-toolbar').data('prodno');
            var qs = $('#searchForm').serialize();
            if (!qs || qs.indexOf('currentPage=') === -1) {
                var nowPage = '${resultPage.currentPage}' || '1';
                qs += (qs ? '&' : '') + 'currentPage=' + encodeURIComponent(nowPage);
            }
            qs += '&prodNo=' + encodeURIComponent(prodNo)
                + '&tranCode=' + encodeURIComponent(code);
            window.location.href =
                '${cPath}/purchase/updateTranCodeByProd' + '?' + qs;
        });

        // ======================================
        //  무한 스크롤 (IntersectionObserver 사용)
        // ======================================
        var loading = false;
        var currentPage = Number("${resultPage.currentPage}");
        var pageSize = Number("${resultPage.pageSize}");
        var totalCount = Number("${resultPage.totalCount}");
        var totalPage = Number("${resultPage.totalPage}"); 

        function buildNextUrl(nextPage) {
            var base = ($('#searchForm').attr('action') || '').split('?')[0] || location.pathname;
            var params = $('#searchForm').serializeArray();
            var found = false;
            for (var i = 0; i < params.length; i++) {
                if (params[i].name === 'currentPage') {
                    params[i].value = String(nextPage);
                    found = true;
                    break;
                }
            }
            if (!found) {
                params.push({ name: 'currentPage', value: String(nextPage) });
            }
            var viewVal = $('input[name="view"]').val() || '${param.view}';
            if (viewVal) {
                params.push({ name: 'view', value: viewVal });
            }
            var qs = $.param(params);
            return base + '?' + qs;
        }

        function appendRowsFrom(html) {
            var $tmp = $('<div>').html(html);
            var $newTableRows = $tmp.find('.product-list-table .product-item-table');
            var $newGridCards = $tmp.find('.product-list-grid > .grid-card');
            var hasData = ($newTableRows.length + $newGridCards.length) > 0;
            if (hasData) {
                $('.product-list-table tbody').append($newTableRows);
                $('.product-list-grid').append($newGridCards);
                return true;
            }
            return false;
        }

        function loadNextPage() {
            if (loading) return;
            if (currentPage >= totalPage) return; 
            loading = true;
            var nextPage =
                (isNaN(currentPage) || currentPage < 1) ? 2 : (currentPage + 1);
            var url = buildNextUrl(nextPage);
            $('.infinite-loading')
                .text('다음 목록을 불러오는 중...')
                .show();
            $.get(url).done(function (html) {
                var ok = appendRowsFrom(html);
                if (ok) {
                    currentPage = nextPage;
                } else {
                    $(window).off('scroll');
                    if (observer) {
                        observer.disconnect();
                    }
                    $('.infinite-loading').text('더 이상 데이터가 없습니다.');
                }
                if (currentPage >= totalPage) {
                    $(window).off('scroll');
                    if (observer) {
                        observer.disconnect();
                    }
                    $('.infinite-loading').hide();
                }
            }).fail(function (xhr) {
                $('.infinite-loading')
                    .text('요청 실패(' + xhr.status + ')');
            }).always(function () {
                loading = false;
                if (currentPage < totalPage) {
                    $('.infinite-loading').hide();
                }
            });
        }

        var observer = null;
        var $sentinel = $('#scrollSentinel');
        if ('IntersectionObserver' in window && $sentinel.length) {
            observer = new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        loadNextPage();
                    }
                });
            }, {
                root: null,
                rootMargin: '200px 0px',
                threshold: 0
            });
            observer.observe($sentinel.get(0));
        } else {
            $(window).on('scroll', function () {
                if (loading) return;
                if (currentPage >= totalPage) return;
                var nearBottom =
                    $(window).scrollTop() + $(window).height() >
                    $(document).height() - 500;
                if (nearBottom) {
                    loadNextPage();
                }
            });
        }
        setTimeout(function () {
            if ($(document).height() <= $(window).height() + 50) {
                if (currentPage < totalPage) {
                    loadNextPage();
                }
            }
        }, 120);

        // ======================================
        // 오토컴플릿 (0:상품명 / 1:상세 / 2:상품번호)
        // ======================================
        var $kw = $('input[name="searchKeyword"]');
        var $cond = $('select[name="searchCondition"]');

        $('#searchForm').on('submit', function () {
            return FormValidation(this);
        });

        // [정상 동작 보장!]
        // 툴바의 jQuery 3.1.1 + 이 페이지의 jQuery UI = 100% 작동!
        if ($kw.length && $cond.length && $.ui && $.ui.autocomplete) {
            $kw.autocomplete({
                minLength: 1,
                delay: 150,
                autoFocus: false,
                source: function (request, response) {
                    var sc = String($cond.val()); 
                    $.ajax({
                        url: '${cPath}/product/json/autocomplete',
                        dataType: 'json',
                        cache: true,
                        data: {
                            searchCondition: sc,
                            searchKeyword: request.term
                        }
                    }).done(function (data) {
                        response((data && data.items) || []);
                    }).fail(function (xhr) {
                        console.warn('autocomplete xhr fail', xhr.status);
                        response([]);
                    });
                },
                select: function (e, ui) {
                    if (ui && ui.item) {
                        $kw.val(ui.item.value);
                    }
                    return false;
                },
                focus: function (e) {
                    e.preventDefault();
                }
            });
        } else {
            console.warn('autocomplete guard: target or $.ui not ready');
        }

        // ==============================
        // 최초 진입 시 view 파라미터에 따라 뷰 토글
        // ==============================
        var currentView = '${param.view}';
        if (currentView === 'grid') {
            $('.product-list-table').hide();
            $('.product-list-grid').show();
            $('#btn-view-list').removeClass('active');
            $('#btn-view-grid').addClass('active');
        } else {
            $('.product-list-grid').hide();
            $('.product-list-table').show();
            $('#btn-view-list').addClass('active');
            $('#btn-view-grid').removeClass('active');
        }
    }); // end of $(function)
    </script>
</head>

<body>
    <jsp:include page="/layout/toolbar.jsp" />

    <div class="page-container">

        <header class="page-header">
            <h1>Candy Shop</h1>
            <div class="btn-group view-switcher" role="group">
                <button type="button" 
                        id="btn-view-list"
                        class="btn btn-subtle ${empty param.view || param.view == 'list' ? 'active' : ''}">
                    리스트
                </button>
                <button type="button" 
                        id="btn-view-grid"
                        class="btn btn-subtle ${param.view == 'grid' ? 'active' : ''}">
                    앨범
                </button>
            </div>
        </header>
        
        <main>
            <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">

                <form id="searchForm"
                      name="detailForm"
                      action="${cPath}/product/listProduct"
                      method="get"
                      class="d-flex gap-2">

                    <input type="hidden" name="menu"
                           value="${param.menu}" />
                    <input type="hidden" id="currentPage" name="currentPage"
                           value="${!empty search.currentPage ? search.currentPage : 1}" />
                    <input type="hidden" name="view"
                           value="${param.view}" />
                    
                    <select name="searchCondition"
                            class="form-select"
                            style="width:auto;"
                            fieldTitle="검색조건"
                            required="required">
                        <option value="0" <c:if test="${search.searchCondition == 0}">selected</c:if>>
                            상품명
                        </option>
                        <option value="1" <c:if test="${search.searchCondition == 1}">selected</c:if>>
                            상세
                        </option>
                        <option value="2" <c:if test="${search.searchCondition == 2}">selected</c:if>>
                            상품번호
                        </option>
                    </select>

                    <input type="text"
                           class="form-control"
                           style="width:250px;"
                           name="searchKeyword"
                           value="${fn:escapeXml(search.searchKeyword)}"
                           placeholder="검색어를 입력하세요"
                           fieldTitle="검색어"
                           minLength="0" />

                    <button type="submit" class="btn btn-brand">
                        검색
                    </button>
                </form>

                <c:if test="${isAdmin}">
                    <form action="${cPath}/product/addProduct" method="get">
                        <input type="hidden" name="menu" value="${param.menu}" />
                        <button type="submit" class="btn btn-brand">상품 등록</button>
                    </form>
                </c:if>
            </div>

            <%-- [리스트 뷰] --%>
            <table class="table product-list-table align-middle">
                <colgroup>
                    <col style="width:100px" />
                    <col />
                    <col style="width:120px" />
                    <col style="width:180px" />
                    <col style="width:120px" />
                </colgroup>
                <thead class="table-light">
                    <tr>
                        <th class="text-center">이미지</th>
                        <th>상품명 / 상세</th>
                        <th class="text-center">등록일</th>
                        <th class="text-center">상태</th>
                        <th class="text-end">가격</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${list}">
                        <c:url var="detailUrl" value="/product/getProduct">
                            <c:param name="prodNo"            value="${p.prodNo}" />
                            <c:param name="menu"              value="${param.menu}" />
                            <c:param name="searchCondition" value="${search.searchCondition}" />
                            <c:param name="searchKeyword"   value="${search.searchKeyword}" />
                            <c:param name="currentPage"     value="${search.currentPage}" />
                            <c:param name="view"              value="${param.view}" />
                        </c:url>

                        <tr class="product-item-table" data-href="${detailUrl}">
                            <td class="text-center">
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
                                     alt="thumb"
                                     onerror="this.onerror=null; this.src='${cPath}/images/no-image.svg';" />
                            </td>
                            <td>
                                <div class="prod-name">
                                    <a href="${detailUrl}">
                                        <c:out value="${p.prodName}" />
                                    </a>
                                </div>
                                <div class="prod-detail">
                                    <c:out value="${p.prodDetail}" />
                                </div>
                            </td>
                            <td class="text-center">
                                <fmt:formatDate value="${p.regDate}" pattern="yyyy-MM-dd" />
                            </td>
                            <td class="text-center">
                                <c:set var="pcode"
                                       value="${empty p.proTranCode ? '' : fn:trim(p.proTranCode)}" />
                                <c:choose>
                                    <c:when test="${pcode == 'SOLD' || pcode == '판매완료'}">
                                        <span class="status-pill status-sold">판매완료</span>
                                        <c:if test="${isAdmin}">
                                            <span class="tran-toolbar" data-prodno="${p.prodNo}">
                                                <a href="#" data-code="1" class="tran-btn btn btn-sm btn-outline-secondary">1</a>
                                                <a href="#" data-code="2" class="tran-btn btn btn-sm btn-outline-secondary">2</a>
                                                <a href="#" data-code="3" class="tran-btn btn btn-sm btn-outline-secondary">3</a>
                                            </span>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill">판매중</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end price-common">
                                <fmt:formatNumber value="${p.price}" type="number" /> 원
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty list and resultPage.currentPage == 1}">
                        <tr>
                            <td colspan="5" class="text-center py-5 text-muted">등록된 상품이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <%-- [앨범 뷰] --%>
            <div class="row g-3 product-list-grid" style="display:none;">
                <c:forEach var="p" items="${list}">
                    <div class="col-6 col-md-4 col-lg-3 grid-card">
                        <c:url var="detailUrlGrid" value="/product/getProduct">
                            <c:param name="prodNo"            value="${p.prodNo}" />
                            <c:param name="menu"              value="${param.menu}" />
                            <c:param name="searchCondition" value="${search.searchCondition}" />
                            <c:param name="searchKeyword"   value="${search.searchKeyword}" />
                            <c:param name="currentPage"     value="${search.currentPage}" />
                            <c:param name="view"              value="${param.view}" />
                        </c:url>
                        <a href="${detailUrlGrid}"
                           class="text-decoration-none product-item-grid"
                           data-prodno="${p.prodNo}">
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
                                     alt="thumb"
                                     onerror="this.onerror=null; this.src='${cPath}/images/no-image.svg';" />
                                <c:if test="${p.proTranCode == 'SOLD' || p.proTranCode == '판매완료'}">
                                    <span class="status-pill-grid">SOLD OUT</span>
                                </c:if>
                            </div>
                            <div class="info p-2">
                                <div class="name">
                                    <c:out value="${p.prodName}" />
                                </div>
                                <div class="price price-common">
                                    <fmt:formatNumber value="${p.price}" type="number" /> 원
                                </div>
                            </div>
                        </a>
                        <c:if test="${isAdmin && (p.proTranCode == 'SOLD' || p.proTranCode == '판매완료')}">
                            <div class="tran-toolbar d-flex justify-content-center gap-1" data-prodno="${p.prodNo}">
                                <a href="#" data-code="1" class="tran-btn btn btn-sm btn-outline-secondary">1</a>
                                <a href="#" data-code="2" class="tran-btn btn btn-sm btn-outline-secondary">2</a>
                                <a href="#" data-code="3" class="tran-btn btn btn-sm btn-outline-secondary">3</a>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
                <c:if test="${empty list and resultPage.currentPage == 1}">
                    <div class="col-12 no-data-grid text-center py-5 text-muted">등록된 상품이 없습니다.</div>
                </c:if>
            </div>
            
            <div class="infinite-loading"></div>
            <div id="scrollSentinel"></div>
            <div id="product-popover" class="product-popover"></div>
            

            <%-- 무한스크롤 적용으로 페이지네이션 제거 --%>
            
        </main>
    </div>
    
</body>
</html>