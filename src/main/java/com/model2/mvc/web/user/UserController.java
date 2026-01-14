/*
 * [UserController.java (언니가 "꼼수" 제거! 🧹)]
 * - [수정!] 일반/소셜 로그인 성공 시, "redirect:/product/warmup" 였던 것을
 * -> "redirect:/product/main" 으로 "전부" 복원!
 * (이유: ServiceImpl에 @Transactional을 추가해서 "진짜" 원인을 해결!)
 */
package com.model2.mvc.web.user;

import java.util.Map;

//======================== 추가, 변경된 부분  ==========================/
//==> Spring Boot 시 추가된 부분. : Spring Boot 3.x : Tomcat 10 사용
//======================== 추가, 변경된 부분  ==========================/
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.user.UserService;

//======================== 추가, 변경된 부분  ==========================/
//==> Spring Boot 시 추가된 부분. : Spring Boot 3.x : Tomcat 10 사용
//======================== 추가, 변경된 부분  ==========================/
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;

// ===== 소셜 로그인용 import =====
import java.util.UUID;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import com.fasterxml.jackson.databind.ObjectMapper;

//==> 회원관리 Controller
@Controller
@RequestMapping("/user/*")
public class UserController {
	
	///Field
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	//setter Method 구현 않음
		
	public UserController(){
		System.out.println(this.getClass());
	}
	
	//======================== 추가, 변경된 부분  ==========================/
//	@Value("#{commonProperties['pageUnit']}")
//	int pageUnit;
//	@Value("#{commonProperties['pageSize']}")
//	int pageSize;

	@Value("${pageUnit}")
	int pageUnit;
	@Value("${pageSize}")
	int pageSize;
	
	
	@RequestMapping( value="addUser", method=RequestMethod.GET )
	public String addUser() throws Exception{
	
		System.out.println("/user/addUser : GET");
		
		return "redirect:/user/addUserView.jsp";
	}
	
	@RequestMapping( value="addUser", method=RequestMethod.POST )
	public String addUser( @ModelAttribute("user") User user ) throws Exception {

		System.out.println("/user/addUser : POST");
		//Business Logic
		userService.addUser(user);
		
		return "redirect:/user/loginView.jsp";
	}
	

	@RequestMapping( value="getUser", method=RequestMethod.GET )
	public String getUser( @RequestParam("userId") String userId , Model model ) throws Exception {
		
		System.out.println("/user/getUser : GET");
		//Business Logic
		User user = userService.getUser(userId);
		// Model 과 View 연결
		model.addAttribute("user", user);
		
		return "forward:/user/getUser.jsp";
	}
	

	@RequestMapping( value="updateUser", method=RequestMethod.GET )
	public String updateUser( @RequestParam("userId") String userId , Model model ) throws Exception{

		System.out.println("/user/updateUser : GET");
		//Business Logic
		User user = userService.getUser(userId);
		// Model 과 View 연결
		model.addAttribute("user", user);
		
		return "forward:/user/updateUser.jsp";
	}

	@RequestMapping( value="updateUser", method=RequestMethod.POST )
	public String updateUser( @ModelAttribute("user") User user , Model model , HttpSession session) throws Exception{

		System.out.println("/user/updateUser : POST");
		//Business Logic
		userService.updateUser(user);
		
		String sessionId=((User)session.getAttribute("user")).getUserId();
		if(sessionId.equals(user.getUserId())){
			session.setAttribute("user", user);
		}
		
		return "redirect:/user/getUser?userId="+user.getUserId();
	}
	
	
	@RequestMapping( value="login", method=RequestMethod.GET )
	public String login() throws Exception{
		
		System.out.println("/user/logon : GET");

		return "redirect:/user/loginView.jsp";
	}
	
