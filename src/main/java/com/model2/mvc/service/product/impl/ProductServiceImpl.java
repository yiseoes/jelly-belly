/*
 * [ProductServiceImpl.java (언니가 "진짜" 원인 수정! 💖)]
 * - [치명적 버그 수정! 🐞]
 * - 모든 메소드에 "@Transactional" 어노테이션이 "전부" 누락되어 있었음!
 * - 이 때문에 addProduct()가 "커밋(Commit)" 💖 되지 않아,
 * - 다른 SELECT 문이 데이터를 읽지 못하는 "기묘한 유령" 👻 버그 발생!
 *
 * - [수정!] import org.springframework.transaction.annotation.Transactional; (추가!)
 * - [수정!] "쓰기" (add/update) 메소드 ➜ @Transactional (추가!)
 * - [수정!] "읽기" (get/list) 메소드 ➜ @Transactional(readOnly = true) (추가!)
 */
package com.model2.mvc.service.product.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // [언니가 추가! 💖]

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductDao;
import com.model2.mvc.service.product.ProductService;

@Service("productServiceImpl")
public class ProductServiceImpl implements ProductService {
	
	// Field
	@Autowired
	@Qualifier("productDaoImpl")
	private ProductDao productDao;
	
	public ProductServiceImpl() {
		System.out.println(this.getClass());
	}
	
	// 상품 등록
	@Override
	@Transactional // [언니가 추가! 💖] "커밋"을 위한 필수!
	public void addProduct(Product product) throws Exception {
		productDao.addProduct(product);
	}
	
	// 상품 조회
	@Override
	@Transactional(readOnly = true) // [언니가 추가! 💖] (읽기 전용)
	public Product getProduct(int prodNo) throws Exception {
		return productDao.getProduct(prodNo);
	}
	
	// 상품 목록 조회
	@Override
	@Transactional(readOnly = true) // [언니가 추가! 💖] (읽기 전용)
	public Map<String, Object> getProductList(Search search) throws Exception {
		List<Product> list = productDao.getProductList(search);
		int totalCount = productDao.getTotalCount(search);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		map.put("totalCount", Integer.valueOf(totalCount));
		
		return map;
	}
	
	// 상품 수정
	@Override
	@Transactional // [언니가 추가! 💖] "커밋"을 위한 필수!
	public void updateProduct(Product product) throws Exception {
		productDao.updateProduct(product);
	}
	
	// 상품 판매 상태 업데이트 (판매완료로)
	@Override
	@Transactional // [언니가 추가! 💖] "커밋"을 위한 필수!
	public void updateProTranCodeToSold(int prodNo) throws Exception {
		productDao.updateProTranCodeToSold(prodNo);
	}
	
	// 상품 판매 상태 업데이트 (판매중으로)
	@Override
	@Transactional // [언니가 추가! 💖] "커밋"을 위한 필수!
	public void updateProTranCodeToSale(int prodNo) throws Exception {
		productDao.updateProTranCodeToSale(prodNo);
	}

	// [언니가 추가! 💖] 메인화면용 "최근" 상품 N개 (DAO한테 토스!)
	@Override
	@Transactional(readOnly = true) // [언니가 추가! 💖] (읽기 전용)
	public List<Product> getNewProductList(int limit) throws Exception {
		return productDao.getNewProductList(limit);
	}

	// [언니가 추가! 💖] 메인화면용 "랜덤" 상품 N개 (DAO한테 토스!)
	@Override
	@Transactional(readOnly = true) // [언니가 추가! 💖] (읽기 전용)
	public List<Product> getBestProductList(int limit) throws Exception {
		return productDao.getBestProductList(limit);
	}
}