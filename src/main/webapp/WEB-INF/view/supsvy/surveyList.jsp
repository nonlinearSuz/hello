<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>강의 목록</title>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
<script type="text/javascript">

	
	/*페이징 관련 변수*/
	 var pageSize = 5;
	 var pageBlockSize= 3 ;
	
	
	/*onload시 실행 함수*/
	$(function(){
	
		fn_proflist();
		
	});
	
	
	/** 버튼 이벤트 등록 */

	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {
				case 'btnSaveSvy' : /*설문조사  제출*/
					$("#action").val("I");	
					break;
			}
		});
	}
	
	
	//======================= my Code================
	/*[관리자] 강사 목록 조회 */
	function fn_proflist(pagenum){
		
		pagenum = pagenum || 1;
		
		
		var param = {
				    sname : $("#sname").val()
				  , pageSize : pageSize
				  , pageBlockSize : pageBlockSize
				  , pagenum : pagenum	
		}
		
		var profListCallback = function (rv){
			console.log(rv);
			
			$("#profTuples").empty().append(rv);
			
			var totalcnt =  $("#totalcnt").val();
			
			console.log("totalcnt : " + totalcnt);
			
			var paginationHtml = getPaginationHtml(pagenum, totalcnt, pageSize, pageBlockSize, 'fn_proflist');
			console.log("paginationHtml : " + paginationHtml);
			 
			$("#profPagination").empty().append( paginationHtml );
			
			$("#pageno").val(pagenum);
		
		}
			
		callAjax("/supsvy/surveyList.do", "post", "text", false, param, profListCallback);
		
	}
		
	/*[관리자] 강사 목록중  하나의 리스트를 클릭 했을 때*/
	function fn_proflistclick(lec_prof){
		
	 	$("#prof_id").val(lec_prof);  
		fn_lecturelist();
		console.log('강사 id clickd!');
	}
	
	   /*[관리자] 강사별 강의 설문 현황 조회 */   
	   function fn_lecturelist(lecPageNo){
	      
	      lecPageNo = lecPageNo || 1;
	      
	      var param = {
	            prof_id : $("#prof_id").val()
	         ,   lecPageNo : lecPageNo
	         ,    pageSize : pageSize
			  , pageBlockSize : pageBlockSize		// 페이지 블록 단위
	         /* prof_id : $("#prof_id").val()  */
	      }
	      
	      
	      var profListCallBack = function(rtval){
	         console.log("rtval ===:"+ rtval);
	         
	         $("#lecTuples").empty().append(rtval);
	         
	         var totalcnt = $("#prof_totalcnt").val();
	         console.log("prof_totalcnt : " + totalcnt);
	         
	         var paginationHtml = getPaginationHtml(lecPageNo, totalcnt, pageSize, pageBlockSize, 'fn_lecturelist');
	         console.log("paginationHtml : " + paginationHtml);
	         console.log("pageBlockSize : " + pageBlockSize);
	          
	         $("#lecPagination").empty().append( paginationHtml );
	         
	         $("#lecPageNo").val(lecPageNo);
	         
	      }
	      
	      callAjax("/supsvy/surveyLectureList.do", "post", "text", true, param, profListCallBack);
	      
	   }
	
	/*[학생]설문대상 강의 목록중 하나를 클릭 했을 때 상세 정보 */
	function fn_onelecclick(lec_no){
		$("#lec_no").val(lec_no); 
		fn_lecdtinfo(lec_no);
		console.log('강의명 clickd!');
	 	/* $("#lec_no").val(lec_no);   */

	}
	
	/*[학생]설문대상 강의 목록중 하나를 클릭 했을 때 정보 나열 */
	 function fn_lecdtinfo(lec_no){

		var param = {
				lec_no : lec_no
			
		}

		var profListCallBack = function(rtval){
			
			/* console.log(JSON.stringify(rtval)); */
			console.log(JSON.stringify(rtval.lectureDetailedInfo));
			
			
			lecDtinfo(rtval.lectureDetailedInfo);
			
		}
		callAjax("/supsvy/surveyLectureDtInfo.do", "post", "json", false, param, profListCallBack);
	}
	
	 /*[학생]설문대상 강의 목록중 하나를 클릭 했을 때 정보 나열1 */
	function lecDtinfo(obj){
			console.log("lecture clicked!");
			if(obj == "" || obj == null || obj == undefined) {
				alert("강의 정보가 없습니다.");	
				
			} else {
				console.log("자세한 정보쪽으로 흘러옴~정보 있음~");
				
				$("#lec_name").text(obj.lec_name);	
				/* var k =$("#lec_name").val(obj.lec_name);	
				console.log(k); */
				$("#name").text(obj.name);
				$("#lec_start").text(obj.lec_start);
				$("#lec_end").text(obj.lec_end);
				$("#rm_name").text(obj.rm_name);
				$("#lec_contents").text(obj.lec_contents);
				$("#lec_goal").text(obj.lec_goal);

			}
		}
		
		/*[학생] 설문조사 모달 - 설문조사 내용을 만들어서 설문조사를 만들기.  */
		function fn_takeSurvey(lecno){
			
			console.log("+++설문조사 응시 버튼 클릭 +++");
			
			lecno = lecno || $("#lec_no").val();
			
			if(lecno != null && lecno != "") {
				$("#lec_no").val(lecno)
			}
			
			
			var param =  {
					lec_no : lecno
			};
			
			console.log(lecno);

			var svyListCallback = function(data) {
 				console.log(data);
 				
 				$("#surveyQ").empty().append(data);
 				//sv_no
			    var totalcnt = $("#totalcnt").val();
			    gfModalPop("#survey_modal");
			    console.log("fn_mkSuryvey 열일중~"); 
			} 
			
			console.log("111111111111111");
			callAjax("/supsvy/surveyFormat.do", "post", "text", false, param, svyListCallback);
		}
		
		
		
		/*[학생] 설문조사 응답 제출  */
		function fn_submitSurvey() {  
			
			console.log("설문조사 응답 제출");
			
			if(fn_svyValidation()){ // 전부다 작성. true
				
				if(confirm("제출하시겠습니까?")){
					$("#action").val("I");
					
					//alert($("#lec_no").val());
					
					$("#lec_no2").val($("#lec_no").val()); 
					
					var svySubmitRsCallBack = function (data){
						
						console.log("svySubmitRsCallBack 탐 !");
						console.log(JSON.stringify(data));
						
						if(data.result == "SUCCESS") {
							alert("제출이 완료되었습니다. ");
							gfCloseModal();
							fn_proflist();							
						} else {
							alert("제출중 에러입니다. ");
						}
						
						/* submitSvyRs(data); */

					}
					
					callAjax("/supsvy/surveySubmit.do","post","json",true,$("#frm_suveyModal").serialize(),svySubmitRsCallBack);
					
				}else{
					return;
				}
				
			}else { //미작성.
				//alert("모든 설문 문항에 답을 작성해주시기 바랍니다. ");
				return;
			}
			
			
			/* lecno = lecno || $("#lec_no").val();
			
			var param =  {
					lec_no : lecno
			}; */
			
			
			
		}
		
	
		function fn_svyValidation(){
			
			var qtotalcnt = $("#qtotalcnt").val();
			var qtype = $("#qtype").val();
			var qtypearr = qtype.split(",");			
			
			console.log(qtotalcnt + " : " + qtype);
			
			for(var i=0;i<qtotalcnt;i++) {
				var num = i + 1;
				if(qtypearr[i] == '1') {
					var answer1 = $('input[name=answer' + num + ']').val();
					//alert("주관식 : " + answer1) ;
					if(answer1 == null || answer1 == "") {
						alert( num+"번째 문항의 답변이 작성되지 않았습니다.");
						$("#answer" + num).focus();
						return false;
					}					
				} else {
					var answer2 = $(":input:radio[name=answer" + num + "]:checked").val();
					if(answer2 == null || answer2 == "") {
						alert( num+"번째 문항의 답변이 작성되지 않았습니다.");
						$("#answer" + num).focus();
						return false;
					}	
				}
			}
			
			return true;
			
		}
		
		/** 설문응답 validation */ 
		/* function fn_svyValidation2(){
			var returnval = true ; // validation 응답 최종 확인후 보낼 값. true를 returnval 에 저장. 
			var radioval;
			
		  	var svyResAnswer = $(":radio:nth-child(odd)");  
		  	console.log(svyResAnswer)// ?? 
		  	var chkcnt = 0;
		  	
		  	for (var i = 0; i< svyResAnswer.length; i++){
		  		var $this = $(svyResAnswer[i]);
		  		
		  		console.log( $(svyResAnswer[i]) + ":" + $this.is(":checked") + ":" + $this.attr('id') + ":" + $this); 
		  		
		  		if(!$this.is(":checked")){  //값 미선택
		  			alert( (i+1)+"번째 문항의 답변이 작성되지 않았습니다. ");
		  			$this.focus();
		  		    return false;			
		  		}else {
		  			chkcnt++;
		  		}
		  	}
		  	
		  	if(chckcnt = svyResAnswer.length){
		  		returnval = true;
		  	}else {
		  		returnval = false;
		  	}
		  	console.log(returnval);

		  	return returnval;
		}
		
		function submitSvyRs(data){
			if(data.result == "SUCCESS ") { 
				console.log(data.result);
				gfCloseModal();
				location.reload();
			}else{
				console.log(JSON.stringify(data));
				console.log(JSON.stringify(data.result));
				console.log(data.result)
				console.log("Hi");
				alert("설문 제출에 실패하였습니다. ");
			}
		}  */
		
		
		/* ====== 차트 ===== */