	@RequestMapping( value="login", method=RequestMethod.POST )
	public String login(@ModelAttribute("user") User user , HttpSession session ) throws Exception{
		
		System.out.println("/user/login : POST");
		//Business Logic
		User dbUser=userService.getUser(user.getUserId());
		
		if( user.getPassword().equals(dbUser.getPassword())){
			session.setAttribute("user", dbUser);
		}
		
		// [언니가 수정! 💖] (1/4) "꼼수" 제거! 🧹 "진짜" 메인으로 슝! 🏠
		return "redirect:/product/main";
	}
		
	
	@RequestMapping( value="logout", method=RequestMethod.GET )
	public String logout(HttpSession session ) throws Exception{
		
		System.out.println("/user/logout : POST");
		
		session.invalidate();
		
		return "redirect:/index.jsp";
	}
	
	
	@RequestMapping( value="checkDuplication", method=RequestMethod.POST )
	public String checkDuplication( @RequestParam("userId") String userId , Model model ) throws Exception{
		
		System.out.println("/user/checkDuplication : POST");
		//Business Logic
		boolean result=userService.checkDuplication(userId);
		// Model 과 View 연결
		model.addAttribute("result", new Boolean(result));
		model.addAttribute("userId", userId);

		return "forward:/user/checkDuplication.jsp";
	}

	
	@RequestMapping( value="listUser" )
	public String listUser( @ModelAttribute("search") Search search , Model model ) throws Exception{
		
		System.out.println("/user/listUser : GET / POST");
		
		if(search.getCurrentPage() ==0 ){
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		
		// Business logic 수행
		Map<String , Object> map=userService.getUserList(search);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		// Model 과 View 연결
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		
		return "forward:/user/listUser.jsp";
	}

	// =================================================================
	// ▼▼▼▼▼▼▼▼ 소셜 로그인 관련 코드 (카카오 / 구글 / 네이버) ▼▼▼▼▼▼▼▼
	// =================================================================

	// ============================== 공통 유틸 ==============================
	private String buildBaseUrl(HttpServletRequest request) {
		// 예) http://localhost:8080/Model2MVCShop
		String scheme = request.getScheme();           // http or https
		String serverName = request.getServerName();  // localhost, 127.0.0.1 ...
		int serverPort = request.getServerPort();     // 8080 등
		String contextPath = request.getContextPath();// /Model2MVCShop

		StringBuilder sb = new StringBuilder();
		sb.append(scheme).append("://").append(serverName);
		if (!(scheme.equals("http") && serverPort == 80) &&
			!(scheme.equals("https") && serverPort == 443)) {
			sb.append(":").append(serverPort);
		}
		sb.append(contextPath);
		return sb.toString();
	}

	// ============================== 카카오 ==============================

	@RequestMapping(value = "kakao/callback", method = RequestMethod.GET)
	public String kakaoCallback(@RequestParam String code,
								HttpSession session,
								HttpServletRequest request) throws Exception {

	    System.out.println("[KAKAO][콜백] 인가코드 수신 완료 : code=" + code);

	    String accessToken = getKakaoAccessToken(code, request);
	    System.out.println("[KAKAO][콜백] 액세스 토큰 발급 성공 : accessToken(앞 12자리)=" 
	                        + (accessToken != null ? accessToken.substring(0, Math.min(12, accessToken.length())) + "..." : null));

	    Map<String, Object> userInfo = getKakaoUserInfo(accessToken);
	    System.out.println("[KAKAO][콜백] 사용자 정보 파싱 결과 : " + userInfo);

	    Object email = userInfo != null ? userInfo.get("email") : null;
	    Object id    = userInfo != null ? userInfo.get("id")    : null;
	    Object nick  = userInfo != null ? userInfo.get("nickname") : null;

	    String baseId = (email != null) ? String.valueOf(email).toLowerCase()
	                                    : "kakao_" + String.valueOf(id);

	    String userIdForLogin   = "k-" + baseId;
	    String userNameForLogin = (nick != null) ? String.valueOf(nick) : "KakaoUser";

	    System.out.println("[KAKAO][콜백] 로그인 식별자 선택 : userId=" + userIdForLogin + ", userName=" + userNameForLogin);
	    processSocialLogin(userIdForLogin, userNameForLogin, session);

	    System.out.println("[KAKAO][콜백] 소셜 로그인 처리 완료 → /product/main 리다이렉트");
	    
		// [언니가 수정! 💖] (2/4) "꼼수" 제거! 🧹 "진짜" 메인으로 슝! 🏠
		return "redirect:/product/main";
	}

	private String getKakaoAccessToken(String code, HttpServletRequest request) throws Exception {
	    System.out.println("[KAKAO][토큰] 교환 요청 시작");

	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

	    String base = buildBaseUrl(request);
	    String redirectUri = base + "/user/kakao/callback";

	    MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
	    params.add("grant_type", "authorization_code");
	    params.add("client_id", "YOUR_KAKAO_CLIENT_ID");  // TODO: 실제 카카오 REST API 키로 교체
	    params.add("redirect_uri", redirectUri);
	    params.add("code", code);

	    System.out.println("[KAKAO][토큰] 요청 파라미터 확인 : redirect_uri=" + redirectUri + ", code=" + code);

	    HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(params, headers);
	    RestTemplate restTemplate = new RestTemplate();

	    try {
	        ResponseEntity<String> response = restTemplate.exchange(
	                "https://kauth.kakao.com/oauth/token",
	                HttpMethod.POST, requestEntity, String.class);

	        System.out.println("[KAKAO][토큰] HTTP 상태코드=" + response.getStatusCode());
	        System.out.println("[KAKAO][토큰] 응답 바디=" + response.getBody());

	        Map<String, Object> jsonMap = new ObjectMapper().readValue(response.getBody(), Map.class);
	        String token = (String) jsonMap.get("access_token");
	        System.out.println("[KAKAO][토큰] 액세스 토큰 파싱 완료");
	        return token;

	    } catch (org.springframework.web.client.HttpClientErrorException e) {
	        System.out.println("[KAKAO][토큰][오류] HTTP 상태코드=" + e.getStatusCode());
	        System.out.println("[KAKAO][토큰][오류] 응답 바디=" + e.getResponseBodyAsString());
	        System.out.println("[KAKAO][토큰][가이드] KOE006/invalid_grant → redirect_uri 불일치, code 재사용/만료, 호스트(localhost/127.0.0.1) 점검");
	        throw e;
	    }
	}

	private Map<String, Object> getKakaoUserInfo(String accessToken) throws Exception {
	    System.out.println("[KAKAO][유저] 조회 요청 시작");

	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Authorization", "Bearer " + accessToken);
	    headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

	    HttpEntity<Void> requestEntity = new HttpEntity<>(headers);
	    RestTemplate restTemplate = new RestTemplate();

	    try {
	        ResponseEntity<String> response = restTemplate.exchange(
	                "https://kapi.kakao.com/v2/user/me",
	                HttpMethod.POST, requestEntity, String.class);

	        System.out.println("[KAKAO][유저] HTTP 상태코드=" + response.getStatusCode());
	        System.out.println("[KAKAO][유저] 응답 바디=" + response.getBody());

	        Map<String, Object> json = new ObjectMapper().readValue(response.getBody(), Map.class);
	        Map<String, Object> account = (Map<String, Object>) json.get("kakao_account");
	        Map<String, Object> profile = (account != null) ? (Map<String, Object>) account.get("profile") : null;

	        Map<String, Object> userInfo = new java.util.HashMap<>();
	        userInfo.put("id", json.get("id"));
	        userInfo.put("email", (account != null) ? account.get("email") : null);
	        userInfo.put("nickname", (profile != null) ? profile.get("nickname") : null);

	        System.out.println("[KAKAO][유저] 파싱 결과 요약 : id=" + userInfo.get("id") 
	                           + ", email=" + userInfo.get("email") 
	                           + ", nickname=" + userInfo.get("nickname"));
	        return userInfo;

	    } catch (org.springframework.web.client.HttpClientErrorException e) {
	        System.out.println("[KAKAO][유저][오류] HTTP 상태코드=" + e.getStatusCode());
	        System.out.println("[KAKAO][유저][오류] 응답 바디=" + e.getResponseBodyAsString());
	        System.out.println("[KAKAO][유저][가이드] 401/unauthorized → Authorization 헤더/토큰 유효성 확인");
	        throw e;
	    }
	}

	// ============================== 구글 ==============================

	@RequestMapping(value = "google/callback", method = RequestMethod.GET)
	public String googleCallback(@RequestParam String code,
	                             HttpSession session,
	                             HttpServletRequest request) throws Exception {

	    System.out.println("[GOOGLE][콜백] 인가코드 수신 : code=" + code);

	    String accessToken = getGoogleAccessToken(code, request);
	    System.out.println("[GOOGLE][콜백] 액세스 토큰 발급 성공(앞 12자리) = "
	            + (accessToken != null ? accessToken.substring(0, Math.min(12, accessToken.length())) + "..." : null));

	    Map<String, Object> userInfo = getGoogleUserInfo(accessToken);
	    System.out.println("[GOOGLE][콜백] 유저정보 = " + userInfo);
	    
	    if (userInfo != null && userInfo.get("email") != null) {
	        String baseId = String.valueOf(userInfo.get("email")).toLowerCase();
	        String userIdForLogin   = "g-" + baseId;
	        String userNameForLogin = String.valueOf(userInfo.getOrDefault("name", "GoogleUser"));
	        processSocialLogin(userIdForLogin, userNameForLogin, session);
	    } else {
	        System.out.println("[GOOGLE][콜백][경고] email 값이 없음 → 로그인 중단");
	    }

		// [언니가 수정! 💖] (3/4) "꼼수" 제거! 🧹 "진짜" 메인으로 슝! 🏠
	    return "redirect:/product/main";
	}

	private String getGoogleAccessToken(String code, HttpServletRequest request) throws Exception {
	    System.out.println("[GOOGLE][토큰] 교환 요청 시작");

	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

	    String base = buildBaseUrl(request);
	    String redirectUri = base + "/user/google/callback";

	    MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
	    params.add("grant_type", "authorization_code");
	    params.add("client_id", "YOUR_GOOGLE_CLIENT_ID");  // TODO: 실제 구글 클라이언트 ID로 교체
	    params.add("client_secret", "YOUR_GOOGLE_CLIENT_SECRET");  // TODO: 실제 구글 클라이언트 시크릿으로 교체
	    params.add("redirect_uri", redirectUri);
	    params.add("code", code);

	    HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(params, headers);
	    RestTemplate restTemplate = new RestTemplate();

	    try {
	        ResponseEntity<String> res = restTemplate.exchange(
	                "https://oauth2.googleapis.com/token", HttpMethod.POST, requestEntity, String.class);
	        System.out.println("[GOOGLE][토큰] HTTP=" + res.getStatusCode());
	        System.out.println("[GOOGLE][토큰] 응답=" + res.getBody());

	        Map<String, Object> json = new ObjectMapper().readValue(res.getBody(), Map.class);
	        return (String) json.get("access_token");
	    } catch (org.springframework.web.client.HttpClientErrorException e) {
	        System.out.println("[GOOGLE][토큰][오류] HTTP=" + e.getStatusCode());
	        System.out.println("[GOOGLE][토큰][오류] 바디=" + e.getResponseBodyAsString());
	        System.out.println("[GOOGLE][토큰][가이드] 400/invalid_grant → redirect_uri 불일치, code 재사용/만료, 테스트사용자 미등록 점검");
	        throw e;
	    }
	}

	private Map<String, Object> getGoogleUserInfo(String accessToken) throws Exception {
	    System.out.println("[GOOGLE][유저] 조회 요청 시작");

	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Authorization", "Bearer " + accessToken);
	    HttpEntity<Void> requestEntity = new HttpEntity<>(headers);
	    RestTemplate restTemplate = new RestTemplate();

	    try {
	        ResponseEntity<String> res = restTemplate.exchange(
	                "https://www.googleapis.com/oauth2/v2/userinfo", HttpMethod.GET, requestEntity, String.class);
	        System.out.println("[GOOGLE][유저] HTTP=" + res.getStatusCode());
	        System.out.println("[GOOGLE][유저] 응답=" + res.getBody());

	        return new ObjectMapper().readValue(res.getBody(), Map.class);
	    } catch (org.springframework.web.client.HttpClientErrorException e) {
	        System.out.println("[GOOGLE][유저][오류] HTTP=" + e.getStatusCode());
	        System.out.println("[GOOGLE][유저][오류] 바디=" + e.getResponseBodyAsString());
	        System.out.println("[GOOGLE][유저][가이드] 401/invalid_token → Authorization 헤더/토큰 만료 확인");
	        throw e;
	    }
	}

	// ============================== 네이버 ==============================

	// 인가요청 시작
	@RequestMapping(value = "naver/login", method = RequestMethod.GET)
	public String naverLogin(HttpSession session, HttpServletRequest request) throws Exception {
	    System.out.println("[NAVER][시작] 네이버 인가요청 준비");

	    String state = UUID.randomUUID().toString();
	    session.setAttribute("NAVER_STATE", state);
	    System.out.println("[NAVER][시작] 생성한 state=" + state);

	    String base = buildBaseUrl(request);
	    String redirectUri = base + "/user/naver/callback";

	    String clientId = "YOUR_NAVER_CLIENT_ID";  // TODO: 실제 네이버 클라이언트 ID로 교체

	    String authorize = "https://nid.naver.com/oauth2.0/authorize"
	            + "?response_type=code"
	            + "&client_id=" + URLEncoder.encode(clientId, StandardCharsets.UTF_8.name())
	            + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8.name())
	            + "&state=" + URLEncoder.encode(state, StandardCharsets.UTF_8.name())
	            + "&auth_type=reprompt";

	    System.out.println("[NAVER][시작] 리다이렉트 → " + authorize);
	    return "redirect:" + authorize;
	}

