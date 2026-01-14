/*
 * [ProductDaoImpl.java (언니가 수정! 💖)]
 * - import java.util.List;  (추가!)
 * - 맨 아래에 2개 메서드 "구현" (추가!)
 */
package com.model2.mvc.service.product.impl;

import java.util.List; // [언니가 추가! 💖]

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductDao;

@Repository("productDaoImpl")
public class ProductDaoImpl implements ProductDao {
	
	// Field
	@Autowired
	private SqlSession sqlSession;
	
	public ProductDaoImpl() {
		System.out.println(this.getClass());
	}
	
	// 상품 등록
	@Override
	public void addProduct(Product product) throws Exception {
		sqlSession.insert("ProductMapper.addProduct", product);
	}
	
	// 상품 조회
	@Override
	public Product getProduct(int prodNo) throws Exception {
		return sqlSession.selectOne("ProductMapper.getProduct", prodNo);
	}
	
	// 상품 목록 조회
	@Override
	public List<Product> getProductList(Search search) throws Exception {
		return sqlSession.selectList("ProductMapper.getProductList", search);
	}
	
	// 상품 수정
	@Override
	public void updateProduct(Product product) throws Exception {
		sqlSession.update("ProductMapper.updateProduct", product);
	}
	
	// 상품 판매 상태 업데이트 (판매완료로)
	@Override
	public void updateProTranCodeToSold(int prodNo) throws Exception {
		sqlSession.update("ProductMapper.updateProTranCodeToSold", prodNo);
	}
	
	// 상품 판매 상태 업데이트 (판매중으로)
	@Override
	public void updateProTranCodeToSale(int prodNo) throws Exception {
		sqlSession.update("ProductMapper.updateProTranCodeToSale", prodNo);
	}
	
	// 상품 총 건수
	@Override
	public int getTotalCount(Search search) throws Exception {
		return sqlSession.selectOne("ProductMapper.getTotalCount", search);
	}

	// [언니가 추가! 💖] 메인화면용 "최근" 상품 N개 (SQL 호출!)
	@Override
	public List<Product> getNewProductList(int limit) throws Exception {
		return sqlSession.selectList("ProductMapper.getNewProductList", limit);
	}

	// [언니가 추가! 💖] 메인화면용 "랜덤" 상품 N개 (SQL 호출!)
	@Override
	public List<Product> getBestProductList(int limit) throws Exception {
		return sqlSession.selectList("ProductMapper.getBestProductList", limit);
	}
}