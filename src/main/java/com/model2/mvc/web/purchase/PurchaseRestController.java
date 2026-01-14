package com.model2.mvc.web.purchase;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.purchase.PurchaseService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/purchase")
public class PurchaseRestController {

    @Autowired
    @Qualifier("purchaseServiceImpl")
    private PurchaseService purchaseService;

    @Autowired
    @Qualifier("productServiceImpl")
    private ProductService productService;

    public PurchaseRestController() {
        System.out.println("==> [REST] PurchaseRestController 생성됨");
    }

    // 세션 로그인 사용자 조회(user / userVO 혼재 대응)
    private User resolveLoginUser(HttpSession session) {
        if (session == null) return null;
        Object obj = (session.getAttribute("user") != null)
                   ? session.getAttribute("user")
                   : session.getAttribute("userVO");
        if (obj instanceof User) {
            return (User)obj;
        }
        return null;
    }

    // 1) 구매 생성 : POST /purchase/json/addPurchase
    @PostMapping(
        value   = "/json/addPurchase",
        consumes= MediaType.APPLICATION_JSON_VALUE,
        produces= MediaType.APPLICATION_JSON_VALUE
    )
    public Map<String,Object> addPurchase(@RequestBody Map<String,Object> body,
                                          HttpSession session) throws Exception {

        Map<String,Object> res = new HashMap<String,Object>();
        System.out.println("[REST][구매등록] /purchase/json/addPurchase : " + body);

        User buyer = resolveLoginUser(session);
        if (buyer == null) {
            res.put("success", false);
            res.put("message", "로그인이 필요합니다.");
            return res;
        }

        Object prodNoObj = body.get("prodNo");
        if (prodNoObj == null) {
            res.put("success", false);
            res.put("message", "필수값 누락 : prodNo");
            return res;
        }
        int prodNo = Integer.parseInt(String.valueOf(prodNoObj));

        Purchase vo = new Purchase();
        vo.setBuyer(buyer);

        Product p = new Product();
        p.setProdNo(prodNo);
        vo.setPurchaseProd(p);

        Object paymentOption = body.get("paymentOption");
        Object receiverName  = body.get("receiverName");
        Object receiverPhone = body.get("receiverPhone");
        Object dlvyAddr      = body.get("dlvyAddr");
        Object dlvyRequest   = body.get("dlvyRequest");
        Object dlvyDate      = body.get("dlvyDate");

        if (paymentOption != null) vo.setPaymentOption(String.valueOf(paymentOption));
        if (receiverName  != null) vo.setReceiverName(String.valueOf(receiverName));
        if (receiverPhone != null) vo.setReceiverPhone(String.valueOf(receiverPhone));
        if (dlvyAddr      != null) vo.setDlvyAddr(String.valueOf(dlvyAddr));
        if (dlvyRequest   != null) vo.setDlvyRequest(String.valueOf(dlvyRequest));
        if (dlvyDate      != null) {
            String raw = String.valueOf(dlvyDate);
            vo.setDlvyDate(raw.replaceAll("-", ""));
        }

        vo.setTranCode("1");

        purchaseService.addPurchase(vo);

        try {
            productService.updateProTranCodeToSold(prodNo);
        } catch (Exception e) {
            System.out.println("[REST][WARN] updateProTranCodeToSold 실패 : " + e.getMessage());
        }

        res.put("success", true);
        res.put("tranNo", vo.getTranNo());
        return res;
    }

    // 2) 구매 단건 조회 : GET /purchase/json/getPurchase/{tranNo}
    @GetMapping(
        value   = "/json/getPurchase/{tranNo}",
        produces= MediaType.APPLICATION_JSON_VALUE
    )
    public Purchase getPurchase(@PathVariable int tranNo) throws Exception {
        System.out.println("[REST][상세] tranNo=" + tranNo);
        return purchaseService.getPurchase(tranNo);
    }