	// 콜백
	@RequestMapping(value = "naver/callback", method = RequestMethod.GET)
	public String naverCallback(@RequestParam String code,
	                            @RequestParam String state,
	                            HttpSession session,
	                            HttpServletRequest request) throws Exception {
	    System.out.println("[NAVER][콜백] 인가코드 수신 : code=" + code + ", state=" + state);

	    Object saved = session.getAttribute("NAVER_STATE");
	    if (saved == null || !state.equals(saved.toString())) {
	        System.out.println("[NAVER][콜백][오류] state 불일치 → 요청 위변조 가능성");
	        return "redirect:/index.jsp"; // (이건 에러상황이니까 index.jsp가 맞아! 💖)
	    }
	    System.out.println("[NAVER][콜백] state 검증 완료");

	    String accessToken = getNaverAccessToken(code, state, request);
	    System.out.println("[NAVER][콜백] 액세스 토큰 발급 성공(앞 12자리) = "
	            + (accessToken != null ? accessToken.substring(0, Math.min(12, accessToken.length())) + "..." : null));

	    Map<String, Object> userInfo = getNaverUserInfo(accessToken);
	    System.out.println("[NAVER][콜백] 사용자 정보 = " + userInfo);

	    Object email = userInfo.get("email");
	    Object id    = userInfo.get("id");
	    Object name  = userInfo.get("name");

	    String baseId = (email != null) ? String.valueOf(email).toLowerCase()
	                                    : "naver_" + String.valueOf(id);

	    String userIdForLogin   = "n-" + baseId;
	    String userNameForLogin = (name != null) ? String.valueOf(name) : "NaverUser";

	    System.out.println("[NAVER][콜백] 로그인 식별자 : userId=" + userIdForLogin + ", userName=" + userNameForLogin);
	    processSocialLogin(userIdForLogin, userNameForLogin, session);

	    System.out.println("[NAVER][콜백] 소셜 로그인 처리 완료 → /product/main");
	    
		// [언니가 수정! 💖] (4/4) "꼼수" 제거! 🧹 "진짜" 메인으로 슝! 🏠
		return "redirect:/product/main";
	}

