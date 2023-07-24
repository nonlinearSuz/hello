<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>과제 관리</title>


<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<script>
///////////////////////////////////////////////////////////////////////

//페이징 설정(수업목록)
var pageSize2 = 4; //한페이지당 몇개씩 보여줄래
var pageBlockSize2= 4; //페이지번호갯수 몇개까지 보여줄래 (page navigation번호)

//페이징 설정 (과제관리)
var pageSize = 10; //한페이지당 몇개씩 보여줄래
var pageBlockSize= 5; //페이지번호갯수 몇개까지 보여줄래 (page navigation번호)

	// 상세코드 페이징 설정
	var pageSizeComnDtlCod = 5;
	var pageBlockSizeComnDtlCod = 10;
	
	/** OnLoad event */ //html만 뿌려놓은상태
	$(function() {
		// 버튼 이벤트 등록 :나중에 가져와라;; 검색버튼 누르면!
		fRegisterButtonClickEvent(); 
		fn_setSelectBox(); //과제목록 검색 selectbox
		fn_lectureList(); // 수업목록 자동생성
		//fn_noticeList();
		// ****검색을 누르면 나오게 해도된다. *** fn_assignmentList();
	
		
	});
	
	
	function fn_setSelectBox(){
		//이미 세션에 user_id가있음, user_id가 가르치는 lec_no, lec_name을 가져오면된다.
		//alert('실행 되었습니다.fn_setSelectBox 설정하기');
		
		var param = {}
		//넘길값도 없다?? 이미세션에 id가있음;
		var selectcallback = function(returnvalue){
			
			console.log('select함수 실행하고 컨트롤러에서 컬백받는 value :'+ returnvalue);

			//tbody 영역 
			$("#leclist").empty().append(returnvalue);	//처음 과제 검색할때 selectbox설정해주기
			$("#lecselect").empty().append(returnvalue); //과제올리기에서 과정명 뿌려주기
			
		}
		
		
		callAjax("/supass/selectList.do", "post", "text", false, param, selectcallback);
		

	}
	
	
	
	 function fn_lectureList(pageNum){ <!--수업목록-->
			
			pageNum = pageNum || 1; //undefined 이면 1값을 세팅해라.
						
			
			//alert('실행 되었습니다.fn_lectureList강의목록');
			

			
			var param = {
						
					 pageSize : pageSize2
				  , pageBlockSize : pageBlockSize2
				  , pageNum : pageNum
				}
		
			
			
			//callback 함수만들자. 함수형 변수  리턴받을 변수이름?
			var listcallback = function(returnvalue){
				//컨트롤러에서 리턴받는 데이터 (listgrd.jsp --> list.jsp)
				console.log('list함수 실행하고 컨트롤러에서 컬백받는 value :'+ returnvalue);
				
				$("#listlecture").empty().append(returnvalue); 
							//tbody 영역 
				
							
				var totalCnt = $("#lectotalCnt").val();
				console.log("totalCnt: "+ totalCnt);
		
							
						

						//function getPaginationHtml(currentPage, totalCount, pageRow, blockPage, pageFunc, exParams)
						
						
		//페이지 네비게이션 getPaginationHtml 공통함수
				var paginationHtml = getPaginationHtml(pageNum, totalCnt, pageSize2, pageBlockSize2, 'fn_lectureList');
				console.log("paginationHtml : " + paginationHtml);
				//swal(paginationHtml);
				$("#noticePagination2").empty().append( paginationHtml );
				
				$("#pageno").val(pageNum); //현재보고있는 currentpage = pagenum 
			}
			
			
			// jsp ~controller ajax communication
			
			callAjax("/supass/lecturelist.do", "post", "text", false, param, listcallback);
			
			
		}
	 
		/** 버튼 이벤트 등록 */
		function fRegisterButtonClickEvent() {
			$('a[name=btn]').click(function(e) { 
				e.preventDefault(); //전체페이지 reloading을 막기위해서.. a태그 href / from submit 버튼
	//event 클릭했을당시 js정보 e
				var btnId = $(this).attr('id');
				switch (btnId) {
					case 'btnSave' :
						fn_save();
						break;
					case 'btnSaveTask' :
						fn_saveTaskSend();
						break;
					case 'btnDelete' :
						$("#action").val("D");
						fn_save();
						break;
					case 'btnUpdateFile':
						$("#action").val("U");
						fn_savefile();
						break;	
					case 'btnDeleteFile':
						$("#action").val("D");
						fn_savefile();
						break;
					case 'btnDeleteTask':
						$("#action").val("D");
						fn_saveTaskSend();
						break;
					case 'btnSaveFile' :
						fn_savefile();
						break;
					case 'btnDeleteDtlCod' :
						fDeleteDtlCod();
						break;
					case 'btnSearch':
						fn_assignmentList();
						break;
					case 'btnSearch2':
						fn_assignmentStuList();						
						break;
					case 'btnClose' :
						
					case 'btnCloseFile' :
						gfCloseModal();
						break;
				}
			});
		}
	 
	 /*과제목록조회 (선생님)*/
	  function fn_assignmentList(pageNum, leclistnum){
			
			pageNum = pageNum || 1; //undefined 이면 1값을 세팅해라.
			leclistnum == leclistnum || $("#leclist").val();

			
			
			//alert('실행 되었습니다.fn_assignmentList 과제관리목록');			

			//alert('검색 optionvalue값: ' + $("#leclist").val()); //1
			var search_lec_no = $("#leclist").val();
			$("#lec_no").val(search_lec_no); //input type hidden값에 설정해둠 ==> 자료등록할때 같이 넘어가라고;
			

			
			var param = {
				// lecselect값에서도 넘어올수도있고, selectbox에서도넘어올수있음.
						lec_no : $("#leclist").val()				 
					, pageSize : pageSize
				  , pageBlockSize : pageBlockSize
				  , pageNum : pageNum
				}
		
			
			
			//callback 함수만들자. 함수형 변수  리턴받을 변수이름?
			var listcallback = function(returnvalue){
				//컨트롤러에서 리턴받는 데이터 (listgrd.jsp --> list.jsp)
				console.log('list함수 실행하고 컨트롤러에서 컬백받는 value :'+ returnvalue);
				
				//세션에 따라서...
				// append되는 아이디가 다름.
				// 검색되는 버튼 2개를 따로 만들어줘서 설정해도 되지만..
		
				var userType = '<%=(String)session.getAttribute("userType")%>';
				console.log('이사람의 userType = ' + userType);
				if (userType == "T"){
					$("#listassignmentTeacher").empty().append(returnvalue); 					
				} else {
					$("#listassignmentStudent").empty().append(returnvalue); 	
				} //일단 grd는 2개만들어야함. -> 그럼 컨트롤러도 2개여야하나??
						

				
							
				var totalCnt = $("#tasktotalCnt").val();
				console.log("totalCnt: "+ totalCnt);
				var currentLec_no = $("#lec_no").val();
				console.log("현재 강의넘버 : "+  currentLec_no);
							
						

					
						
				//페이지 네비게이션 getPaginationHtml 공통함수
				var paginationHtml = getPaginationHtml(pageNum, totalCnt, pageSize, pageBlockSize, 'fn_assignmentList');
				console.log("paginationHtml : " + paginationHtml);
				//swal(paginationHtml);
				$("#assignmentTeacherPagination").empty().append( paginationHtml ); //선생과 학생 2가지경우로 분리해줘야하나?
				
				
				$("#pageno").val(pageNum); //현재보고있는 currentpage = pagenum
			}
			
			
			// jsp ~controller ajax communication
			
			callAjax("/supass/assignmentTeacherlist.do", "post", "text", false, param, listcallback);
			
			
		}
	 
	 
	 
	 
	  /*과제목록조회 (학생)*/
	  function fn_assignmentStuList(pageNum){
			
			pageNum = pageNum || 1; //undefined 이면 1값을 세팅해라.
		//	leclistnum == leclistnum || $("#leclist").val();
		
			
			//  페이징 설정
			var pageSize = 10; //한페이지당 몇개씩 보여줄래
			var pageBlockSize= 5; //페이지번호갯수 몇개까지 보여줄래 (page navigation번호)
			//global변수랑 지역변수 헷갈리지말자.
			
			
		//	alert('실행 되었습니다.fn_assignmentList 학생의 경우 : 과제관리목록');
			
	
			//alert('검색 optionvalue값: ' + $("#leclist").val()); //1
			var search_lec_no = $("#leclist").val();
			$("#lec_no").val(search_lec_no); //input type hidden값에 설정해둠 ==> 자료등록할때 같이 넘어가라고;

			
			var param = {
					/* lec_no : $("#leclist").val() */		// lecselect값에서도 넘어올수도있고, selectbox에서도넘어올수있음.
						lec_no : $("#leclist").val()				 
						, pageSize : pageSize
					  , pageBlockSize : pageBlockSize
					  , pageNum : pageNum
				}
		
			
			
			//callback 함수만들자. 함수형 변수  리턴받을 변수이름?
			var listcallback = function(returnvalue){
				//컨트롤러에서 리턴받는 데이터 (listgrd.jsp --> list.jsp)
				console.log('list함수 실행하고 컨트롤러에서 컬백받는 value :'+ returnvalue);
				$("#listassignmentStudent").empty().append(returnvalue); 

				var totalCnt = $("#taskStu_totalCnt").val();
				console.log("totalCnt: "+ totalCnt);
				var currentLec_no = $("#lec_no").val();
				console.log("현재 강의넘버 : "+  currentLec_no); //returnvalue에 없음.. 찍히지않음..
							
					
						
				//페이지 네비게이션 getPaginationHtml 공통함수
				var paginationHtml = getPaginationHtml(pageNum, totalCnt, pageSize, pageBlockSize, 'fn_assignmentStuList');
				console.log("paginationHtml : " + paginationHtml);
				//swal(paginationHtml);
				$("#assignmentStudentPagination").empty().append( paginationHtml ); //선생과 학생 2가지경우로 분리해줘야하나?
				
				
				$("#pageno").val(pageNum); //현재보고있는 currentpage = pagenum
			}
	
			
			callAjax("/supass/assignmentStulist.do", "post", "text", false, param, listcallback);
			
			
		}	 
	 
	 
	
	 
	 
	 /*과제올리기 (선생님)*/
	 	function fn_openpopupfile(){
		
		popupinitfile();
		//모달팝업
		
		 gfModalPop("#layer2");
	}
		
	function popupinitfile(object) {
		
		
		if(object == "" || object == null || object == undefined) {
			$("#task_nm").val("");		//신규버튼 누를때 초기화
			$("#task_cont").val("");
			$("#task_no").val("");
			$("#upfile").val("");	
			$("#enr_date").val("");
			//$("#task_start").val("");
		//	$("#task_due").val("");
			$("#lecselect").val($("#leclist").val()); //내가 검색했던 과정에서 들어온것이다.
			$("#lecselect").removeAttr("disabled");
			
			
		       $('#task_start').datepicker('setDate', 'today');
		       $('#task_due').datepicker('setDate', '+1D');
			
			$("#previewdiv3").empty();// val("") 와의 차이
			
			$("#btnSaveFile").show(); //삭제버튼 숨김
			$("#btnUpdateFile").hide(); //삭제버튼 숨김
			$("#btnDeleteFile").hide(); //삭제버튼 숨김
			
			$("#action").val("I");	// action이라는 히든값 저장부를때 파라미터로 던진다.
		} else {
	
			 
			 
		 
	//	 alert("파일뿌려주기");
			console.log("파일뿌려주는 값: " + object);
			console.log( JSON.stringify(object) );
			
			$("#lecselect").val(object.lec_no);//과정명 select box설정해주기.
			$("#lecselect").attr("disabled",true);
			
			
			$("#task_nm").val(object.task_nm);		 //값이 들어오는 경우 수정버튼
			$("#task_cont").val(object.task_cont);
			$("#task_no").val(object.task_no); //?? 히든값설정?????????;;*************
			$("#lec_no").val(object.lec_no); //?? 히든값설정?
			$("#enr_date").val(object.enr_date);
			$("#task_start").val(object.task_start);
			$("#task_due").val(object.task_due);
			
			
			$("#upfile").val("");		//upfile? ** 다시 파일선택창 초기화??
			
					//=======
							var inserthtml = "<a href='javascript:fn_filedownload()'>";
				
				if(object.file_name == "" || object.file_name == null || object.file_name == undefined) {
					inserthtml += "";
				} else {
					var selfile = object.file_name;
				    var selfilearr = selfile.split(".");
				    var lastindex = selfilearr.length - 1; //파일명에 .이 들어간 경우를 고려
				    if(selfilearr[lastindex].toLowerCase() == "jpg" || selfilearr[lastindex].toLowerCase() == "gif" || selfilearr[lastindex].toLowerCase() == "jpge" || selfilearr[lastindex].toLowerCase() == "png") {
				    	  inserthtml += "<img src='" + object.file_logic_path + "' style='width:100px; height:80px' />";
				    } else {
				    	  inserthtml += object.file_name;
				    	  //이미지파일이 아니면 파일이름만 넣는다.
				    }				
				} 
				

				inserthtml += "</a>"
				
				$("#previewdiv3").empty().append(inserthtml); //미리보기
				
				$("#btnSaveFile").hide();
				$("#btnUpdateFile").show();
				$("#btnDeleteFile").show(); //삭제버튼을 보여주고
				
				$("#action").val("U");	 //업데이트형태로 간다.
				//------------					
					
		
		
		}
		
		
		
		
	   }
	
	
	
	 //미리보기
	 function preview3(event){
		 //dashboardMgr.jsp
		 var image = event.target; //change이미지바꿈. 타겟리턴 = file 태그자체를 리턴
		 
		 alert(image.files[0].name);
	

		 
		// //확장자가 찍히면된다.
		 
		 
		 if(image.files[0]){ //파일이 선택되었으면
			
			 //확장자 구하기
			 	var selfile = image.files[0].name;
			 	var selfilearr = selfile.split(".");
			 var inserthtml = "";
			 var lastindex = selfilearr.length -1; //파일명이 .이 들어간경우를 고려
			// alert(lastindex);
			 
			// alert(selfilearr[lastindex]); 
			 if(selfilearr[lastindex].toLowerCase() == "jpg" || selfilearr[lastindex].toLowerCase() == "gif" || selfilearr[lastindex].toLowerCase() =="png"){
				 //이경우는 이미지서비스이다.
				 inserthtml = "<img src='" + window.URL.createObjectURL(image.files[0]) + "'  style='width:100px; height:80px'/>"
					
			 } else{
				 //이미지파일이 아니면 파일 이름만 넣는다.
				 inserthtml = selfile;
			 }
			 
			 		 
			 
		//	 alert(window.URL.createObjectURL(image.files[0])); //window 브라우저 함수 파라미터로 파일넘겨주면 임시url을 만들어준다.
		 //	vuevar.inputtext = "asdf";
			 this.imgpath = window.URL.createObjectURL(image.files[0]);
			
		
			$("#previewdiv3").empty().append(inserthtml);
			
		 }
		 
		 
	 }
	 
	 
	 //********************제출일마감일 datepicker**************************//
	 $(function(){
		 $("#task_start").datepicker({
			/* 	 showOn:  'button'
					   , buttonImage: 'resources/images/icon2.png'  
					 , buttonImageOnly: true */
					 showOn: "both"
			    	   , buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
				    	    ,buttonImageOnly: true //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
				    	    ,buttonText: "선택" //버튼에 마우스 갖다 댔을 때 표시되는 텍스트      
		 });
		 $("#task_due").datepicker({
			 showOn: "both"
		    	   , buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
			    	    ,buttonImageOnly: true //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
			    	    ,buttonText: "선택" //버튼에 마우스 갖다 댔을 때 표시되는 텍스트      
		 });
		 
	     $('#task_start').datepicker("option", "maxDate", $("#task_due").val());
	       $('#task_start').datepicker("option", "onClose", function (selectedDate){
	           $("#task_due").datepicker( "option", "minDate", selectedDate );
	           });
	       
	  
	       $('#task_due').datepicker("option", "minDate", $("#task_start").val());
	       $('#task_due').datepicker("option", "onClose", function (selectedDate){
	           $("#task_start").datepicker( "option", "maxDate", selectedDate );
	          });  
	       
	       $('#task_start').datepicker('setDate', 'today');
	       $('#task_due').datepicker('setDate', '+1D');


	       $('img.ui-datepicker-trigger').attr('align', 'absmiddle');
	 })
	 
	 
	 //** 등록////
	 	 //등록
		function fn_savefile(){
			 if(!fn_Validate()){
				 return;
			 }
			 
			 let lecselect = $("#lecselect").val();
			 if(!lecselect){
				 alert("과정명을 선택해주세요.!!!!!!!");
				 $("#lecselect").focus();
				 return false;
			 }
			 
			 
			 //form Data
			 //파일업로드
			 //기존 파라미터..serialize나 param정의해서 사용
			 //파일에 대한 정보는 넘어가지않음.
			 //callajax
			 
			 var frm = document.getElementById("myForm");
			 frm.enctype = 'multipart/form-data';
			 var fileData = new FormData(frm); //파일정보까지 둘둘말아 던진다.
			 console.log(fileData);
			 
			 //콜백함수정의
			 var filesavecallback = function (returnval){
					 //반환값이 json
					console.log(JSON.stringify(returnval));
					 
					if(returnval.returnVal > 0) {
						alert("저장 되었습니다.");
						gfCloseModal();
						
						if($("#action").val() == "U") {
							fn_assignmentList($("#pageno").val(),$("#leclist").val());
						} else {
							fn_assignmentList();
						}
					}  else {
						alert("오류가 발생 되었습니다.");				
					}
					 
			 }
			 
			 
			 
			callAjaxFileUploadSetFormData("/supass/assignTeacherSaveFile.do", "post", "json", true, fileData, filesavecallback);

		 }
	 
	 function fn_Validate() {

			var chk = checkNotEmpty(
					[		
					 		[	"lecselect" , "과정명을 선택해주세요."	]
						,	[ "task_nm", "제목을 입력해 주세요." ]
						,	[ "task_cont", "내용을 입력해 주세요" ]
					 		,["task_start", "날짜를 선택해주세요"]
					 		,["task_due", "날짜를 선택해주세요"]
					 	/* 	,["lecselect", "과정명을 선택해주세요."] */
					]
			);

			if (!chk) {
				return;
			}

			return true;
		}
	 
	 function fn_selectonefile(task_no, lec_number){
		 //alert(no);
		 //ajax controller
		 var param = {
			task_no : task_no
			,lec_no : lec_number
		 }
		 
		 var selectoncallback = function(returndata){
				console.log( JSON.stringify(returndata) );
				
				popupinitfile(returndata.assignTeacherSearch);
				// 모달 팝업
				gfModalPop("#layer2");
			 
		 }
		 
		 callAjax("/supass/assignTeacherSelectOne.do", "post", "json", false, param, selectoncallback);
			//목록 text타입리턴타입 //나머지는 json리턴타입
		 
		 
	 }    
	 
	 
	 
	
	 
	 //파일 다운로드
	 function fn_filedownload(){
		 alert("다운로드");
		 
		 //공지사항번호 
		 //파일번호 히든값
		 
		 var params = "";
			params += "<input type='hidden' name='task_no' id='task_no' value='"+ $("#task_no").val() +"' />";
			params += "<input type='hidden' name='lec_no' id='lec_no' value='"+ $("#lec_no").val() +"' />";
			
			jQuery("<form action='/supass/downloadnoticefile.do' method='post'>"+params+"</form>").appendTo('body').submit().remove();
			
	 	// params ==> notice_no hidden 들어감
	 
	 }
	 
	 //파일 다운로드 <<== 파라미터로 listgrd로부터 받아온다. **조금방식이 다름
	 function fn_filedownload2(task_no, lec_no){
		 alert("선생님이 첨부한 파일 다운로드");
		 
		 //공지사항번호 
		 //파일번호 히든값
		 
		 var params = "";
			params += "<input type='hidden' name='task_no' id='task_no' value='"+ task_no +"' />";
			params += "<input type='hidden' name='lec_no' id='lec_no' value='"+ lec_no +"' />";
			
			jQuery("<form action='/supass/downloadnoticefile.do' method='post'>"+params+"</form>").appendTo('body').submit().remove();
			
	 	// params ==> notice_no hidden 들어감
	 
	 }
	 
	 //파일 다운로드
	 function fn_filedownload3(){
		 alert("학생이 제출한 첨부한 파일 다운로드");
		 
		 //공지사항번호 
		 //파일번호 히든값
		 
		 var params = "";
			params += "<input type='hidden' name='task_no' id='task_no' value='"+$("#task_no").val() +"' />";
			params += "<input type='hidden' name='lec_no' id='lec_no' value='"+ $("#lec_no").val() +"' />";
			
			jQuery("<form action='/supass/downloadStufile.do' method='post'>"+params+"</form>").appendTo('body').submit().remove();
			
	 	// params ==> notice_no hidden 들어감
	 
	 }
	 
	 
	 //파일 다운로드 <<== 파라미터로 listgrd로부터 받아온다. **조금방식이 다름
	 function fn_filedownload4(){
		 alert("선생님이 학생이제출한 첨부한 파일 다운로드");

		 
		 //공지사항번호 
		 //파일번호 히든값
	
		 
		 var params = "";
			params += "<input type='hidden' name='task_no' id='task_no' value='"+ $("#task_no").val() +"' />";
			params += "<input type='hidden' name='lec_no' id='lec_no' value='"+ $("#lec_no").val() +"' />";
			params += "<input type='hidden' name='enr_user' id='enr_user' value='"+ $("#enr_user").val() +"' />";
			
			jQuery("<form action='/supass/downloadSubmitStufile.do' method='post'>"+params+"</form>").appendTo('body').submit().remove();
			
	 	// params ==> notice_no hidden 들어감
	 
	 }
	 
	//////////////////////////////////학생과제게시판////////////////////
		 
	 /*과제확인+올리기 임시 UI확인 (학생))*/
	 	function fn_openpopupStudent(){
		
		//popupinitfile();
		//모달팝업
		
		 gfModalPop("#layer3");
	}
	 
	 
	 //한건조회
	 function fn_selectTasksendOne(task_no, lec_no){
		 var param ={
				 task_no: task_no
				 ,lec_no : lec_no
		 }
		 var selectoncallback = function(returndata){
			 
			 console.log( "=========" +JSON.stringify(returndata) );
			 console.log("=====t=t=t=t=====" + returndata);
			 console.log("===key값구하기===" + Object.keys(returndata));
			 console.log("returndata.task_sub_no= "+ returndata.task_sub_no);
		
			 
			 popupinitfile2(returndata);
				// 모달 팝업
				gfModalPop("#layer3");
	 	}

		 
		 callAjax("/supass/taskSendSelectOne.do", "post", "json", false, param, selectoncallback);

	 }
	 
	 
	 //미리보기
	 function preview2(event){
		 //dashboardMgr.jsp
		 var image = event.target; //change이미지바꿈. 타겟리턴 = file 태그자체를 리턴
		 
		 alert(image.files[0].name);
	

		 
		// //확장자가 찍히면된다.
		 
		 
		 if(image.files[0]){ //파일이 선택되었으면
			
			 //확장자 구하기
			 	var selfile = image.files[0].name;
			 	var selfilearr = selfile.split(".");
			 var inserthtml = "";
			 var lastindex = selfilearr.length -1; //파일명이 .이 들어간경우를 고려
			// alert(lastindex);
			 
			// alert(selfilearr[lastindex]); 
			 if(selfilearr[lastindex].toLowerCase() == "jpg" || selfilearr[lastindex].toLowerCase() == "gif" || selfilearr[lastindex].toLowerCase() =="png"){
				 //이경우는 이미지서비스이다.
				 inserthtml = "<img src='" + window.URL.createObjectURL(image.files[0]) + "'  style='width:100px; height:80px'/>"
					
			 } else{
				 //이미지파일이 아니면 파일 이름만 넣는다.
				 inserthtml = selfile;
			 }
			 
			 		 
			 
			// alert(window.URL.createObjectURL(image.files[0])); //window 브라우저 함수 파라미터로 파일넘겨주면 임시url을 만들어준다.
		 //	vuevar.inputtext = "asdf";
			 this.imgpath = window.URL.createObjectURL(image.files[0]);
			
		
			$("#previewdiv2").empty().append(inserthtml);
			
		 }
		 
		 
	 }
	 
	 
	 function popupinitfile2(object) {
			
			//var tasksendno = object.task_sub_no
	//if(tasksendno ==0 || tasksendno == null || tasksendno == "" ) {
			
		 
		 //console.log("task_sub_no= " + task_sub_no);
	
			if(object.task_sub_no == 0 || object.task_sub_no== null || object.task_sub_no == undefined) {
				$("#lec_name").val(object.lec_name);		//신규버튼 누를때 초기화
				$("#lec_prof").val(object.name);
				$("#tasksend_nm").val(object.task_nm);
				$("#tasksend_cont").val(object.task_cont);	
				
				$("#assign_start").val(object.task_start);
				$("#assign_due").val(object.task_due);

				$("#task_no").val(object.task_no); //?? 히든값설정??
				$("#lec_no").val(object.lec_no); //?? 히든값설정?
				
				$("#task_send_cont").val(""); //과제제출내용
				
				
				$("#previewdiv2").empty();// val("") 와의 차이
				
				$("#btnDeleteTask").hide(); //삭제버튼 숨김
				
				$("#action").val("I");	// action이라는 히든값 저장부를때 파라미터로 던진다.
				
				$("#btnSaveTask").html('<a href="" class="btnType blue" id="btnSaveTask" name="btn"><span>저장</span></a>');
				
			} else {
				/*
				과목명, 강사명, 과제명, 과제내용, 내용, 첨부파일
				*/
				//값이 들어오는 경우 수정버튼
			 
				//alert("파일뿌려주기222");
				console.log("파일뿌려주는 값222: " + object);
				console.log( "파일뿌려주는 값222: "+ JSON.stringify(object) );
				console.log("**********" + object.task_sub_no);
				
				$("#lec_name").val(object.lec_name); //과목명
				$("#lec_prof").val(object.name); 	//강사명
				
				$("#tasksend_nm").val(object.task_nm); //과제명		 
				$("#tasksend_cont").val(object.task_cont); //과제내용
				
				$("#task_send_cont").val(object.task_send_cont); //과제제출내용
				
				
				$("#task_no").val(object.task_no); //?? 히든값설정??
				$("#lec_no").val(object.lec_no); //?? 히든값설정?
				
						//task_start, task_due, task_tm값을 히든값으로 설정해서
						// (수정시에) 컨트롤러단에서?> 체크해주면 되겠당 =>>통과되면 task_tm = now()로 하던지
												// 			=>> upd_date = now()로설정하쟝;;
								// task_tm now를 어떻게설정하냐?
				$("#assign_start").val(object.task_start);
				$("#assign_due").val(object.task_due);			
						
				$("#previewdiv2").empty();// val("") 와의 차이
					
				$("#stu_upfile").val("");		//upfile? ** 다시 파일선택창 초기화??
				
						
						
						//=======
								var inserthtml = "<a href='javascript:fn_filedownload3()'>";
					
					if(object.file_name == "" || object.file_name == null || object.file_name == undefined) {
						inserthtml += "";
					} else {
						var selfile = object.file_name;
					    var selfilearr = selfile.split(".");
					    var lastindex = selfilearr.length - 1; //파일명에 .이 들어간 경우를 고려
					    if(selfilearr[lastindex].toLowerCase() == "jpg" || selfilearr[lastindex].toLowerCase() == "gif" || selfilearr[lastindex].toLowerCase() == "jpge" || selfilearr[lastindex].toLowerCase() == "png") {
					    	  inserthtml += "<img src='" + object.file_logic_path + "' style='width:100px; height:80px' />";
					    } else {
					    	  inserthtml += object.file_name;
					    	  //이미지파일이 아니면 파일이름만 넣는다.
					    }				
					} 
					

					inserthtml += "</a>"
					
					$("#previewdiv2").empty().append(inserthtml); //미리보기
					
					$("#btnDeleteTask").show(); //삭제버튼을 보여주고
					
					$("#action").val("U");	 //업데이트형태로 간다.
					
					//------------					
					//저장 -> 수정 html변경하기
					$("#btnSaveTask").html('<a href="" class="btnType blue" id="btnSaveTask" name="btn"><span>수정</span></a>');
					
				
			
			}
			
			
			
			
		   }
			
	
	 //** 학생이 제출하는 과제등록////
 	 //등록
	function fn_saveTaskSend(){
		 if(!fn_ValidateTaskSend()){
			 return;
		 }
		 
		 
		 ////////////날짜체크하기
	/* 	 var startDate =	Date.parse('$("#assign_start").val()');
		var endDate = 		Date.parse('$("#assign_due").val()');		
		var now = new Date();
		

		if((startDate <= now)){
			alert("제출기간이 도래하지않았습니다.")
			return;
		}
		if((endDate >= now)){
			alert("기간만료되었습니다.")
			return;
		} */
		
		
	/* 	if(startDate){
			  now = 
			    leadingZeros(now.getFullYear(), 4) + '-' +
			    leadingZeros(now.getMonth() + 1, 2) + '-' +
			    leadingZeros(now.getDate(), 2);
			  if(startDate > now){
			    alert("제출 날짜가 도래하지 않았습니다.");
			    return;
			  }
			}
		if(endDate){
			  now = 
			    leadingZeros(now.getFullYear(), 4) + '-' +
			    leadingZeros(now.getMonth() + 1, 2) + '-' +
			    leadingZeros(now.getDate(), 2);
			  if(endDate < now){
			    alert("제출기간이 지났습니다.");
			    return;
			  }
			} */
		 
		 
		 //form Data
		 //파일업로드
		 //기존 파라미터..serialize나 param정의해서 사용
		 //파일에 대한 정보는 넘어가지않음.
		 //callajax
		 
		 var frm = document.getElementById("myForm");
		 frm.enctype = 'multipart/form-data';
		 var fileData = new FormData(frm); //파일정보까지 둘둘말아 던진다.
		 console.log(fileData);
		 
		 //콜백함수정의
		 var filesavecallback = function (returnval){
				 //반환값이 json
				console.log(JSON.stringify(returnval));
				 
				if(returnval.returnVal > 0) {
					alert("저장 되었습니다.");
					gfCloseModal();
					
					if($("#action").val() == "U") {
						fn_assignmentStuList($("#pageno").val(),$("#leclist").val());
					} else {
						fn_assignmentStuList();
					} 
				}
				else if(returnval.returnVal == -5){
						swal("기간을 준수해주세요!");			
				}
				else {
					alert("오류가 발생 되었습니다.");				
				}
				 
		 }
		 
		 
		 
		callAjaxFileUploadSetFormData("/supass/assignStuSaveFile.do", "post", "json", true, fileData, filesavecallback);

	 }
 
 function fn_ValidateTaskSend() {

		var chk = checkNotEmpty(
				[		
				 		[	"task_send_cont" , "과제내용을 입력해주세요."	]
				
		
				]
		);

		if (!chk) {
			return;
		}

		return true;
	}
 
