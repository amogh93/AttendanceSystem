package com.attendance.struts2;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import com.attendance.config.AppConfigInfo;
import com.attendance.report.LeaveReport;
import com.opensymphony.xwork2.ActionSupport;

public class GenerateLeaveReport extends ActionSupport {

	private String from_date;
	private String to_date;
	public InputStream stream;
	private String particular_emp_id;
	private String emp_box = "false";

	public String getEmp_box() {
		return emp_box;
	}

	public void setEmp_box(String emp_box) {
		this.emp_box = emp_box;
	}

	public String getParticular_emp_id() {
		return particular_emp_id;
	}

	public void setParticular_emp_id(String particular_emp_id) {
		this.particular_emp_id = particular_emp_id;
	}

	public String getFrom_date() {
		return from_date;
	}

	public void setFrom_date(String from_date) {
		this.from_date = from_date;
	}

	public String getTo_date() {
		return to_date;
	}

	public void setTo_date(String to_date) {
		this.to_date = to_date;
	}

	public InputStream getStream() {
		return stream;
	}

	public void setStream(InputStream stream) {
		this.stream = stream;
	}

	public void validate() {
		if (from_date.toString().equals("") || from_date.toString().length() < 1) {
			addFieldError("errorField", "Please select from date.");
		} else if (to_date.toString().equals("") || to_date.toString().length() < 1) {
			addFieldError("errorField", "Please select to date.");
		}
	}

	public String execute() throws Exception {
		File file = null;
		boolean isReportGenerated = false;

		if (emp_box.equalsIgnoreCase("true")) {
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			try {
				new LeaveReport().generateLeaveReport(df.parse((from_date)), df.parse((to_date)), particular_emp_id);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			file = new File(AppConfigInfo.getDefaultStorage() + "leave_report(" + from_date.toString() + " to "
					+ to_date.toString() + ").pdf");
			isReportGenerated = true;
		}

		else {
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			try {
				new LeaveReport().generateLeaveReport(df.parse((from_date)), df.parse((to_date)), particular_emp_id);
			} catch (Exception ex) {

			}
			file = new File(AppConfigInfo.getDefaultStorage() + "leave_report(" + from_date.toString() + " to "
					+ to_date.toString() + ").pdf");
			isReportGenerated = true;
		}

		if (isReportGenerated) {
			stream = new DataInputStream(new FileInputStream(file));
			return "success";
		}
		return "failure";
	}
}
