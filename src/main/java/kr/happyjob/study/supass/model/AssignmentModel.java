package kr.happyjob.study.supass.model;
//주석
public class AssignmentModel {
	private int lec_no;		//강의번호
	private String lec_name; //강의명
	private int task_no;   	//과제번호
	private String task_nm; //과제제목
	private String name; //lec_prof에 해당하는 선생님이름. 혹은 제출자의 이름
	private String user_email; //유저 이메일..


	private String task_cont; //과제 내용
	private String task_start; //과제 제출시작일
	private String task_due; //과제 제출종료일
	private String lec_prof;  //강사이름
	
	private int task_sub_no; //과제제출일련번호
	private String enr_user;	//제출자
	
	private String task_send_cont; // 과제 제출 내용 : tasksend의 content에 해당
	private String task_tm;		//과제제출일시
	private String upd_date; //과제 제출 수정일시
	
	private int file_no;		//파일번호
	private String file_name;
	private String file_logic_path;
	private String file_physic_path;
	private int file_size;
	private String file_ext;
	
	private int file_no2;		//파일번호
	private String file_name2;
	private String file_logic_path2;
	private String file_physic_path2;
	private int file_size2;
	private String file_ext2;
	
	
	
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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
	public int getTask_no() {
		return task_no;
	}
	public void setTask_no(int task_no) {
		this.task_no = task_no;
	}
	public String getTask_nm() {
		return task_nm;
	}
	public void setTask_nm(String task_nm) {
		this.task_nm = task_nm;
	}
	public String getTask_start() {
		return task_start;
	}
	public void setTask_start(String task_start) {
		this.task_start = task_start;
	}
	public String getTask_due() {
		return task_due;
	}
	public void setTask_due(String task_due) {
		this.task_due = task_due;
	}
	public String getLec_prof() {
		return lec_prof;
	}
	public void setLec_prof(String lec_prof) {
		this.lec_prof = lec_prof;
	}
	public int getTask_sub_no() {
		return task_sub_no;
	}
	public void setTask_sub_no(int task_sub_no) {
		this.task_sub_no = task_sub_no;
	}
	public String getEnr_user() {
		return enr_user;
	}
	public void setEnr_user(String enr_user) {
		this.enr_user = enr_user;
	}
	public int getFile_no() {
		return file_no;
	}
	public void setFile_no(int file_no) {
		this.file_no = file_no;
	}

	
	public String getTask_tm() {
		return task_tm;
	}
	public void setTask_tm(String task_tm) {
		this.task_tm = task_tm;
	}
	public String getTask_cont() {
		return task_cont;
	}
	public void setTask_cont(String task_cont) {
		this.task_cont = task_cont;
	}
	public String getFile_name() {
		return file_name;
	}
	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}
	public String getFile_logic_path() {
		return file_logic_path;
	}
	public void setFile_logic_path(String file_logic_path) {
		this.file_logic_path = file_logic_path;
	}
	public String getFile_physic_path() {
		return file_physic_path;
	}
	public void setFile_physic_path(String file_physic_path) {
		this.file_physic_path = file_physic_path;
	}
	public int getFile_size() {
		return file_size;
	}
	public void setFile_size(int file_size) {
		this.file_size = file_size;
	}
	public String getFile_ext() {
		return file_ext;
	}
	public void setFile_ext(String file_ext) {
		this.file_ext = file_ext;
	}
	public String getTask_send_cont() {
		return task_send_cont;
	}
	public void setTask_send_cont(String task_send_cont) {
		this.task_send_cont = task_send_cont;
	}
	public String getUpd_date() {
		return upd_date;
	}
	public void setUpd_date(String upd_date) {
		this.upd_date = upd_date;
	}
	public int getFile_no2() {
		return file_no2;
	}
	public void setFile_no2(int file_no2) {
		this.file_no2 = file_no2;
	}
	public String getFile_name2() {
		return file_name2;
	}
	public void setFile_name2(String file_name2) {
		this.file_name2 = file_name2;
	}
	public String getFile_logic_path2() {
		return file_logic_path2;
	}
	public void setFile_logic_path2(String file_logic_path2) {
		this.file_logic_path2 = file_logic_path2;
	}
	public String getFile_physic_path2() {
		return file_physic_path2;
	}
	public void setFile_physic_path2(String file_physic_path2) {
		this.file_physic_path2 = file_physic_path2;
	}
	public int getFile_size2() {
		return file_size2;
	}
	public void setFile_size2(int file_size2) {
		this.file_size2 = file_size2;
	}
	public String getFile_ext2() {
		return file_ext2;
	}
	public void setFile_ext2(String file_ext2) {
		this.file_ext2 = file_ext2;
	}
	public String getUser_email() {
		return user_email;
	}
	public void setUser_email(String user_email) {
		this.user_email = user_email;
	}
	@Override
	public String toString() {
		return "AssignmentModel [lec_no=" + lec_no + ", lec_name=" + lec_name + ", task_no=" + task_no + ", task_nm="
				+ task_nm + ", name=" + name + ", user_email=" + user_email + ", task_cont=" + task_cont
				+ ", task_start=" + task_start + ", task_due=" + task_due + ", lec_prof=" + lec_prof + ", task_sub_no="
				+ task_sub_no + ", enr_user=" + enr_user + ", task_send_cont=" + task_send_cont + ", task_tm=" + task_tm
				+ ", upd_date=" + upd_date + ", file_no=" + file_no + ", file_name=" + file_name + ", file_logic_path="
				+ file_logic_path + ", file_physic_path=" + file_physic_path + ", file_size=" + file_size
				+ ", file_ext=" + file_ext + ", file_no2=" + file_no2 + ", file_name2=" + file_name2
				+ ", file_logic_path2=" + file_logic_path2 + ", file_physic_path2=" + file_physic_path2
				+ ", file_size2=" + file_size2 + ", file_ext2=" + file_ext2 + "]";
	}



	
	
	
	
	
	
	
	
	
	
	
}
