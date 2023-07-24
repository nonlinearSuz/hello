package kr.happyjob.study.supass.model;

import java.util.Date;
//주석
public class LectureModel {
	
	private int lec_no;
	private String lec_name;
	private String lec_prof;

	//list 강의목록 조건 추가.../////////////
	private String lec_start;
	private String lec_end;
	private int room_no;
	private String rm_name;
	private int max_no;
	private int cnt;
	private String loginID;
	
	private String name; //강사명
	
	
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getRm_name() {
		return rm_name;
	}
	public void setRm_name(String rm_name) {
		this.rm_name = rm_name;
	}
	public String getLec_start() {
		return lec_start;
	}
	public void setLec_start(String lec_start) {
		this.lec_start = lec_start;
	}
	public String getLec_end() {
		return lec_end;
	}
	public void setLec_end(String lec_end) {
		this.lec_end = lec_end;
	}
	public int getRoom_no() {
		return room_no;
	}
	public void setRoom_no(int room_no) {
		this.room_no = room_no;
	}
	public int getMax_no() {
		return max_no;
	}
	public void setMax_no(int max_no) {
		this.max_no = max_no;
	}
	public int getCnt() {
		return cnt;
	}
	public void setCnt(int cnt) {
		this.cnt = cnt;
	}
	public String getLoginID() {
		return loginID;
	}
	public void setLoginID(String loginID) {
		this.loginID = loginID;
	}
	public int getLec_no() {
		return lec_no;
	}
	public void setLec_no(int lec_no) {
		this.lec_no = lec_no;
	}
	public String getLec_name() {
		return lec_name;
	}
	public void setLec_name(String lec_name) {
		this.lec_name = lec_name;
	}
	public String getLec_prof() {
		return lec_prof;
	}
	public void setLec_prof(String lec_prof) {
		this.lec_prof = lec_prof;
	}
	@Override
	public String toString() {
		return "LectureModel [lec_no=" + lec_no + ", lec_name=" + lec_name + ", lec_prof=" + lec_prof + ", lec_start="
				+ lec_start + ", lec_end=" + lec_end + ", room_no=" + room_no + ", max_no=" + max_no + ", cnt=" + cnt
				+ ", loginID=" + loginID + "]";
	}



	
	
}