/*  function leadingZeros(n, digits) {
	    var zero = '';
	    n = n.toString();

	    if (n.length < digits) {
	        for (i = 0; i < digits - n.length; i++)
	            zero += '0';
	    }
	    return zero + n;
	}
  */
		
			
 function fn_submitlist(task_no, lec_number, pageNum){
	 //alert(no);
	 //ajax controller
			pageNum = pageNum || 1; //undefined 이면 1값을 세팅해라.
					
			//alert('실행 되었습니다.fn_submitlist 제출명단');
			

			
		 var param = {
		task_no : task_no
		,lec_no : lec_number
		 ,pageSize : pageSize
		  , pageBlockSize : pageBlockSize
		  , pageNum : pageNum
	 }
	 
	 var selectoncallback = function(returnvalue){
			console.log('list함수 실행하고 컨트롤러에서 컬백받는 value :'+ returnvalue);
			$("#submitStudentList").empty().append(returnvalue); 
						//tbody 영역 

			// 모달 팝업
			gfModalPop("#layer4");
		 
			
			
			var totalCnt = $("#submit_totalCnt").val();
			console.log("totalCnt: "+ totalCnt);
	
			
					
	//페이지 네비게이션 getPaginationHtml 공통함수
			var paginationHtml = getPaginationHtml(pageNum, totalCnt, pageSize2, pageBlockSize2, 'fn_submitlist');
			console.log("paginationHtml : " + paginationHtml);
			//swal(paginationHtml);
			$("#submitlistPagination").empty().append( paginationHtml );
			
			$("#pageno").val(pageNum); //현재보고있는 currentpage = pagenum 	
			
			
	 }
	 
	 callAjax("/supass/submitList.do", "post", "text", false, param, selectoncallback);
		//목록 text타입리턴타입 //나머지는 json리턴타입
	 
	  
 }    			
	
 function fn_submitcontent(task_no, lec_number, enr_user){
	 //alert(no);
	 //ajax controller
			
			//alert('실행 되었습니다.fn_submitlist 제출명단');
			// 모달 팝업
			//gfModalPop("#layer5");

			 var param = {
						task_no : task_no
						,lec_no : lec_number
						,enr_user : enr_user
					 }
					 
			 var selectoncallback = function(returndata){
							console.log('stringify안하고 출력====' + returndata); //[object Object]
				 			console.log( JSON.stringify(returndata) );
							
							//alert('실행 되었습니다.fn_submitlist 제출명단결과');
							submitpopup(returndata.submitSelectone);
							// 모달 팝업
							gfModalPop("#layer5");
						 
					 }
					 
				
			 
			 
			 
			 callAjax("/supass/submitContent.do", "post", "json", false, param, selectoncallback);
				//목록 text타입리턴타입 //나머지는 json리턴타입
			 

 }    		
 
 function submitpopup(object){
	 
 	//alert('submitpopup이 호출되었습니다. table에 값채우기')
	 console.log(object);
 	 console.log(typeof(object));
 	 
 	$("#submitContStudentList").empty();
 	$("#lec_no").val(object.lec_no);
 	$("#task_no").val(object.task_no);
 	$("#enr_user").val(object.enr_user);
 	
 	var submitAdd = "";
 	
 	if(object.file_name == null){
 		var submitAdd  = "<tr>"+
 		 
 		 "<td>"+object.task_send_cont+"</td>"+
 		 "<td>"+"X"+"</td>"+	
 		 "<td>"+ "파일없음" +"</td>"+
 		 "<td>"+object.task_tm+"</td>"+
 		 "</tr>";
 	} else{
 	
 	 var submitAdd = "<tr>"+
	 
	 "<td>"+object.task_send_cont+"</td>"+
	 "<td>"+object.file_name+"</td>"+	
	 "<td>"+ '<a href="javascript:fn_filedownload4()");>'+"받기"+'</a>' +"</td>"+
	 "<td>"+object.task_tm+"</td>"+
	 "</tr>";
 	}
	 
	$("#submitContStudentList").append(submitAdd);


//fn_filedownload처럼 input hidden tag로 설정 


 
 }
		
	
