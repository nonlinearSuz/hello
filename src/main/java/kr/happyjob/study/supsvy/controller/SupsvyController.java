package kr.happyjob.study.supsvy.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.supsvy.model.SurveyModel;
import kr.happyjob.study.supsvy.service.SupsvyService;


/*커밋 용 임시 주석*/

@Controller
@RequestMapping("/supsvy/")
public class SupsvyController {
   
	@Autowired
	SupsvyService supsvyService;
	
	//Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	//Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	/**
	 * 설문조사 
	 */
	@RequestMapping("survey.do")
	public String lecturePlan(Model model, @RequestParam Map<String,Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception{
		
		/*paramMap.put("my")*/
		
		logger.info("+ Start " + className + ".survey");
        logger.info("   - paramMap : " + paramMap);
      
        logger.info("+ End " + className + ".survey");
		
		
		return "supsvy/surveyList";
	}
	
	/** 설문 조사 화면 */
	@RequestMapping("surveyList.do")
	public String surveyList(Model model,@RequestParam Map<String,Object> paramMap,HttpServletRequest request,
			HttpServletResponse response,HttpSession session) throws Exception {
		
		 
		  
		  logger.info("+ Start " + className + ".surveyList");
	      logger.info("   - paramMap : " + paramMap);
	      logger.info("★★★★★★★★★현재 접속한 사람의 유저타입 : "+ session.getAttribute("userType")); // T: 강사 || S: 학생 || M :관리자
	      
	      
	      /**공통 페이징 처리 */
	      int pagenum = Integer.parseInt((String) paramMap.get("pagenum"));
	      int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
	      int pageindex = (pagenum - 1) * pageSize;
	      
	      paramMap.put("pageSize", pageSize);
	      paramMap.put("pageindex", pageindex);
	      
	      
	     /** 리턴 페이지 처리 */
	     String returnpage = "";
			
		 /**유저타입 세션에서 가져와서 선언 */
		 String userType = session.getAttribute("userType").toString();   
		
		 /** 로그인 아이디 세션에서 가져와서 선언 */
		 String loginID = (String) session.getAttribute("loginId");
		
			
		     if("S".equals(userType)){ // 학생일 경우
		    	  paramMap.put("loginID", loginID);
			    	 
			      logger.info(" ++++ 학생 입니다.++++");
			      List<SurveyModel> stusvyLecList = supsvyService.stusurveyLecList(paramMap);
			      int totalcnt = supsvyService.cntStusurveyLecList(paramMap);
			      
			      model.addAttribute("stusvyLecList", stusvyLecList);
			      model.addAttribute("totalcnt", totalcnt);
			      logger.info("+ totalcnt " + totalcnt + "개 가져옴~ " +".lectureStuList");
			      
			      returnpage = "supsvy/stusurveylectureListgrd";
			      
			      logger.info("+ 학생설문조사 " + returnpage +"url탐~");
			    	 
		      }else  { // "M" 관리자일경우
		    	  paramMap.put("loginID", loginID);
		    	  
		    	  logger.info(" ++++ 관리자 입니다.++++");
		    	  List<SurveyModel> totApprovedProfList = supsvyService.totProfList(paramMap);
			      int totalcnt = supsvyService.cntProfList(paramMap);
			      
			      model.addAttribute("totApprovedProfList", totApprovedProfList);
			      model.addAttribute("totalcnt", totalcnt);
			      logger.info("+ totalcnt " + totalcnt + "개 가져옴~ " +".lectureList");
		    	  
			      
			      returnpage = "supsvy/surveylectureListgrd";
		      }
		 
		  logger.info("+ End " + returnpage + ".returnpage");  
	      logger.info("+ End " + className + ".surveyListList");
	      
	      return returnpage;  
	}
	
	  /**[관리자] 설문조사 대상 강의 리스트  */ 
	  @RequestMapping("surveyLectureList.do")
	  	public String surveyLecturelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
	        HttpServletResponse response, HttpSession session) throws Exception {
	     
	     logger.info("+ Start " + className + ".surveyleclist");
	     logger.info("   - paramMap : " + paramMap);
	     
	     int pagenum = Integer.parseInt((String) paramMap.get("lecPageNo"));
	     int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));
	     int pageindex = (pagenum - 1) * pageSize;
	     
	     paramMap.put("pageSize", pageSize);
	     paramMap.put("pageindex", pageindex);
	     
	     // Controller  Service  Dao  SQL
	     List<SurveyModel> forowntotLecList = supsvyService.totLecList(paramMap);
	     
	     int totalcnt = supsvyService.cntLecList(paramMap);
	     System.out.println("totalcnt : " + totalcnt);
	     
	     model.addAttribute("forowntotLecList", forowntotLecList);
	     model.addAttribute("totalcnt", totalcnt);
	     
	     
	     logger.info("+ End " + className + ".surveyleclist");

	     return "supsvy/surveylectureCheckListgrd";
	  }
	  
	  /**[학생] 설문조사 대상 강의 상세 정보  */ 
	  @RequestMapping("surveyLectureDtInfo.do")
	  @ResponseBody
	  	public Map<String, Object>surveylecturedtinfo(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
	        HttpServletResponse response, HttpSession session) throws Exception {
	     
		  logger.info("+★★★★★★★★  설 문 조 사  대상 강의 리스트  ★★★★★★★+");
		  String loginID = (String) session.getAttribute("loginId");
		  paramMap.put("loginID", loginID);
		  
		  
	     logger.info("+ Start " + className + ".survey_lec_dt_info");
	     logger.info("   - paramMap : " + paramMap);
	    
	     
	     // Controller  Service  Dao  SQL
	     SurveyModel lectureDetailedInfo = supsvyService.lecDtInfo(paramMap);
	     /*SurveyModel survey =*/ 
	     Map<String, Object> returnmap = new HashMap<String, Object>();
	     
	     returnmap.put("lectureDetailedInfo", lectureDetailedInfo);
	     
	     
	     logger.info("+++++" + lectureDetailedInfo + "+++++");
	     logger.info("+ End " + className + ".survey_lec_dt_info");


	     return  returnmap;
	     
	  }

	  /** 설문조사 형태 만들기 */
	  @RequestMapping("surveyFormat.do")
	  	public String surveyFormat(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
	        HttpServletResponse response, HttpSession session) throws Exception {
	     
	     logger.info("+ Start " + className + ".surveyFormat");
	     logger.info("   - paramMap : " + paramMap);     
	   
	     
	     // Controller  Service  Dao  SQL
	     List<SurveyModel> surveyListModel = supsvyService.svyQList(paramMap); // 설문 내용 조회 (설문 번호 리스트를 만들어서 하나의 설문을 만들고 그렇게 만들어진 1set의 설문들이 여러개 만들어져서 리스트가 됨. ) 
	     
	     String qtype = "";
	     int sv_no = 0;
	     
	     for(SurveyModel item : surveyListModel ) {   // 각각의 설문을 돌아가면서   
	    	 
	    	 Map<String, Object> exmap = new HashMap<String, Object>();  // map을 만들어서(예시번호의 세트를 만들 공간) 
	    	 exmap.put("sv_no", item.getSv_no());  // 설문지 번호를 담고. 
	    	 exmap.put("sv_qst_no", item.getSv_qst_no()); // 설문 번호를 담고
	    	 
	    	 sv_no = item.getSv_no();
	    	 
	    	 qtype += item.getQst_type() + ","; 
	    	 
	    	 List<SurveyModel> setExList = supsvyService.svyQsetExList(exmap); // 설문 예시 조회  - 설문예시들을 담은 정보를 설문 예시 모델로 리스트를 만듬. 
	    	 
	    	 item.setExList(setExList); // 각각의 설문안의 설문예시맵안에 해당 번호의 예시들을 담아줌. 
	     }
	     
	     int totalcnt = surveyListModel.size(); // 설문 모델의 갯수를 .size() 를 이용해 토탈 카운트(설문리스트갯수)  설정. 
	     
	     model.addAttribute("surveyFormList", surveyListModel); //각 설문에 뿌려질 하나의 설문지를 모델에 담음.
	     model.addAttribute("totalcnt", totalcnt);
	     model.addAttribute("qtype", qtype);
	     model.addAttribute("sv_no", sv_no);
	     
	       
	     logger.info("+ End " + className + ".surveyFormat");

	     return "supsvy/surveyMakeFormgrd";
	  }
	  
	  
	  /** 설문 조사 응답 값 입력   */
	  @RequestMapping("surveySubmit.do")
	  @ResponseBody
	  public Map<String, Object> surveySubmit(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
		        HttpServletResponse response, HttpSession session) throws Exception {
		     
		     logger.info("+ Start " + className + ".surveySubmit");
		     logger.info("+ ------- 설문 응답 ----------------- +");
		     logger.info("   - paramMap : " + paramMap);    
		     

		     // 응답 학생의 정보 저장 : std_id .
		     String std_id = (String) session.getAttribute("loginId");
		     
		     String action = (String) paramMap.get("action");
		     
		     // 질문 유형 
		     String qtype = (String) paramMap.get("qtype");
		     //질문의 유형을 한번에 저장하고 ,로 나누어 배열화 시킴
		     String[] qtypearr =  qtype.split(",");
		     
		     
		     paramMap.put("loginID", std_id);
		     logger.info("loginID : " + std_id);
		     
		     // 질문 전체 갯수
		     int qtotalcnt = Integer.parseInt((String) paramMap.get("qtotalcnt"));
		     
		     int submit = 0;
		     
		     for(int i=0;i<qtotalcnt;i++) {
		    	 String ans="answer" + String.valueOf(i+1); // 질문번호 sv_qst_no
		    	 String ansval= (String) paramMap.get(ans); // 질문 답 qtypearr res_short or res_long
		    	 String  sv_no = (String) paramMap.get("sv_no");
		    	  
		    	 
		    	 logger.info("------[♥]" + paramMap + "--------");
		    	 
		    	 logger.info("------" + qtypearr[i] + " -------- "  + ansval + " -------- " + " -------- "  + paramMap.get(ans) + " -------- ");
		    	 
		    	 paramMap.get("lec_no2");
		    	 
		    	 int qno =i+1 ;
		    	
		    	if("1".equals(qtypearr[i])) {
		    		
		    		 paramMap.put("sv_qst_no", qno);
		    		 paramMap.put("res_long", ansval);
		    		 paramMap.put("res_short", 0);
		    		 paramMap.put("qst_one", "qst_one");
		    		
		    	 } else {
		    		 paramMap.put("sv_qst_no", qno);
		    		 paramMap.put("res_long", "");
	    		     paramMap.put("res_short", paramMap.get(ans));
	    		     paramMap.put("qst_multi", "qst_multi");
	    		  
		    	 }

		    	 
		    	 logger.info(i + "   - ans : " + ans + "   - ansval : " + ansval + "   - qtypearr : " +  qtypearr[i]);  
		    	 logger.info("sv_no :"  + sv_no );
		    	 logger.info("????????????????"+ paramMap);
		     
		        submit = supsvyService.surveySubmit(paramMap); 
		        logger.info("submit :"  + submit );
		    	 
		     }
		     

		     Map<String, Object> svyResMap = new HashMap<String, Object>();
		     
		    
		     svyResMap.put("submit", submit);
		     
		     if(submit > 0) {
		    	 svyResMap.put("result", "SUCCESS");
		     } else {
		    	 svyResMap.put("result", "FAIL");
		     }
		     
		     logger.info("svyResMap : " +svyResMap);
		     
		     logger.info("+ End " + className + ".surveySubmit");

		     return svyResMap ;
		  }
	  
	
	  
	  
	  /** 설문조사 차트 데이터 조회 */
      @RequestMapping("surveyChart.do")
         public String surveyChart(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
            HttpServletResponse response, HttpSession session) throws Exception {
         
         logger.info("+ Start " + className + ".surveyFormat");
         logger.info("   - paramMap : " + paramMap);
         
         List<SurveyModel> surveyChartModel = supsvyService.surveyChartModel(paramMap); // 설문 내용 조회
         
         /* 설문조사 문항 목록 조회 */
        List<SurveyModel> exContentList = supsvyService.exContentList();
         
        model.addAttribute("exContentList", exContentList);
         
         model.addAttribute("surveyChartModel", surveyChartModel);

         logger.info("+ End " + className + ".surveyFormat");

         return "supsvy/surveyTotal";
      }
}