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

public class EntireLeaveReport extends ActionSupport {

	private String from_date;
	private String to_date;
	public InputStream stream;

	public InputStream getStream() {
		return stream;
	}

	public void setStream(InputStream stream) {
		this.stream = stream;
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

	public String execute() throws Exception {
		File file = null;
		boolean isReportGenerated = false;

		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		try {

			new LeaveReport().generateLeaveReportEntire(df.parse((from_date)), df.parse((to_date)));
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		file = new File(AppConfigInfo.getDefaultStorage() + "leave_report_all(" + from_date.toString() + " to "
				+ to_date.toString() + ").pdf");
		isReportGenerated = true;

		if (isReportGenerated) {
			stream = new DataInputStream(new FileInputStream(file));
			return "success";
		}
		return "failure";
	}

}
