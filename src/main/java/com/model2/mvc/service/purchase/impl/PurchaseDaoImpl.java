package com.model2.mvc.service.purchase.impl;

import java.util.List;
import java.util.Map;
import java.util.HashMap;   // ★ 추가

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.purchase.PurchaseDao;

@Repository("purchaseDaoImpl")
public class PurchaseDaoImpl implements PurchaseDao {
	
	// Field
	@Autowired
	private SqlSession sqlSession;
	
	public PurchaseDaoImpl() {
		System.out.println(this.getClass());
	}
	
	// 구매 등록
	@Override
	public void addPurchase(Purchase purchase) throws Exception {
		sqlSession.insert("PurchaseMapper.addPurchase", purchase);
	}
	
	// 구매 정보 조회
	@Override
	public Purchase findPurchase(int tranNo) throws Exception {
		return sqlSession.selectOne("PurchaseMapper.findPurchase", tranNo);
	}
	
	// 상품번호로 구매 정보 조회
	@Override
	public Purchase findPurchaseByProd(int prodNo) throws Exception {
		return sqlSession.selectOne("PurchaseMapper.findPurchaseByProd", prodNo);
	}
	
	// 구매 목록 조회
	@Override
	public List<Purchase> findPurchaseList(Map<String, Object> map) throws Exception {
		return sqlSession.selectList("PurchaseMapper.findPurchaseList", map);
	}
	
	// 👉👉 여기 빠져 있던 거 추가 👈👈
	@Override
	public void updatePurchase(Purchase vo) throws Exception {
		sqlSession.update("PurchaseMapper.updatePurchase", vo);
	}
	
	// 구매 내역 총 건수
	@Override
	public int getTotalCount(String buyerId) throws Exception {
		return sqlSession.selectOne("PurchaseMapper.getTotalCount", buyerId);
	}
	
	// 배송 상태 코드 업데이트
	@Override
	public void updateTranCode(Purchase purchase) throws Exception {

	    // Purchase → Map 으로 변환해서 Mapper 규칙(code, tranNo)에 맞추기
	    Map<String, Object> param = new HashMap<String, Object>();
	    param.put("tranNo", purchase.getTranNo());
	    param.put("code",  purchase.getTranCode());

	    sqlSession.update("PurchaseMapper.updateTranCode", param);
	}
	
	// 상품번호로 배송 상태 코드 업데이트
	@Override
	public void updateTranCodeByProd(Map<String, Object> map) throws Exception {
		sqlSession.update("PurchaseMapper.updateTranCodeByProd", map);
	}
}
