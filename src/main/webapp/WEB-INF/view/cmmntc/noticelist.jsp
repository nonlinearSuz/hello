<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>공지사항</title>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">

	// 페이징 설정
	var pageSize = 10;  
	var pageBlockSize = 5;    
	
	/** OnLoad event */ 
	$(function() {
		// 버튼 이벤트 등록
		ButtonClickEvent();
		
		noticeList();
		
	});
	

	/** 버튼 이벤트 등록 */

	function ButtonClickEvent() {
		$('a[id=closePop]').click(function(e) {
			e.preventDefault();
			
			var closeId = $(this).attr('Id');
			
			switch(closeId) {
			case 'closePop' :
				noticeList();
				break;
			}
		});
		
		$('a[id=closeRePop]').click(function(e) {
			e.preventDefault();
			
			var closeRpId = $(this).attr('Id');
			
			switch(closeRpId) {
			case 'closeRePop' :
				noticeList();
				break;
			}
		});
		
/* 		$('td[class=rpyno]').click(function(e) {
			e.preventDefault();
			
			var rpyNo = $(this).attr('Id');
			
			$("#rpy_no").attr("rpy_no",rpyNo)
		
		});	 */
		
		
		
		$('a[name=btn]').click(function(e) {
			e.preventDefault(); // event의 고유 동작 중단 시키기.
			//e.stoppropagation => 상위 elements의 event 전파 중단.

			var btnId = $(this).attr('id');

			switch (btnId) {
				case 'btnSearch' :
					noticeList();
					break;
				case 'btnSave' : 
					fn_save();
					break;
				case 'btnUpdate' :
				$("#action").val("U");
					fn_save();
					break; 
				case 'btnDelete' :
				$("#action").val("D");	
					fn_saved(); 
					break;	
				case 'btnClose' :
					gfCloseModal();
					break;
				//댓글 작성
 				case 'btnReply' :
					fn_reply();
					break;
				//댓글 수정
				case 'btnReplyUpdate' :
				 $("#reaction").val("U"); 
					fn_replyes();
					break;
				//댓글 삭제
				case 'btnReplyDelete' :
				 $("#reaction").val("D"); 
					fn_replyed();
					break;
			}
		});
	}
	
	// 게시글 화면 기능(페이지 당)
	function noticeList(pagenum) {
		
		pagenum = pagenum || 1;
		
			var param = { // parameter 값
			  searchKey : $("#searchKey").val()
			  , sname : $("#sname").val()
			  , pageSize : pageSize
			  , pageBlockSize : pageBlockSize
			  , pagenum : pagenum
			}
		
		var listcollabck = function(returnvalue) {
			console.log(returnvalue);
			
			$("#listnotice").empty().append(returnvalue);
			
			var  totalcnt = $("#totalcnt").val();
			
			console.log("totalcnt : " + totalcnt);
			
			var paginationHtml = getPaginationHtml(pagenum, totalcnt, pageSize, pageBlockSize, 'noticeList');
			console.log("paginationHtml : " + paginationHtml);
			 
			$("#noticePagination").empty().append( paginationHtml );
			
			$("#pageno").val(pagenum);
		}
		
		callAjax("/cmmntc/noticelist.do", "post", "text", false, param, listcollabck) ;
			
	}
	
/* 	function noticeRvlist(pagenum) {
			pagenum = pagenum || 1;
			
				var param = {
						pageSize : pageSize
					,	pageBlockSize : pageBlockSize
					,	pagenum : pagenum
					,	rpy_no : rpy_no
					,	rpy_contents : rpy_contents
					,	enr_user : '${loginId}'
					,	enr_date : now()
				}
				
				var listcollback = function(returnvalue) {
					console.log(returnvalue);
					
					$(".re_body").empty().append(returnvalue);
					
					var retotalcnt = $("#retotalcnt").val();
					
					console.log("retotalcnt : " + retotalcnt);
					
					var paginationHtml = getPaginationHtml(pagenum, retotalcnt, pageSize,
							pageBlockSize, 'noticeRvlist');
					
					console.log("paginationHtml : " + paginationHtml);
					
					$("#noticeRv").empty().append(paginationHtml);
					
					$("#pageno").val(pagenum);
					
				}
				
				callAjax("cmmntc/noticeRvList.do", "post", "text", false, param, listcollback);
				
	} */
	
	//상세조회 + 댓글 목록 popup
