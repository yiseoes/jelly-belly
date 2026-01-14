package com.model2.mvc.web.purchase;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.purchase.PurchaseService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/purchase/*")
public class PurchaseController {

    @Autowired
    @Qualifier("purchaseServiceImpl")
    private PurchaseService purchaseService;

    @Autowired
    @Qualifier("productServiceImpl")
    private ProductService productService;

    // 12버전 product 쪽과 동일하게 properties 사용
    @Value("${pageUnit}")
    private int pageUnit;

    @Value("${pageSize}")
    private int pageSize;

    public PurchaseController() {
        System.out.println("[CTRL] PurchaseController 생성");
    }

    /** 1) 구매 폼 진입 : GET /purchase/addPurchaseView?prodNo=... */
    @RequestMapping(value="addPurchaseView", method=RequestMethod.GET)
    public String addPurchaseView(@RequestParam int prodNo,
                                  HttpSession session,
                                  Model model) throws Exception {

        System.out.println("/purchase/addPurchaseView : GET");

        // 선택한 상품 정보
        Product product = productService.getProduct(prodNo);
        model.addAttribute("product", product);

        // 로그인 유저(user / userVO 혼재 대응)
        Object login = session.getAttribute("user") != null
                     ? session.getAttribute("user")
                     : session.getAttribute("userVO");
        model.addAttribute("user", login);

        // JSP로 포워드
        return "/purchase/addPurchaseView.jsp";
    }

    /** 2) 구매 등록 : POST /purchase/addPurchase → 등록 후 상세로 리다이렉트 */
    @RequestMapping(value="addPurchase", method=RequestMethod.POST)
    public String addPurchase(
            @RequestParam int prodNo,
            @RequestParam String paymentOption,
            @RequestParam String receiverName,
            @RequestParam String receiverPhone,
            @RequestParam String dlvyAddr,
            @RequestParam(required=false) String dlvyRequest,
            @RequestParam(required=false) String dlvyDate,
            HttpSession session
    ) throws Exception {

        System.out.println("/purchase/addPurchase : POST prodNo=" + prodNo);

        User buyer = (User)( session.getAttribute("user") != null
                           ? session.getAttribute("user")
                           : session.getAttribute("userVO") );

        // Purchase VO 구성
        Purchase vo = new Purchase();
        vo.setBuyer(buyer);

        Product p = new Product();
        p.setProdNo(prodNo);
        vo.setPurchaseProd(p);

        vo.setPaymentOption(paymentOption);
        vo.setReceiverName(receiverName);
        vo.setReceiverPhone(receiverPhone);
        vo.setDlvyAddr(dlvyAddr);
        vo.setDlvyRequest(dlvyRequest);
        vo.setDlvyDate(dlvyDate != null ? dlvyDate.replaceAll("-", "") : null);

        // 기본 배송상태 코드
        vo.setTranCode("1");

        // INSERT (selectKey로 tranNo 셋팅)
        purchaseService.addPurchase(vo);

        // ===== 여기 중요! =====
        // 10버전 : productService.updateProTranCode(prodNo, "SOLD");
        // 12버전 현재 ProductService는 아래 메서드만 존재하니까 이걸로 매핑
        try {
            productService.updateProTranCodeToSold(prodNo);
        } catch (Exception e) {
            System.out.println("[CTRL] updateProTranCodeToSold 실패 : " + e.getMessage());
        }

        return "redirect:/purchase/getPurchase?tranNo=" + vo.getTranNo();
    }

    /** 3) 구매 상세 : GET /purchase/getPurchase?tranNo=... */
    @RequestMapping(value="getPurchase", method=RequestMethod.GET)
    public String getPurchase(@RequestParam int tranNo, Model model) throws Exception {

        System.out.println("/purchase/getPurchase : GET tranNo=" + tranNo);

        model.addAttribute("purchase", purchaseService.getPurchase(tranNo));
        return "/purchase/getPurchase.jsp";
    }

    /** 4) 내 구매 목록 : GET /purchase/listPurchase */
    @RequestMapping(value="listPurchase", method=RequestMethod.GET)
    public String listPurchase(@ModelAttribute("search") Search search,
                               HttpSession session,
                               Model model) throws Exception {

        System.out.println("/purchase/listPurchase : GET");

        if (search == null) {
            search = new Search();
        }
        if (search.getCurrentPage() == 0) {
            search.setCurrentPage(1);
        }
        if (search.getPageSize() == 0) {
            search.setPageSize(pageSize);
        }

        User login = (User)( session.getAttribute("user") != null
                           ? session.getAttribute("user")
                           : session.getAttribute("userVO") );
        String buyerId = (login != null ? login.getUserId() : null);

        Map<String, Object> map = purchaseService.getPurchaseList(search, buyerId);
        int totalCount = (map.get("totalCount") instanceof Integer)
                       ? (Integer) map.get("totalCount")
                       : 0;

        Page resultPage = new Page(
                search.getCurrentPage(),
                totalCount,
                pageUnit,
                search.getPageSize()
        );

        model.addAttribute("list", map.get("list"));
        model.addAttribute("resultPage", resultPage);
        model.addAttribute("currentPage", search.getCurrentPage());
        model.addAttribute("pageSize", search.getPageSize());
        model.addAttribute("startPage", resultPage.getBeginUnitPage());
        model.addAttribute("endPage", resultPage.getEndUnitPage());
        model.addAttribute("totalCount", totalCount);

        return "/purchase/listPurchase.jsp";
    }

    /** 5) 구매 수정 화면 : GET /purchase/updatePurchase?tranNo=... */
    @RequestMapping(value="updatePurchase", method=RequestMethod.GET)
    public String updatePurchaseView(@RequestParam("tranNo") int tranNo, Model model) throws Exception {

        System.out.println("/purchase/updatePurchase : GET tranNo=" + tranNo);

        model.addAttribute("purchase", purchaseService.getPurchase(tranNo));
        model.addAttribute("tranNo", tranNo);
        return "/purchase/updatePurchaseView.jsp";
    }

    /** 6) 구매 수정 처리 : POST /purchase/updatePurchase */
    @RequestMapping(value="updatePurchase", method=RequestMethod.POST)
    public String updatePurchase(
            @RequestParam("tranNo") int tranNo,
            @RequestParam(value="paymentOption", required=false) String paymentOption,
            @RequestParam(value="receiverName",  required=false) String receiverName,
            @RequestParam(value="receiverPhone", required=false) String receiverPhone,
            @RequestParam(value="dlvyAddr",     required=false) String dlvyAddr,
            @RequestParam(value="dlvyRequest",  required=false) String dlvyRequest,
            @RequestParam(value="dlvyDate",     required=false) String dlvyDate
    ) throws Exception {

        System.out.println("/purchase/updatePurchase : POST tranNo=" + tranNo);

        Purchase vo = new Purchase();
        vo.setTranNo(tranNo);

        if (paymentOption != null) vo.setPaymentOption(paymentOption);
        if (receiverName  != null) vo.setReceiverName(receiverName);
        if (receiverPhone != null) vo.setReceiverPhone(receiverPhone);
        if (dlvyAddr      != null) vo.setDlvyAddr(dlvyAddr);
        if (dlvyRequest   != null) vo.setDlvyRequest(dlvyRequest);
        if (dlvyDate      != null) vo.setDlvyDate(dlvyDate.replaceAll("-", ""));

        purchaseService.updatePurchase(vo);

        return "redirect:/purchase/getPurchase?tranNo=" + tranNo;
    }

	    @RequestMapping(value="updateTranCode", method=RequestMethod.GET)
	    public String updateTranCode(@RequestParam int tranNo,
	                                 @RequestParam String tranCode) throws Exception {
	
	        System.out.println("/purchase/updateTranCode : tranNo=" + tranNo + ", tranCode=" + tranCode);
	
	        // Service가 받는 형태에 맞춰 Purchase VO 생성
	        Purchase vo = new Purchase();
	        vo.setTranNo(tranNo);
	        vo.setTranCode(tranCode);
	
	        purchaseService.updateTranCode(vo);
	
	        return "redirect:/purchase/getPurchase?tranNo=" + tranNo;
	    }


    /** 8) 상품 기준 배송상태 일괄 변경 : GET /purchase/updateTranCodeByProd?prodNo=&tranCode= */
    @RequestMapping(value="updateTranCodeByProd", method=RequestMethod.GET)
    public String updateTranCodeByProd(
            @RequestParam int prodNo,
            @RequestParam String tranCode,
            HttpServletRequest req
    ) throws Exception {

        System.out.println("/purchase/updateTranCodeByProd : prodNo=" + prodNo + ", tranCode=" + tranCode);

        // 1) 배송상태 업데이트
        purchaseService.updateTranCodeByProd(prodNo, tranCode);

        // 2) 들어온 쿼리스트링을 그대로 회수해서 목록으로 돌려보내기
        String qs = req.getQueryString(); 

        if (qs != null) {
            // prodNo, tranCode 제거 (앞/중간/뒤 모든 위치)
            qs = qs.replaceAll("(^|&)(prodNo|tranCode)=[^&]*", "")
                   .replaceAll("^&+", "")
                   .replaceAll("&+$", "")
                   .replaceAll("&&+", "&");
        }

        // 3) 목록으로 리다이렉션
        return "redirect:/product/listProduct" + (qs != null && !qs.isEmpty() ? "?" + qs : "");
    }
}
