package com.model2.mvc.service.purchase.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.purchase.PurchaseDao;
import com.model2.mvc.service.purchase.PurchaseService;

@Service("purchaseServiceImpl")
public class PurchaseServiceImpl implements PurchaseService {
	
	// Field
	@Autowired
	@Qualifier("purchaseDaoImpl")
	private PurchaseDao purchaseDao;
	
	public PurchaseServiceImpl() {
		System.out.println(this.getClass());
	}
	
	// 구매 등록
	@Override
	public void addPurchase(Purchase purchase) throws Exception {
		purchaseDao.addPurchase(purchase);
	}
	
	// 구매 정보 조회
	@Override
	public Purchase getPurchase(int tranNo) throws Exception {
		return purchaseDao.findPurchase(tranNo);
	}
	
	// 상품번호로 구매 정보 조회
	@Override
	public Purchase getPurchaseByProd(int prodNo) throws Exception {
		return purchaseDao.findPurchaseByProd(prodNo);
	}
	
	// 구매 목록 조회
	@Override
	public Map<String, Object> getPurchaseList(Search search, String buyerId) throws Exception {

	    // 기본값 보정은 컨트롤러에서 이미 했다고 가정 (currentPage, pageSize)

	    // 1) Search 에서 rownum 범위 계산
	    int startRowNum = search.getStartRowNum();
	    int endRowNum   = search.getEndRowNum();

	    // 2) MyBatis로 넘길 파라미터 Map 구성
	    Map<String, Object> paramMap = new HashMap<String, Object>();
	    paramMap.put("buyerId", buyerId);
	    paramMap.put("startRowNum", Integer.valueOf(startRowNum));
	    paramMap.put("endRowNum",   Integer.valueOf(endRowNum));

	    // 3) 목록 조회
	    List<Purchase> list = purchaseDao.findPurchaseList(paramMap);
	    int totalCount      = purchaseDao.getTotalCount(buyerId);

	    // 4) 컨트롤러에 돌려줄 map
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap.put("list",       list);
	    resultMap.put("totalCount", Integer.valueOf(totalCount));

	    return resultMap;
	}

	
	// 배송 상태 코드 업데이트
	@Override
	public void updateTranCode(Purchase purchase) throws Exception {
		purchaseDao.updateTranCode(purchase);
	}
	
	@Override
	public void updateTranCodeByProd(int prodNo, String tranCode) throws Exception {
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("prodNo", prodNo);
	    map.put("code",  tranCode);   // ★ Mapper 에 맞게 key 이름 "code"

	    purchaseDao.updateTranCodeByProd(map);
	}

	
    public void updatePurchase(Purchase vo) throws Exception {
        // ===================== 디버깅(한글) =====================
        System.out.println("[디버깅][SERVICE] updatePurchase 시작 :: "
                + "tranNo=" + (vo!=null ? vo.getTranNo() : 0)
                + ", 주소=" + (vo!=null ? vo.getDlvyAddr() : "null")
                + ", 요청사항=" + (vo!=null ? vo.getDlvyRequest() : "null")
                + ", 배송일(문자)=" + (vo!=null ? vo.getDlvyDate() : "null"));
        // ======================================================
        purchaseDao.updatePurchase(vo);
        // ===================== 디버깅(한글) =====================
        System.out.println("[디버깅][SERVICE] updatePurchase 종료");
        // ======================================================
    }
}
