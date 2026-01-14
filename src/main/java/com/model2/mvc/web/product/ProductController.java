/*
 * [ProductController.java (언니가 "꼼수" 제거! 🧹)]
 * - [수정!] "엔진 예열" 꼼수 🚗💨 (warmup) 메소드 "완전 삭제!"
 * - (이유: ServiceImpl에 @Transactional을 추가해서 "진짜" 원인을 해결!)
 * - [수정!] main() 메소드도 원래의 깨끗한 💖 상태로 복원!
 */
package com.model2.mvc.web.product;

import java.io.File;
import java.util.Map;
import java.util.List; 

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;


@Controller
@RequestMapping("/product/*")
public class ProductController {
	//이서이서
	// Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	@Value("${pageUnit}")
	int pageUnit;
	
	@Value("${pageSize}")
	int pageSize;
	
	public ProductController() {
		System.out.println(this.getClass());
	}
	
	// 상품 등록 폼
	@RequestMapping(value="addProduct", method=RequestMethod.GET)
	public String addProduct() throws Exception {
		System.out.println("/product/addProduct : GET");
		return "redirect:/product/addProductView.jsp";
	}
	
	// 상품 등록 처리
	@RequestMapping(value="addProduct", method=RequestMethod.POST)
	public String addProduct(@ModelAttribute("product") Product product,
							 @RequestParam(value="fName", required=false) MultipartFile file) throws Exception {
		System.out.println("/product/addProduct : POST");
		
		// 파일 업로드 처리
		if (file != null && !file.isEmpty()) {
			String fileName = file.getOriginalFilename();
			
			// 프로젝트 루트 경로 가져오기
			String projectPath = System.getProperty("user.dir");
			String uploadPath = projectPath + "/src/main/resources/static/images/uploadFiles/";
			
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			
			File uploadFile = new File(uploadPath + fileName);
			file.transferTo(uploadFile);
			
			product.setImageFile(fileName);
		}
		
		// Business Logic
		productService.addProduct(product);
		
		// 등록된 상품의 상세 페이지로 이동
		return "redirect:/product/getProduct?prodNo=" + product.getProdNo();
	}
	
	// 상품 상세 조회
	@RequestMapping(value="getProduct", method=RequestMethod.GET)
	public String getProduct(@RequestParam("prodNo") int prodNo, Model model) throws Exception {
	    System.out.println("/product/getProduct : GET");
	    
	    // Business Logic
	    Product product = productService.getProduct(prodNo);
	    model.addAttribute("product", product);

	    // ==== 관리자 여부 판단 (listProduct랑 동일 로직) ====
	    boolean isAdmin = false;
	    try {
	        ServletRequestAttributes attrs =
	            (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
	        HttpServletRequest request = attrs.getRequest();
	        HttpSession session = request.getSession(false);

	        if (session != null) {
	            User user = (User) session.getAttribute("user");
	            if (user != null && "admin".equals(user.getRole())) {
	                isAdmin = true;
	            }
	        }
	    } catch (IllegalStateException e) {
	        // web context 아닐 때는 무시
	    }

	    model.addAttribute("isAdmin", isAdmin);

	    return "forward:/product/getProduct.jsp";
	}
	
	// 상품 수정 폼
	@RequestMapping(value="updateProduct", method=RequestMethod.GET)
	public String updateProduct(@RequestParam("prodNo") int prodNo, Model model) throws Exception {
		System.out.println("/product/updateProduct : GET");
		
		// Business Logic
		Product product = productService.getProduct(prodNo);
		
		// Model에 담기
		model.addAttribute("product", product);
		
		return "forward:/product/updateProduct.jsp";
	}
	
	// 상품 수정 처리
	@RequestMapping(value="updateProduct", method=RequestMethod.POST)
	public String updateProduct(@ModelAttribute("product") Product product,
								@RequestParam(value="fName", required=false) MultipartFile file) throws Exception {
		System.out.println("/product/updateProduct : POST");
		
		// 파일 업로드 처리
		if (file != null && !file.isEmpty()) {
			String fileName = file.getOriginalFilename();
			
			// 프로젝트 루트 경로 가져오기
			String projectPath = System.getProperty("user.dir");
			String uploadPath = projectPath + "/src/main/resources/static/images/uploadFiles/";
			
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			
			File uploadFile = new File(uploadPath + fileName);
			file.transferTo(uploadFile);
			
			product.setImageFile(fileName);
		}
		
		// Business Logic
		productService.updateProduct(product);
		
		return "redirect:/product/getProduct?prodNo=" + product.getProdNo();
	}
	
	// 상품 목록 조회
	@RequestMapping(value="listProduct")
	public String listProduct(@ModelAttribute("search") Search search, 
							  Model model, 
							  HttpSession session) throws Exception {
		System.out.println("/product/listProduct");
		
		if (search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		
		// Business Logic
		Map<String, Object> map = productService.getProductList(search);
		
		Page resultPage = new Page(search.getCurrentPage(), 
								   ((Integer)map.get("totalCount")).intValue(), 
								   pageUnit, pageSize);
		
		// Model에 담기
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		
		// 관리자 여부 확인
		User user = (User) session.getAttribute("user");
		boolean isAdmin = (user != null && "admin".equals(user.getRole()));
		model.addAttribute("isAdmin", isAdmin);
		
		return "forward:/product/listProduct.jsp";
	}

	// ==========================================================
	// [언니가 "꼼수" 🚗💨 (warmup) "완전 삭제!" 🧹]
	// ==========================================================
	
	// ==========================================================
	// [언니가 "원래대로 복원!" 💖] "아노에틱" 메인 페이지 (BEST/NEW)
	// ==========================================================
	@RequestMapping(value="main")
	public String main(Model model) throws Exception {
		
		System.out.println("/product/main : GET (찐! 메인 페이지 로드! 🎁)");
		
		// (꼼수 "예열" 코드 싹! 제거!)
		
		// 1. "최근" 상품 4개 (New Arrival)
		List<Product> newList = productService.getNewProductList(4);
		
		// 2. "랜덤" 상품 4개 (Best Seller)
		List<Product> bestList = productService.getBestProductList(4);

		// 3. Model에 담아서 JSP로 쏴주기!
		model.addAttribute("newList", newList);
		model.addAttribute("bestList", bestList);
		
		System.out.println("[YISEO DEBUG] 💖 newList : " + (newList != null ? newList.size() + "개" : "null"));
		System.out.println("[YISEO DEBUG] 💖 bestList : " + (bestList != null ? bestList.size() + "개" : "null"));

		// "main.jsp"는 /webapp/main.jsp (루트)에 있으니까 "forward:"
		return "forward:/main.jsp";
	}
}