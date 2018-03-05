package com.attendance.struts2;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.attendance.config.AppConfigInfo;
import com.attendance.model.Employee;
import com.attendance.report.GenerateReport;
import com.attendance.report.ReportGenerator;
import com.opensymphony.xwork2.ActionSupport;

public class Generate extends ActionSupport {

	private Date from_date;
	private Date to_date;
	private String report_type;
	private String emp_box = "false";
	private String particular_emp_id;
	public InputStream stream;

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

	public InputStream getStream() {
		return stream;
	}

	public void setStream(InputStream stream) {
		this.stream = stream;
	}

	public Date getFrom_date() {
		return from_date;
	}

	public void setFrom_date(Date from_date) {
		this.from_date = from_date;
	}

	public Date getTo_date() {
		return to_date;
	}

	public void setTo_date(Date to_date) {
		this.to_date = to_date;
	}

	public String getReport_type() {
		return report_type;
	}

	public void setReport_type(String report_type) {
		this.report_type = report_type;
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
			try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
					Session session = factory.openSession()) {
				Employee employee = (Employee) session.load(Employee.class, particular_emp_id);
				if (report_type.equalsIgnoreCase("detailed")) {
					DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					DateFormat df1 = new SimpleDateFormat("dd-MMM-yyyy");
					ReportGenerator.generateReport(df.parse(df.format(from_date)), df.parse(df.format(to_date)),
							employee, session);
					file = new File(
							AppConfigInfo.getDefaultStorage() + "(" + employee.getId() + ")attendance_report_detailed("
									+ df1.format(from_date) + " to " + df1.format(to_date) + ").pdf");
					isReportGenerated = true;
				} else if (report_type.equalsIgnoreCase("summarized")) {
					DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					DateFormat df1 = new SimpleDateFormat("dd-MMM-yyyy");
					GenerateReport.getReport(df.parse(df.format(from_date)), df.parse(df.format(to_date)), employee,
							session);
					file = new File(AppConfigInfo.getDefaultStorage() + "(" + employee.getId()
							+ ")attendance_report_summarized(" + df1.format(from_date) + " to " + df1.format(to_date)
							+ ").pdf");
					isReportGenerated = true;
				}
			}
		} else {
			if (report_type.equalsIgnoreCase("detailed")) {
				DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				ReportGenerator.generateReport(df.parse(df.format(from_date)), df.parse(df.format(to_date)));
				file = new File(AppConfigInfo.getDefaultStorage() + "attendance_report_detailed(" + df.format(from_date)
						+ " to " + df.format(to_date) + ").pdf");
				isReportGenerated = true;
			} else if (report_type.equalsIgnoreCase("summarized")) {
				DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				GenerateReport.getReport(df.parse(df.format(from_date)), df.parse(df.format(to_date)));
				file = new File(AppConfigInfo.getDefaultStorage() + "attendance_report_summarized("
						+ df.format(from_date) + " to " + df.format(to_date) + ").pdf");
				isReportGenerated = true;
			}
		}

		if (isReportGenerated) {
			stream = new DataInputStream(new FileInputStream(file));
			return "success";
		}
		return "failure";
	}

}
