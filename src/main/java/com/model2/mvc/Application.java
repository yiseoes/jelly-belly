/*
 * [Application.java (언니가 "마스터 스위치" 🕹️ ON!)]
 * - [치명적 버그 수정! 🐞]
 * - "@EnableTransactionManagement" (트랜잭션 마스터 스위치)가
 * - "완전히" 누락되어, ServiceImpl의 "@Transactional" 💖 이
 * - "전부" 무시되고 있었음! (이것 때문에 "커밋" 💖 이 안 됨!)
 *
 * - [추가!] import org.springframework.transaction.annotation.EnableTransactionManagement;
 * - [추가!] @EnableTransactionManagement 어노테이션
 */
package com.model2.mvc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
// [언니가 추가! 💖 (1/2)] "마스터 스위치" 🕹️ import!
import org.springframework.transaction.annotation.EnableTransactionManagement; 

// [언니가 추가! 💖 (2/2)] "마스터 스위치 ON!" ⚡
@EnableTransactionManagement 
@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

}