	private String getNaverAccessToken(String code, String state, HttpServletRequest request) throws Exception {
	    System.out.println("[NAVER][토큰] 교환 요청 시작");

	    String url = "https://nid.naver.com/oauth2.0/token";
	    String clientId = "YOUR_NAVER_CLIENT_ID";  // TODO: 실제 네이버 클라이언트 ID로 교체
	    String clientSecret = "YOUR_NAVER_CLIENT_SECRET";  // TODO: 실제 네이버 클라이언트 시크릿으로 교체

	    String base = buildBaseUrl(request);
	    String redirectUri = base + "/user/naver/callback";

	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

	    MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
	    params.add("grant_type", "authorization_code");
	    params.add("client_id", clientId);
	    params.add("client_secret", clientSecret);
	    params.add("code", code);
	    params.add("state", state);
	    params.add("redirect_uri", redirectUri);

	    HttpEntity<MultiValueMap<String, String>> req = new HttpEntity<>(params, headers);
	    RestTemplate rt = new RestTemplate();

	    try {
	        ResponseEntity<String> res = rt.exchange(url, HttpMethod.POST, req, String.class);
	        System.out.println("[NAVER][토큰] HTTP=" + res.getStatusCode());
	        System.out.println("[NAVER][토큰] 응답=" + res.getBody());

	        Map<String, Object> map = new ObjectMapper().readValue(res.getBody(), Map.class);
	        return (String) map.get("access_token");
	    } catch (org.springframework.web.client.HttpClientErrorException e) {
	        System.out.println("[NAVER][토큰][오류] HTTP=" + e.getStatusCode());
	        System.out.println("[NAVER][토큰][오류] 바디=" + e.getResponseBodyAsString());
	        System.out.println("[NAVER][토큰][가이드] invalid_request/invalid_grant → redirect_uri 불일치, code 재사용/만료, state 누락/불일치");
	        throw e;
	    }
	}

