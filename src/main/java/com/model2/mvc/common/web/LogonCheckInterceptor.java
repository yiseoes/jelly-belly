package com.model2.mvc.common.web;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.model2.mvc.service.domain.User;

//======================== 추가, 변경된 부분  ==========================/
//==> Spring Boot 시 추가된 부분. : Spring Boot 3.x : Tomcat 10 사용
//======================== 추가, 변경된 부분  ==========================/
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LogonCheckInterceptor implements HandlerInterceptor {

	///Field
	
	///Constructor
	public LogonCheckInterceptor(){
		System.out.println("\nCommon :: "+this.getClass()+"\n");		
	}
	
	///Method
	public boolean preHandle(	HttpServletRequest request,
														HttpServletResponse response, 
														Object handler) throws Exception {
		
		System.out.println("\n[ LogonCheckInterceptor start........]");
		
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("user");

		String uri = request.getRequestURI();
		
		//==================== 로그인한 상태 ====================
		if( user != null )  {

			// 기존 차단 URI + 소셜 로그인/콜백도 로그인 상태에서 재진입 불필요
			if(		uri.indexOf("addUser") != -1 
				 || uri.indexOf("login") != -1 		
				 || uri.indexOf("checkDuplication") != -1
				 || uri.indexOf("/user/kakao") != -1
				 || uri.indexOf("/user/google") != -1
				 || uri.indexOf("/user/naver") != -1 ){
				
				request.getRequestDispatcher("/index.jsp").forward(request, response);
				System.out.println("[ 로그인 상태.. 로그인/소셜 관련 불필요 요구 차단 ] uri=" + uri);
				System.out.println("[ LogonCheckInterceptor end........]\n");
				return false;
			}
			
			System.out.println("[ 로그인 상태 허용 ] uri=" + uri);
			System.out.println("[ LogonCheckInterceptor end........]\n");
			return true;
			
		}else{ 
			//==================== 미 로그인 상태 ====================

			// 기존 로그인/회원가입/중복체크 + 소셜 로그인/콜백 허용
			if(		uri.indexOf("addUser") != -1 
				 || uri.indexOf("login") != -1 		
				 || uri.indexOf("checkDuplication") != -1
				 || uri.indexOf("/user/kakao") != -1
				 || uri.indexOf("/user/google") != -1
				 || uri.indexOf("/user/naver") != -1 ){
				
				System.out.println("[ 비로그인 : 인증/소셜 관련 허용 ] uri=" + uri);
				System.out.println("[ LogonCheckInterceptor end........]\n");
				return true;
			}
			
			request.getRequestDispatcher("/index.jsp").forward(request, response);
			System.out.println("[ 비로그인 : 보호자원 접근 차단 → index로 유도 ] uri=" + uri);
			System.out.println("[ LogonCheckInterceptor end........]\n");
			return false;
		}
	}
}
