package com.model2.mvc.service.domain;

import java.sql.Date;

public class Purchase {
	
	// Field
	private int tranNo;
	private Product purchaseProd;
	private User buyer;
	private String paymentOption;
	private String receiverName;
	private String receiverPhone;
	private String dlvyAddr;
	private String dlvyRequest;
	private String tranCode;
	private Date orderDate;
	private String dlvyDate;
	
	// Constructor
	public Purchase() {
	}
	
	// Getter & Setter
	public int getTranNo() {
		return tranNo;
	}
	
	public void setTranNo(int tranNo) {
		this.tranNo = tranNo;
	}
	
	public Product getPurchaseProd() {
		return purchaseProd;
	}
	
	public void setPurchaseProd(Product purchaseProd) {
		this.purchaseProd = purchaseProd;
	}
	
	public User getBuyer() {
		return buyer;
	}
	
	public void setBuyer(User buyer) {
		this.buyer = buyer;
	}
	
	public String getPaymentOption() {
		return paymentOption;
	}
	
	public void setPaymentOption(String paymentOption) {
		this.paymentOption = paymentOption;
	}
	
	public String getReceiverName() {
		return receiverName;
	}
	
	public void setReceiverName(String receiverName) {
		this.receiverName = receiverName;
	}
	
	public String getReceiverPhone() {
		return receiverPhone;
	}
	
	public void setReceiverPhone(String receiverPhone) {
		this.receiverPhone = receiverPhone;
	}
	
	public String getDlvyAddr() {
		return dlvyAddr;
	}
	
	public void setDlvyAddr(String dlvyAddr) {
		this.dlvyAddr = dlvyAddr;
	}
	
	public String getDlvyRequest() {
		return dlvyRequest;
	}
	
	public void setDlvyRequest(String dlvyRequest) {
		this.dlvyRequest = dlvyRequest;
	}
	
	public String getTranCode() {
		return tranCode;
	}
	
	public void setTranCode(String tranCode) {
		this.tranCode = tranCode;
	}
	
	public Date getOrderDate() {
		return orderDate;
	}
	
	public void setOrderDate(Date orderDate) {
		this.orderDate = orderDate;
	}
	
	public String getDlvyDate() {
		return dlvyDate;
	}
	
	public void setDlvyDate(String dlvyDate) {
		this.dlvyDate = dlvyDate;
	}
	
	// toString
	@Override
	public String toString() {
		return "Purchase [tranNo=" + tranNo 
				+ ", purchaseProd=" + purchaseProd 
				+ ", buyer=" + buyer 
				+ ", paymentOption=" + paymentOption 
				+ ", receiverName=" + receiverName 
				+ ", receiverPhone=" + receiverPhone 
				+ ", dlvyAddr=" + dlvyAddr 
				+ ", dlvyRequest=" + dlvyRequest 
				+ ", tranCode=" + tranCode 
				+ ", orderDate=" + orderDate 
				+ ", dlvyDate=" + dlvyDate + "]";
	}
}