    // 3) 내 구매 목록 : POST /purchase/json/getPurchaseList
    @PostMapping(
        value   = "/json/getPurchaseList",
        consumes= MediaType.APPLICATION_JSON_VALUE,
        produces= MediaType.APPLICATION_JSON_VALUE
    )
    public Map<String,Object> getPurchaseList(@RequestBody Search search,
                                              HttpSession session) throws Exception {

        Map<String,Object> res = new HashMap<String,Object>();
        User login = resolveLoginUser(session);

        if (login == null) {
            res.put("success", false);
            res.put("message", "로그인이 필요합니다.");
            return res;
        }

        if (search == null) {
            search = new Search();
        }
        if (search.getCurrentPage() == 0) search.setCurrentPage(1);
        if (search.getPageSize() == 0)   search.setPageSize(5);

        String buyerId = login.getUserId();
        Map<String,Object> data = purchaseService.getPurchaseList(search, buyerId);

        res.put("success", true);
        res.putAll(data);
        res.put("currentPage", search.getCurrentPage());
        res.put("pageSize", search.getPageSize());
        return res;
    }

    // 4) 구매 수정 : POST /purchase/json/updatePurchase
    @PostMapping(
        value   = "/json/updatePurchase",
        consumes= MediaType.APPLICATION_JSON_VALUE,
        produces= MediaType.APPLICATION_JSON_VALUE
    )
    public Map<String,Object> updatePurchase(@RequestBody Map<String,Object> body) throws Exception {
        Map<String,Object> res = new HashMap<String,Object>();
        System.out.println("[REST][수정] updatePurchase : " + body);

        Object tranNoObj = body.get("tranNo");
        if (tranNoObj == null) {
            res.put("success", false);
            res.put("message", "필수값 누락 : tranNo");
            return res;
        }
        int tranNo = Integer.parseInt(String.valueOf(tranNoObj));

        Purchase vo = new Purchase();
        vo.setTranNo(tranNo);

        if (body.containsKey("paymentOption") && body.get("paymentOption") != null) {
            vo.setPaymentOption(String.valueOf(body.get("paymentOption")));
        }
        if (body.containsKey("receiverName") && body.get("receiverName") != null) {
            vo.setReceiverName(String.valueOf(body.get("receiverName")));
        }
        if (body.containsKey("receiverPhone") && body.get("receiverPhone") != null) {
            vo.setReceiverPhone(String.valueOf(body.get("receiverPhone")));
        }
        if (body.containsKey("dlvyAddr") && body.get("dlvyAddr") != null) {
            vo.setDlvyAddr(String.valueOf(body.get("dlvyAddr")));
        }
        if (body.containsKey("dlvyRequest")) {
            Object v = body.get("dlvyRequest");
            vo.setDlvyRequest(v == null ? null : String.valueOf(v));
        }
        if (body.containsKey("dlvyDate") && body.get("dlvyDate") != null) {
            String raw = String.valueOf(body.get("dlvyDate"));
            vo.setDlvyDate(raw.replaceAll("-", ""));
        }

        purchaseService.updatePurchase(vo);

        res.put("success", true);
        res.put("tranNo", tranNo);
        return res;
    }

    // 5) 배송상태코드 변경(단건) : POST /purchase/json/updateTranCode
    @PostMapping(
    	    value   = "/json/updateTranCode",
    	    produces= MediaType.APPLICATION_JSON_VALUE
    	)
    	public Map<String,Object> updateTranCode(@RequestParam("tranNo") int tranNo,
    	                                         @RequestParam("tranCode") String tranCode) throws Exception {

    	    Map<String,Object> res = new HashMap<String,Object>();

    	    Purchase vo = new Purchase();
    	    vo.setTranNo(tranNo);
    	    vo.setTranCode(tranCode);

    	    purchaseService.updateTranCode(vo);

    	    res.put("success", true);
    	    res.put("tranNo", tranNo);
    	    res.put("tranCode", tranCode);
    	    return res;
    	}


    // 6) 상품 기준 배송상태 일괄 변경 : POST /purchase/json/updateTranCodeByProd
    @PostMapping(
        value   = "/json/updateTranCodeByProd",
        produces= MediaType.APPLICATION_JSON_VALUE
    )
    public Map<String,Object> updateTranCodeByProd(@RequestParam("prodNo") int prodNo,
                                                   @RequestParam("tranCode") String tranCode) throws Exception {
        Map<String,Object> res = new HashMap<String,Object>();
        purchaseService.updateTranCodeByProd(prodNo, tranCode);
        res.put("success", true);
        res.put("prodNo", prodNo);
        res.put("tranCode", tranCode);
        return res;
    }
}