	private Map<String, Object> getNaverUserInfo(String accessToken) throws Exception {
	    System.out.println("[NAVER][유저] 조회 요청 시작");

	    String url = "https://openapi.naver.com/v1/nid/me";

	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Authorization", "Bearer " + accessToken);

	    HttpEntity<Void> req = new HttpEntity<>(headers);
	    RestTemplate rt = new RestTemplate();

	    try {
	        ResponseEntity<String> res = rt.exchange(url, HttpMethod.GET, req, String.class);
	        System.out.println("[NAVER][유저] HTTP=" + res.getStatusCode());
	        System.out.println("[NAVER][유저] 응답=" + res.getBody());

	        Map<String, Object> map = new ObjectMapper().readValue(res.getBody(), Map.class);
	        Map<String, Object> resp = (Map<String, Object>) map.get("response");

	        java.util.HashMap<String, Object> user = new java.util.HashMap<>();
	        if (resp != null) {
	            user.put("id", resp.get("id"));
	            user.put("email", resp.get("email"));
	            user.put("name", resp.get("name"));
	            user.put("nickname", resp.get("nickname"));
	        }
	        System.out.println("[NAVER][유저] 파싱 결과 : " + user);
	        return user;

	    } catch (org.springframework.web.client.HttpClientErrorException e) {
	        System.out.println("[NAVER][유저][오류] HTTP=" + e.getStatusCode());
	        System.out.println("[NAVER][유저][오류] 바디=" + e.getResponseBodyAsString());
	        System.out.println("[NAVER][유저][가이드] 401/invalid_token → Authorization 헤더/토큰 만료 확인");
	        throw e;
	    }
	}

	// ============================== 공통 처리 ==============================

	private void processSocialLogin(String userId, String userName, HttpSession session) throws Exception {
	    System.out.println("[공통로그인] 시작 : userId=" + userId + ", userName=" + userName);

	    User existingUser = null;
	    try {
	        existingUser = userService.getUser(userId);
	        System.out.println("[공통로그인] 기존 회원 조회 결과 : " + (existingUser != null ? "존재" : "없음"));
	    } catch (Exception e) {
	        System.out.println("[공통로그인] 기존 회원 조회 중 예외 발생(신규로 간주) : " + e.getMessage());
	    }

	    if (existingUser != null) {
	        session.setAttribute("user", existingUser);
	        System.out.println("[공통로그인] 기존 회원 로그인 완료");
	    } else {
	        User newUser = new User();
	        newUser.setUserId(userId);
	        newUser.setUserName(userName);
	        newUser.setPassword("snslogin");
	        newUser.setRole("user");
	        userService.addUser(newUser);
	        session.setAttribute("user", newUser);
	        System.out.println("[공통로그인] 신규 가입 및 로그인 완료");
	    }
	}
}