/*  	function fn_openReplyPopUp() {
		openReplyPopUpInit();
		
		gfModalPop("#layer2");
	} 
	
	//상세조회 + 댓글 목록 popup
  	function openReplyPopUpInit(returndata) {
		if(returndata == "" || returndata == null || returndata == undefined) {
				$("#nt_no").val(""); //글번호
				$("#nt_title").val(""); //글제목
				$("#nt_contents").val(""); //글내용
				$("#enr_user").val(""); //글작성자 & 댓글 작성자
				$("#enr_date").val(""); //글 등록일 & 댓글 작성일
				$("#upd_user").val(""); //글 수정자
				$("#upd_date").val(""); //글 수정일
				$("#rpy_no").val(""); //댓글번호
				$("#rpy_contents").val(""); //댓글내용
				$("#rpy_writer").val("");
				$("#rpy_date").val(""); 
				
				$("#btnReply").show();
				
				$("#action").val("I");
		} else {
			$("#nt_no").val(returndata.nt_no);
			$("#noti_no").text(returndata.nt_no);
			$("#noti_title").val(returndata.nt_title);
			$("#noti_writer").text(returndata.enr_user);
			$("#noti_date").text(returndata.enr_date);
			$("#noti_contents").val(returndata.nt_contents);
			$("#rpy_no").val(returndata.rpy_no);
			$("#rpy_contents").val(returndata.rpy_contents);
			$("#rpy_writer").val(returndata.enr_user);
			$("#rpy_date").val(returndata.enr_date);
			$("#rpy_writer").text(returndata.enr_user);
			$("#rpy_date").text(returndata.enr_date); 
			
			$("#btnReply").hide();
			
			$("#action").val("U");
			
			//loginID와 작성자가 같을 시 버튼 보이기
		
			console.log(returndata);

			 if(noticeRvList.length < 1) {
				 alert("댓글이 집을 나갔습니다.");
				 $("#re_title").hide();
				 $("#re_body").hide();
				 $("#btnReply").show();
				 $("#btnReplyUpdate").hide();
				 $("#btnReplyDelete").hide();
				 
				 $("#action").val("I");
			 } else {
				 alert("댓글이 왔습니다.");
				 $("#re_title").show();
				 $("#re_body").show();
				 $("#btnReply").show();
				 $("#btnReplyUpdate").show();
				 $("#btnReplyDelete").show();
				 
				 $("#action").val("U");
			 }
		}
	}   */
		
	//작성 popup
	function fn_openpopup() {
		
		popupinit(); // clean()
		
		// 모달 팝업
		gfModalPop("#layer1");
		
	}
	
	//작성 popup
 	function popupinit(returndata) {
		
		if(returndata == "" || returndata == null || returndata == undefined) {
			$("#nt_no").val("");
			$("#nt_title").val("");		
			$("#nt_contents").val("");
			$("#enr_user").val("");
			
			$("#btnSave").show();
			
			$("#action").val("I");	
		} else {
 			$("#nt_no").val(returndata.nt_no);
 			$("#nt_title").val(returndata.nt_title);
 			$("nt_contents").val(returndata.nt_contents);
			$("#noti_title").val(returndata.nt_title);
			$("#noti_writer").val(returndata.enr_user);
			$("#noti_contents").val(returndata.nt_contents);
			
			$("#btnSave").hide();
			
			$("#action").val("U");
		}
	} 
	
	// 상세조회
	function selectone(no) {
		
		//alert(no);
		
		var param = {
				nt_no : no 
		}
		
		console.log("selectone_param" + JSON.stringify(param));
		
		var selectoncallback = function(returndata) {	
			$("#action").val("U");
			$("#nt_no").val(no);
			$("#rpy_no").val();
			$("#reaction").val("I");
			
		  console.log("retundata -----------------------"+returndata);
		$("#layer2").empty().append(returndata);  
		
		gfModalPop("#layer2");
		
		}
		callAjax("/cmmntc/noticeselectone.do", "post", "text", false, param, selectoncallback) ;
	}
	
	function fn_saved() {
		$("#action").val("D");
		fn_save();
	}
	
	//(btnSave, btnUpdate, btnDelete가 사용)
	function fn_save() {
		
		//확인 여부 체크
		if (!fn_Validate()) {
			return;
		}
		
		var param = {
				action : $("#action").val(), //작성할땐 action="I"로 잘 나옴
				nt_no : $("#nt_no").val(), //글 번호 (layer1) 
				nt_title : $("#nt_title").val(), //글 제목 (layer1)
				nt_contents : $("#nt_contents").val(), //글 내용 (layer1)
				noti_title : $("#noti_title").val(), //글 제목(layer2)
				noti_contents : $("#noti_contents").val(),//글 내용 (layer2)
				enr_user : '${loginId}'
		}
		
		console.log("fn_save_param" + JSON.stringify(param));
		
		var savecollback = function(reval) {
				console.log(JSON.stringify(reval));
				console.log(reval.returnval);
				
			if(reval.returnval > 0) {
				
				if($("#action").val() == "U") { //action이 U이면
					noticeList($("#pageno").val());
					alert("수정 되었습니다.");
					gfModalPop("#layer2");
					
				}else if($("#action").val() == "I"){
					alert("작성 되었습니다.");
					noticeList(); 
					gfCloseModal();
				} else {
					noticeList(); 
				}
				
			} else {
				alert("오류가 발생 되었습니다.");				
			}		
		}
		callAjax("/cmmntc/noticesave.do", "post", "json", false, param , savecollback);
	}
	
	function fn_replyes(rpy_no) {
		$("#rpy_no").val(rpy_no); 
		$("#reaction").val("U");
		fn_reply();
	}
	
	function fn_replyed(rpy_no) {
		$("#rpy_no").val(rpy_no);
		$("#reaction").val("D");
		fn_reply();
	}
	
	
	//댓글 작성
	function fn_reply() {
		var rpy_no = $("#rpy_no").val();
		
		var param = {
				reaction : $("#reaction").val(),
				nt_no : $("#nt_no").val(),
				rpy_no : $("#rpy_no").val(),
				rpy_content : $("#rpy_content").val(), //댓글 내용
				rpy_contents : $("#rpy_contents" + rpy_no).val(),
				enr_user : '${loginId}'
		}
			
		 console.log("-----------------------"+$(".rpyno").val());  
		
		console.log("fn_reply_param" + JSON.stringify(param));
		
		var resultCallback = function(reval) {
			if(reval.returnval > 0) {
				alert("완료되었습니다.");
				gfCloseModal("#layer2");
				
				if($("#reaction").val() == "U") {
					gfCloseModal();
					alert("수정되었습니다.");
				} else {
					gfCloseModal();
				} 
				
			} else {
				alert("오류가 발생하였습니다.");
			}
		} 
		
		callAjax("/cmmntc/noticeResave.do", "post", "json", false, param, resultCallback);
	} 
	
	// 유효성 검사
	function fn_Validate() {

		var chk = checkNotEmpty(
				[
						["noti_title","제목을 입력해 주세요!"]	
					,	["noti_contents","내용을 입력해주세요!"]
				]
		);

		if (!chk) {
			return;
		}

		return true;
	}
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" id="action"  name="action"  />
	<input type="hidden" id="reaction"  name="reaction"  />
	<input type="hidden" id="nt_no"  name="nt_no"  />
