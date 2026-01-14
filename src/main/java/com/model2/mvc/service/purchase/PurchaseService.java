package com.model2.mvc.service.purchase;

import java.util.Map;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Purchase;

public interface PurchaseService {
	
	// 구매 등록
	public void addPurchase(Purchase purchase) throws Exception;
	
	// 구매 정보 조회
	public Purchase getPurchase(int tranNo) throws Exception;
	
	// 상품번호로 구매 정보 조회
	public Purchase getPurchaseByProd(int prodNo) throws Exception;
	
    void updatePurchase(Purchase vo) throws Exception;
	
	// 구매 목록 조회
	public Map<String, Object> getPurchaseList(Search search, String buyerId) throws Exception;
	
	// 배송 상태 코드 업데이트
	public void updateTranCode(Purchase purchase) throws Exception;
	
	// 상품번호로 배송 상태 코드 업데이트
	public void updateTranCodeByProd(int prodNo, String tranCode) throws Exception;
}
