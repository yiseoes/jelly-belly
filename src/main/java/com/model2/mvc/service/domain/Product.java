package com.model2.mvc.service.domain;

import java.sql.Date;

public class Product {
	
	// Field
	private int prodNo;
	private String prodName;
	private String prodDetail;
	private String manufactureDay;
	private int price;
	private String imageFile;
	private Date regDate;
	private String proTranCode;
	
	// Constructor
	public Product() {
	}
	
	// Getter & Setter
	public int getProdNo() {
		return prodNo;
	}
	
	public void setProdNo(int prodNo) {
		this.prodNo = prodNo;
	}
	
	public String getProdName() {
		return prodName;
	}
	
	public void setProdName(String prodName) {
		this.prodName = prodName;
	}
	
	public String getProdDetail() {
		return prodDetail;
	}
	
	public void setProdDetail(String prodDetail) {
		this.prodDetail = prodDetail;
	}
	
	public String getManufactureDay() {
		return manufactureDay;
	}
	
	public void setManufactureDay(String manufactureDay) {
		this.manufactureDay = manufactureDay;
	}
	
	public int getPrice() {
		return price;
	}
	
	public void setPrice(int price) {
		this.price = price;
	}
	
	public String getImageFile() {
		return imageFile;
	}
	
	public void setImageFile(String imageFile) {
		this.imageFile = imageFile;
	}
	
	public Date getRegDate() {
		return regDate;
	}
	
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	
	public String getProTranCode() {
		return proTranCode;
	}
	
	public void setProTranCode(String proTranCode) {
		this.proTranCode = proTranCode;
	}
	
	// toString
	@Override
	public String toString() {
		return "Product [prodNo=" + prodNo + ", prodName=" + prodName 
				+ ", prodDetail=" + prodDetail + ", manufactureDay=" + manufactureDay 
				+ ", price=" + price + ", imageFile=" + imageFile 
				+ ", regDate=" + regDate + ", proTranCode=" + proTranCode + "]";
	}
}