<!-- 	<input type="hidden" id="rpy_no"  name="rpy_no"  /> -->
	<input type="hidden" id="pageno"  name="pageno"  />
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
								class="btn_nav bold">커뮤니티</span> <span class="btn_nav bold">공지사항
								</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>공지사항</span> <span class="fr">  
							 <select id="searchKey" name="searchKey" style="width: 150px;" >
									<option value="title" >글제목</option>
									<option value="cont" >글내용</option>
									<option value="writer">작성자</option>
							</select> 
							<input type="text" style="width: 250px; height: 25px;" id="sname" name="sname">
							<a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a>
			                <c:if test="${sessionScope.userType eq 'T' || sessionScope.userType eq 'S' }">
								 <a class="btnType blue" href="javascript:fn_openpopup();" name="modal" ><span>작성</span></a>
							</c:if>
							</span>
						</p>
						
						<div class="noticeList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="15%">
									<col width="40%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">글번호</th>
										<th scope="col">제목</th>
										<th scope="col">작성자</th>
										<th scope="col">등록일</th>
										<th scope="col">조회수</th>
									</tr>
								</thead>
								<tbody id="listnotice"></tbody>
							</table>
						</div>
						<div class="paging_area"  id="noticePagination"> </div>&nbsp;		 
					</div>
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
				<strong>공지사항 등록하기</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
                                 <col width="120px">
                                 <col width="*px">
                                 <col width="120px">
                                 <col width="*px">

					</colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3"><input type="text" class="inputTxt p100" name="nt_title" id="nt_title" /></td>
						</tr>
						<tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td colspan="5"  style="text-align: left;">
							    <textarea id="nt_contents" name="nt_contents"> </textarea>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSave" name="btn"><span>작성</span></a>
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop" id="closePop"><span class="hidden">닫기</span></a>
	</div>

     <div id="layer2" class="layerPop layerType2" style="width: 45%;">
     	  
     </div>

	<!--// 모달팝업 -->
</form>
</body>
</html>