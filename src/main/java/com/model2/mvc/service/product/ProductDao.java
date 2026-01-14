/*
 * [ProductDao.java (언니가 수정! 💖)]
 * - import java.util.List;  (추가!)
 * - 맨 아래에 2개 메서드 "선언" (추가!)
 */
package com.model2.mvc.service.product;

import java.util.List; // [언니가 추가! 💖]

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;

public interface ProductDao {
	
	// 상품 등록
	public void addProduct(Product product) throws Exception;
	
	// 상품 조회
	public Product getProduct(int prodNo) throws Exception;
	
	// 상품 목록 조회
	public List<Product> getProductList(Search search) throws Exception;
	
	// 상품 수정
	public void updateProduct(Product product) throws Exception;
	
	// 상품 판매 상태 업데이트 (판매완료로)
	public void updateProTranCodeToSold(int prodNo) throws Exception;
	
	// 상품 판매 상태 업데이트 (판매중으로)
	public void updateProTranCodeToSale(int prodNo) throws Exception;
	
	// 상품 총 건수
	public int getTotalCount(Search search) throws Exception;

	// [언니가 추가! 💖] 메인화면용 "최근" 상품 N개
	public List<Product> getNewProductList(int limit) throws Exception;
	
	// [언니가 추가! 💖] 메인화면용 "랜덤" 상품 N개
	public List<Product> getBestProductList(int limit) throws Exception;
}