</script>
</head>



<body>
		<!-- 관리자로 접속할 경우 밖으로 나가라.. -->
		<c:choose>
			<c:when test="${sessionScope.userType == 'M'}">
						  <c:redirect url="/dashboard/dashboard.do"/>
			</c:when>	
		</c:choose>
<form id="myForm" action=""  method="">

	<input type="hidden" id="action" name="action" />
	<!-- action이라는 히든값 저장버튼누를때 파라미터로 집어던진다. -->
 <input type="hidden" id="task_no"  name="task_no"  />
<input type="hidden" id="lec_no" name="lec_no"/> <!-- select box도 form데이터할때 같이 넘어간다>>??값을지정해줘야함. -->
	<input type="hidden" id="pageno"  name="pageno"  />
 <!-- 목록조회할떄 현재보고있는 페이지번호 -->
 <input type="hidden" id="assign_start" name="assign_start"/>
 <input type="hidden" id="assign_due" name="assign_due"/>
<!--  -->
  <input type="hidden" id="enr_user" name="enr_user"/>
   
   
	<!-- update no히든값. -->
	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">

		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 --> <jsp:include
						page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
				</li>
				<li class="contents">
					<!-- contents -->
					<h3 class="hidden">contents 영역</h3> <!-- content -->
					<div class="content">

						<p class="Location">
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
								class="btn_nav bold">학습관리</span> <span class="btn_nav bold">과제관리
								</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침★</a>
						</p>
				
						<p class="conTitle">
							
	
							
							<span>수업 목록</span> <span class="fr">
													
						
							 <select id="leclist" name="leclist" style="width: 150px;" >						
						    		<option value="" >전체</option>	
						    		<!-- option value="lec_no"> lec_name </option> -->					    									
							</select> 
							
							
							<!-- 선생님일 경우에만 학습자료 등록가능 -->
							<c:choose>
    					<c:when test="${sessionScope.userType=='T'}">
    							<!-- TODO ::: 검색버튼도 학생이랑 선생님 나누어서 생각하자;; -->
	                           <a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a>
        					 <a	 class="btnType blue" href="javascript:fn_openpopupfile();" name="modal"><span>과제 올리기 </span></a>
					
  						  </c:when>
							</c:choose>
							
							
													<!-- 선생님일 경우에만 학습자료 등록가능 -->
							<c:choose>
    					<c:when test="${sessionScope.userType=='S'}">
    							<!-- TODO ::: 검색버튼도 학생이랑 선생님 나누어서 생각하자;; -->
	                           <a href="" class="btnType blue" id="btnSearch2" name="btn"><span>검  색</span></a>
        				
  						  </c:when>
							</c:choose>
						
							</span>
						</p>
						
						<div class="lectureList">
			<h1 style="font-size:15px">수업 정보</h1><br/>
								   
			
							<table class="col">
								<caption>수업목록</caption>
								<colgroup>
									<col width="25%">
									<col width="15%">
									<col width="10%">
									<col width="10%">	
									<col width="20%">
									<col width="10%">
									<col width="10%">						
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">강의명</th>
										<th scope="col">강사명</th>
										<th scope="col">개강일</th>
										<th scope="col">종강일</th>
										<th scope="col">강의실</th>
										<th scope="col">현재인원</th>
										<th scope="col">정원</th>
											
									</tr>
								</thead>
								<tbody id="listlecture"></tbody>
							</table>
						</div>
						<div class="paging_area2"  id="noticePagination2"> </div> 
						
						
						</br>
						</br>
			
		
						<c:choose>
    	<c:when test="${sessionScope.userType=='T'}">
		<div class="assignList">
		<h1 style="font-size:15px">과제 관리</h1><br/>
						
				
						
				<table class="col">
					<caption>과제목록</caption>
					<colgroup>
						<col width="10%">
						<col width="45%">
						<col width="15%">
						<col width="15%">
						<col width="15%">							
					</colgroup>

							<thead>
								<tr>
									<th scope="col">과제 번호</th>
									<th scope="col">과제 이름</th>
									<th scope="col">제출일</th>
									<th scope="col">마감일</th>
									<th scope="col">제출 현황</th>
															
								</tr>
							</thead>
							<tbody id="listassignmentTeacher"></tbody>
						</table>
						
		</div>
		<div class="paging_area"  id="assignmentTeacherPagination"> </div>
					
					 </c:when>
				</c:choose>
						
		<c:choose>
    	<c:when test="${sessionScope.userType=='S'}">
    		<div class="assignStudentList">
				
						
				<table class="col">
					<caption>과제목록</caption>
					<colgroup>
						<col width="5%">
						<col width="10%">
						<col width="30%">
						<col width="10%">
						<col width="25%">
						<col width="20%">							
					</colgroup>

							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">강의명</th>
									<th scope="col">과제명</th>
									<th scope="col">강사</th>
									<th scope="col">기간</th>
									<th scope="col">첨부파일</th>
										
								</tr>
							</thead>
							<tbody id="listassignmentStudent"></tbody>
						</table>
						
		</div>
		<div class="paging_area"  id="assignmentStudentPagination"> </div>
			 </c:when>
		</c:choose>
						
						<table style="margin-top: 10px" width="100%" cellpadding="5" cellspacing="0" border="1"
                        align="left"
                        style="collapse; border: 1px #50bcdf;">
                        <tr style="border: 0px; border-color: blue">
                           <td width="80" height="25" style="font-size: 120%;">&nbsp;&nbsp;</td>
                           <td width="50" height="25" style="font-size: 100%; text-align:left; padding-right:25px;">
     	                  
     	                     
                           </td> 
                           
                        </tr>
                     </table> 
                     
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<!-- 모달팝업 -->
	<div id="layer1" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>그룹코드 관리</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">제목 <span class="font_red">*</span></th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								name="notice_title" id="notice_title" /></td>
									
						</tr>
						<tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								name="notice_cont" id="notice_cont" /></td>					
						</tr>
				
				
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSave" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDelete" name="btn"><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>



	<div id="layer2" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>과제올리기</strong>
			</dt>
			<dd class="content">

				<!-- s : 여기에 내용입력 -->

				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
						<th scope="row">과정명 <span class="font_red">*</span></th>
							<td colspan="3"><select id="lecselect" name="lecselect" ></select></td>						
						</tr>
						<tr>
							<th scope="row">제목 <span class="font_red">*</span></th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								name="task_nm" id="task_nm" /></td>
							
						</tr>
						<tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								name="task_cont" id="task_cont" /></td>					
						</tr>
							<tr>
							<th scope="row">제출일 <span class="font_red">*</span></th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								name="task_start" id="task_start" />
								<i class="date-icon fa fa-calendar" aria-hidden="true"></i>
								</td>					
						</tr>
							<tr>
							<th scope="row">마감일 <span class="font_red">*</span></th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								name="task_due" id="task_due"/></td>					
						</tr>
						<tr>
							<th scope="row">파일업로드 <span class="font_red">*</span></th>
							<td  colspan="3"><input type="file" class="inputTxt p100"
								name="upfile" id="upfile" onchange="javascript:preview3(event)" /></td>	
						
						</tr>
						<tr>
							<td colspan="4">
							<div id="previewdiv3" ></div>
							</td> <!-- 이미지가있으면 미리보게하고, 파일업로드시 표시가능, 다운로드도 가능하게한다. -->				
						</tr>
				
				
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveFile" name="btn"><span>저장</span></a>
					<a href="" class="btnType blue" id="btnUpdateFile" name="btn"><span>수정</span></a>
					<a href="" class="btnType blue" id="btnDeleteFile" name="btn"><span>삭제</span></a>  
					<a href="" class="btnType gray" id="btnCloseFile" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	<!--// 모달팝업 -->
	
	
	
	<!-- 모달팝업 -->
	<div id="layer3" class="layerPop layerType2" style="width: 800px;">
		<dl>
			<dt>
				<strong>과제</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">과목명</th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								name="lec_name" id="lec_name" readonly /></td>
							<th scope="row">강사명 </th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								name="lec_prof" id="lec_prof" readonly/></td>
						</tr>
						<tr>
							<th scope="row">과제명 </th>
							<td colspan="6"><input type="text" class="inputTxt p100"
								name="tasksend_nm" id="tasksend_nm" readonly /></td>					
						</tr>
						<tr>
							<th scope="row">과제내용 </th>
							<td colspan="6"><textarea name="tasksend_cont"  class="inputTxt p100"
								 id="tasksend_cont" readonly></textarea></td>					
						</tr>
						<tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td colspan="6"><textarea name="task_send_cont"  class="inputTxt p100"
								 id="task_send_cont" placeholder="과제 내용을 입력하세요"></textarea></td>					
						</tr>
						<tr>
							<th scope="row">첨부파일 <span class="font_red">*</span></th>
							<td colspan="6"><input type="file" class="inputTxt p100"
								name="stu_upfile" id="stu_upfile" onchange="javascript:preview2(event)" /></td>					
						</tr>
						<tr>
							<td colspan="6">
							<div id="previewdiv2" ></div>
							</td> <!-- 이미지가있으면 미리보게하고, 파일업로드시 표시가능, 다운로드도 가능하게한다. -->				
						</tr>
				
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveTask" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDeleteTask" name="btn"><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	
	
	
		<!-- 제출명단 모달팝업 -->
	<div id="layer4" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>제출 명단</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="col">
					<caption>caption</caption>
					<colgroup>
						
						<col width="50%">
						<col width="50%">
						
					</colgroup>

					
					
					    <thead>
			                <tr>
			                    <th scope="col">이름</th>
			                    <th scope="col">이메일</th>	                  
			                        
			                </tr>
			            </thead>
					
					 <tbody id="submitStudentList"></tbody>
					
				</table>

				<!-- e : 여기에 내용입력 -->

			
				
					<div class="paging_area3"  id="submitlistPagination"> </div> 
						
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	
	
			<!-- 제출명단의 과제내용 모달팝업 -->
	<div id="layer5" class="layerPop layerType2" style="width: 800px;">
		<dl>
			<dt>
				<strong>과제 내용</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="col">
					<caption>caption</caption>
					<colgroup>
						
						<col width="55%">
						<col width="15%">
						<col width="15%">
						<col width="15%">
						
					</colgroup>

					
					    <thead>
			                <tr>
			                    <th scope="col">내용</th>
			                    <th scope="col">파일 이름</th>
			                    <th scope="col">파일 받기</th>
			                    <th scope="col">제출일</th>
			                    	                  
			                        
			                </tr>
			            </thead>
					
					 <tbody id="submitContStudentList"></tbody>
					
				</table>

				<!-- e : 여기에 내용입력 -->

			
						
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	
	
</form>



</body>
</html>