function fn_modalChart(lecNo, svySubmitcnt) {
   console.log("lecNo: " + lecNo);
   console.log("svySubmitcnt: " + svySubmitcnt);
   
   if (svySubmitcnt == 0) {
       alert("설문 참여자가 없습니다.");
       return;
    } 
   
   var param = {
      lecNo: lecNo
   };
	   
   var chartModelcallback = function(returndata) {         
      console.log(returndata);
      
      $("#surveyTotal").empty().append(returndata);
      gfModalPop("#surveyTotal");
      };
   
   callAjax("/supsvy/surveyChart.do", "post", "text", false, param, chartModelcallback);
}

		
		
</script>
</head>
<body>
	<!-- 관리자일때 -->
	<c:choose>
		<c:when test="${sessionScope.userType =='M'}">
			<form id="" action="" method="">
				<input type="hidden" id="action" name="action" />
				<input type="hidden" id="lec_no" name="lec_no"/>  
				<input type="hidden" id="prof_id" name="prof_id"/> 
				<input type="hidden" id="pageno"  name="pageno"  /> 
				<input type="hidden" id="lecPageno"  name="lecPageno"  /> 
				<input type="hidden" id="lecStatus"  name="lecStatus"  /> 
				
				<div id="mask"></div>
				
				<div id="wrap_area">
				
					<h2 class="hidden">header 영역</h2>
					<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>
	
					<h2 class="hidden">컨텐츠 영역</h2>
					<div id="container">
						<ul>
							<li class="lnb">
								<!-- lnb 영역 --> 
								<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> 
								<!--// lnb 영역 -->
							</li>
							<li class="contents">
								<!-- contents -->
								<h3 class="hidden">contents 영역</h3> <!-- content -->
								<div class="content">
			
									<p class="Location">
										<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
											class="btn_nav bold">운영</span> <span class="btn_nav bold">학습관리
											관리</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">설문조사 관리</a>
									</p>
			
									<p class="conTitle">
										<span>설문조사 관리</span> <span class="fr"> 
										<!-- <span style="font-weight:bold; margin-right:10px;">강 사 명</span> -->
										<select id="searchKey" name="searchKey" style="width: 150px;" >
												<option value="" >전체</option>
												<option value="prof_nm" >강사명</option>
										</select> 
										<input type="text" style="width: 300px; height: 25px;" id="sname" name="sname">
										<a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a>
										</span>
									</p>
									

									<div class="lectureList">
										<table class="col">
											<caption>caption</caption>
											<colgroup>
												<col width="20%">
												<col width="20%">
												<col width="20%">
												<col width="20%">
												<col width="20%">
											</colgroup>
				
											<thead>
												<tr>
													<th scope="col">강사 ID</th> 
													<th scope="col">강사명</th> 
													<th scope="col">강사 전화번호</th> 
													<th scope="col">강사 이메일</th> 
													<th scope="col">강의 등록일</th> 
												</tr>
											</thead>
											<tbody id="profTuples"></tbody>
										</table>
									</div>
				
									<div class="paging_area"  id="profPagination"> </div>
								 
								 
								 <p class="conTitle" style="margin-top: 30px;">
									<span>강의별 설문 현황</span> <span class="fr"> </span>
								</p>
									
								 	<div class="lectureList">
										<table class="col">
											<caption>caption</caption>
											<colgroup>
												<col width="20%">
												<col width="20%">
												<col width="20%">
												<col width="20%">
												<col width="20%">
											</colgroup>
				
											<thead>
												<tr>
													<th scope="col">강의명</th> 
													<th scope="col">강사명</th> 
													<th scope="col">강의 시작일</th> 
													<th scope="col">강사 종료일</th> 
													<th scope="col">설문 인원/수강 인원</th> 
												</tr>
											</thead>
											<tbody id="lecTuples"></tbody>
										</table>
									</div>
									<div class="paging_area"  id="lecPagination"> </div>
								 </div> 
								 
								 
								 
								<h3 class="hidden">풋터 영역</h3>
          						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
							</li>
						</ul>	
					</div>	
				</div>
				
			<!--  강의 상세계획서 모달 팝업 -->
			 <div id="lecDtModal" class="layerPop layerType2" style="width:800px;">
				<dl>
					<dt>
						<strong>강의 계획서 </strong>
					</dt>
					<dd class="content">
		
						<!-- s : 여기에 내용입력 -->
		
						<table class="row"  style="margin-top:30px;">
							<caption>caption</caption>
							<colgroup>
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">강의명 <span class="font_red">*</span></th>
									<td colspan="14"><input type="text" class="inputTxt p100" name="lec_name" id="lec_name" placeholder="강의명을 입력하세요."/></td>
								</tr>
								<tr>
									<th scope="row">시험 일자<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="lec_start" id="lec_start"/>
									</td>
									<th scope="row">시험 번호<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="lec_end" id="lec_end"/>
									</td>
								</tr>
								<tr>
									<th scope="row">시작 일자<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="lec_start" id="lec_start"/>
									</td>
									<th scope="row">종료 일자<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="lec_end" id="lec_end"/>
									</td>
								</tr>
								<tr>
									<th scope="row">시작 시간<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="lec_start" id="lec_start"/>
									</td>
									<th scope="row">종료 시간<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="lec_end" id="lec_end"/>
									</td>
								</tr>
								 <tr>
									<th scope="row">강사명<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="prof_name" id="prof_name" placeholder="숫자만 입력하세요."/>
									</td>
									<th scope="row">강의실<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="room_no" id="room_no" placeholder=""/>
									</td>
								</tr>
								<tr>
									<th scope="row">이메일<span class="font_red">*</span></th>
									<td colspan="5">
										<input type="text" class="inputTxt p100"  name="email" id="email" placeholder="이메일을 입력하세요. "/>
									</td>
									<th scope="row">연락처<span class="font_red">*</span></th>
									<td colspan="8">
										<input type="text" class="inputTxt p100"  name="phonenumber" id="phonenumber" placeholder="이메일을 입력하세요. "/>
									</td>
								</tr>
								<tr>
									<th scope="row">수업목표<span class="font_red">*</span></th>
									<td colspan="14">
									   <textarea id="lecgoal" name="lecgoal" cols="15" rows="3">
									   </textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">출석<span class="font_red">*</span></th>
									<td colspan="14">
									   <textarea id="attendance" name="attendance" cols="15" rows="2">
									   </textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">강의 계획 <span class="font_red">*</span></th>
									<td colspan="14" style="overflow:auto">
									 	<textarea id="lecPlanNote" name="lecPlanNote" cols="15" rows="3">
									   	</textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">첨부파일 <span class="font_red"></span></th>
									<td colspan="5">
									    <input  type="file" id="upfile"  name="upfile"  onchange="javascript:preview(event)" onclick="javascript:fn_console();"/>
									</td>
									<td colspan="8">
									      <div id="previewdiv" >미리보기</div>
									</td>
								</tr>
							</tbody>
						</table>
						<div class="" style="padding:30px 0px 5px 0px; display:flex; justify-content:center;">
							<a href="" class="btnType blue" id="btnSignIn" name="btn"><span>신청</span></a>
							<a style="margin-left:10px; margin-right:10px;" href="" class="btnType blue" id="btnSignWithdraw" name="btn"><span>취소</span></a>
							<a href="" class="btnType blue" id="btnClose" name="btn"><span>닫기</span></a>  
						</div>
					</dd>
				</dl>
				<a href="" class="closePop"><span class="hidden">닫기</span></a>
			</div> 
		<!--  강의 상세계획서 모달 팝업 --> 
		
			
      <!--  설문조사 통계 모달 팝업 (차트) -->
          <div id="surveyTotal" class="layerPop layerType2" style="width:800px;">
         </div>
		<!--  설문 통계 모달 팝업 --> 
			</form>
		</c:when>
	</c:choose>
	<!-- 학생 일때 -->
	<c:choose>
		<c:when test="${sessionScope.userType =='S'}">
			<form id="" action="" method="">
				<!-- <input type="hidden" id="action" name="action" /> -->
				<input type="hidden" id="lec_no" name="lec_no"/>
			<!-- 	<input type="hidden" id="prof_id" name="prof_id"/> -->
				<input type="hidden" id="pageno"  name="pageno"  /> 
				<input type="hidden" id="lecStatus"  name="lecStatus"  /> 
				
				<div id="mask"></div>
				
				<div id="wrap_area">
				
					<h2 class="hidden">header 영역</h2>
					<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>
	
					<h2 class="hidden">컨텐츠 영역</h2>
					<div id="container">
						<ul>
							<li class="lnb">
								<!-- lnb 영역 --> 
								<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> 
								<!--// lnb 영역 -->
							</li>
							<li class="contents">
								<!-- contents -->
								<h3 class="hidden">contents 영역</h3> <!-- content -->
								<div class="content">
			
									<p class="Location">
										<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
											class="btn_nav bold">운영</span> <span class="btn_nav bold">학습관리
											관리</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">설문조사</a>
									</p>
			
									<p class="conTitle">
										<span>설문조사</span> <span class="fr"> 
										<span style="font-weight:bold; margin-right:10px;">강 사 명</span>
										<!--  <select id="searchKey" name="searchKey" style="width: 150px;" >
												<option value="prof_nm" >강사명</option>
										</select>  -->
										<input type="text" style="width: 300px; height: 25px;" id="sname" name="sname">
										<a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a>
										</span>
									</p>
									
									<div class="lectureList">
										<table class="col">
											<caption>caption</caption>
											<colgroup>
												<col width="20%">
												<col width="20%">
												<col width="20%">
												<col width="20%">
												<col width="20%">
											</colgroup>
				
											<thead>
												<!-- <tr>
													<th scope="col">강의명 </th> 
													<th scope="col">강사명</th> 
													<th scope="col">강의 기간</th> 
													<th scope="col">진도</th> 
													<th scope="col">설문 응답</th> 
												</tr> -->
												<tr>
													<th scope="col">강의명</th> 
													<th scope="col">강사명</th> 
													<th scope="col">강사 연락처</th> 
													<th scope="col">강사 이메일</th> 
													<th scope="col">설문 응시</th> 
												</tr>
											</thead>
											<tbody id="profTuples"></tbody>
										</table>
									</div>
				
									<div class="paging_area"  id="profPagination" style="margin-bottom:40px;"> </div>
								 
								 
								 <!--  <p class="conTitle" style="margin-top: 30px;">
									<span>강의별 설문 현황</span> <span class="fr"> </span>
								</p> -->
							
									<div class="lecDtinfo" style="">
											 <table class="col">
									        <caption style="">
									          caption
									        </caption>
									        <colgroup class="col" width="30%"></colgroup>
									        <colgroup class="col" width="20%"></colgroup>
									        <colgroup class="col" width="20%"></colgroup>
									        <colgroup class="col" width="10%"></colgroup>
									       
									          <thead>
									            <tr>
									              <th scope="col">강의명</th>
									              <th scope="col">강사</th>
									              <th scope="col">강의 기간</th>
									              <th scope="col">강의실</th>
									            </tr>
									          </thead>
									          <tbody>
									            <td id="lec_name"></td>
									            <td id="name"></td>
									            <td id="">
									            	<span id="lec_start"></span>~
									            	<span id="lec_end"></span>
									            </td>
									            <td id="rm_name"></td>
									          </tbody>
									        </table>
									        
									        <table class="col">
									          <thead>
									          	<tr>
									            	<th style="text-align:left; padding-left:20px" scope="">강의 내용</th>
									            </tr>
									          </thead>
									          <tbody>
									          		<td id="lec_contents"></td>
									          </tbody>
									        </table>
									        
									        <table class="col">
									          <thead>
									            <tr>
									              <th style="text-align:left; padding-left:20px">강의목표</th>
									            </tr>
									          </thead>
									          <tbody>
									            <tr>
									              <td id="lec_goal"></td>
									            </tr>
									          </tbody>
									        </table>
									        <table class="col">
									          <thead>
									          <!--   <tr>
									              <th style="text-align:left; padding-left:20px">설문 응시 가능 여부</th>
									            </tr> -->
									          </thead>
									          <tbody>
									           <!--  <tr style="display:flex;">
									              <td style="dipslay:inlnie-block; width:100%; text-align:left; padding-left:20px ">설문응시가 가능합니다.<a style="float:right;"href="javascript:fn_takeSurvey(); " class="btnType blue"  id="takeSurvey" name="btn"><span>설문 응시</span></a></td>
									            </tr> -->
									          </tbody>
									        </table>						
								 </div> 
								 </div> <!-- //content -->	
								 
								 
								<h3 class="hidden">풋터 영역</h3>
          						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
							</li>
						</ul>	
					</div>	
				</div>
				
			<!--  강의 상세계획서 모달 팝업 -->
			 <div id="surveyModal" class="layerPop layerType2" style="width:800px;">
				<dl>
					<dt>
						<strong>강의 계획서 </strong>
					</dt>
					<dd class="content">
		
						<!-- s : 여기에 내용입력 -->
		
						<table class="row"  style="margin-top:30px;">
							<caption>caption</caption>
							<colgroup>
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">강의명 <span class="font_red">*</span></th>
									<td colspan="14"><input type="text" class="inputTxt p100" name="lec_name" id="lec_name" placeholder="강의명을 입력하세요."/></td>
								</tr>
								<tr>
									<th scope="row">시험 일자<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="lec_start" id="lec_start"/>
									</td>
									<th scope="row">시험 번호<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="lec_end" id="lec_end"/>
									</td>
								</tr>
								<tr>
									<th scope="row">시작 일자<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="lec_start" id="lec_start"/>
									</td>
									<th scope="row">종료 일자<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="lec_end" id="lec_end"/>
									</td>
								</tr>
								<tr>
									<th scope="row">시작 시간<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="lec_start" id="lec_start"/>
									</td>
									<th scope="row">종료 시간<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="lec_end" id="lec_end"/>
									</td>
								</tr>
								 <tr>
									<th scope="row">강사명<span class="font_red">*</span></th>
									<td colspan="5">
									    <input type="text" class="inputTxt p100"  name="prof_name" id="prof_name" placeholder="숫자만 입력하세요."/>
									</td>
									<th scope="row">강의실<span class="font_red">*</span></th>
									<td colspan="8">
									    <input type="text" class="inputTxt p100"  name="room_no" id="room_no" placeholder=""/>
									</td>
								</tr>
								<tr>
									<th scope="row">이메일<span class="font_red">*</span></th>
									<td colspan="5">
										<input type="text" class="inputTxt p100"  name="email" id="email" placeholder="이메일을 입력하세요. "/>
									</td>
									<th scope="row">연락처<span class="font_red">*</span></th>
									<td colspan="8">
										<input type="text" class="inputTxt p100"  name="phonenumber" id="phonenumber" placeholder="이메일을 입력하세요. "/>
									</td>
								</tr>
								<tr>
									<th scope="row">수업목표<span class="font_red">*</span></th>
									<td colspan="14">
									   <textarea id="lecgoal" name="lecgoal" cols="15" rows="3">
									   </textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">출석<span class="font_red">*</span></th>
									<td colspan="14">
									   <textarea id="attendance" name="attendance" cols="15" rows="2">
									   </textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">강의 계획 <span class="font_red">*</span></th>
									<td colspan="14" style="overflow:auto">
									 	<textarea id="lecPlanNote" name="lecPlanNote" cols="15" rows="3">
									   	</textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">첨부파일 <span class="font_red"></span></th>
									<td colspan="5">
									    <input  type="file" id="upfile"  name="upfile"  onchange="javascript:preview(event)" onclick="javascript:fn_console();"/>
									</td>
									<td colspan="8">
									      <div id="previewdiv" >미리보기</div>
									</td>
								</tr>
							</tbody>
						</table>
						<div class="" style="padding:30px 0px 5px 0px; display:flex; justify-content:center;">
							<a href="" class="btnType blue" id="btnSignIn" name="btn"><span>신청</span></a>
							<a style="margin-left:10px; margin-right:10px;" href="" class="btnType blue" id="btnSignWithdraw" name="btn"><span>취소</span></a>
							<a href="" class="btnType blue" id="btnClose" name="btn"><span>닫기</span></a>  
						</div>
					</dd>
				</dl>
				<a href="" class="closePop"><span class="hidden">닫기</span></a>
			</div> 
		<!--  강의 상세계획서 모달 팝업 --> 
		   </form>
		<!-- 모달팝업시작 -->
			<form id="frm_suveyModal">
			  <!-- <input type="hidden" id="pageNo"  value="1" name="pageNo"  />  -->
			  <input type="hidden" id="action" name="action" />
			  <input type="hidden" id="lec_no2" name="lec_no2" value="${lec_no}" /> 
			 
			  <div id="survey_modal" class="layerPop layerType2" style="width: 800px">
			    <dl>
			      <dt>
			        <strong>설문지</strong>
			      </dt>
			      <dd class="content">
			        <!-- s : 여기에 내용입력 -->
			        <div class="sidescroll" style="height: 700px; overflow: auto !important">
			        <p class="conTitle" style="background-color:darkgrey;" >
						<span style="color:black; padding-left:1rem;"> 설문조사</span>
						<!-- <div style="display:inline-block;">
							<span style="float:right; background-color:orange;" class="fr">응용SW 엔지니어 과정</span>
							<span style="float:right; background-color:orange;" class="fr">강의 기간 2023.06.29 ~ 2023.12.25</span>
							<span style="float:right; background-color:orange;" class="fr"> * 표시는 필수 질문입니다. </span>
						</div> -->
					</p>
			          <table class="row" id="">
			            <caption>caption</caption>
			            <tbody id="">
			              <!-- for문 -->
			            </tbody>
			          </table>
			          <!-- 마지막 문항 동적으로 마지막 문항임을 만들수 있는 방법...? -->
			         <table class="row" id="">
			            <caption>
			              caption
			            </caption>
			            <tbody id="surveyQ">
			            
			            </tbody>
			          </table> 
			        </div>
			        <!--  <div class="paging_area" id="Pagination_svy"></div> -->
			        <!-- e : 여기에 내용입력 -->
			        <div class="btn_areaC mt30">
			          <a  href="javascript:fn_submitSurvey();"  class="btnType blue" id="btnSaveSvy" name="btn" ><span>제출</span></a
			          >
			          <a href="" class="btnType gray" id="btnClose" name="btn"
			            ><span>닫기</span></a
			          >
			        </div>
			      </dd>
			    </dl>
			    <a href="" class="closePop"><span class="hidden">닫기</span></a>
			  </div>
			</form>
		<!-- 모달팝업끝 -->
				
		
				
				
				
		</c:when>
	</c:choose>
	

</body> 