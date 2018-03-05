package com.attendance.report;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.attendance.config.AppConfigInfo;
import com.attendance.model.Department;
import com.attendance.model.Employee;
import com.attendance.model.LeaveSchedule;
import com.itextpdf.kernel.color.Color;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.property.TextAlignment;

public class LeaveReport {

	private static final float FONT_SIZE = 10;
	private boolean isPrintHeader = true;

	public void generateLeaveReport(Date from_date, Date to_date, String emp_id) throws Exception {
		SimpleDateFormat date_format = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat time_format = new SimpleDateFormat("HH:mm:ss");
		String dest = AppConfigInfo.getDefaultStorage() + "leave_report(" + date_format.format(from_date) + " to "
				+ date_format.format(to_date) + ").pdf";
		String[] table_heading = { "Name", "From date", "To date", "Description", "Type", "Status" };

		PdfDocument pdfDoc = new PdfDocument(new PdfWriter(dest));
		Document doc = new Document(pdfDoc);

		try (SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
				Session session = sessionFactory.openSession()) {
			Employee employee = (Employee) session.load(Employee.class, emp_id);
			DetachedCriteria criteria = DetachedCriteria.forClass(LeaveSchedule.class);
			criteria.add(Restrictions.eq("employee", employee));
			criteria.addOrder(Order.asc("id"));
			List leave_list = criteria.getExecutableCriteria(session).list();
			if (leave_list.size() > 0) {
				Table table = new Table(6);

				Iterator itr = leave_list.iterator();
				while (itr.hasNext()) {
					LeaveSchedule schedule = (LeaveSchedule) itr.next();
					if (schedule.getFrom_date().compareTo(from_date) >= 0
							&& schedule.getTo_date().compareTo(to_date) <= 0) {
						if (isPrintHeader) {
							Paragraph p = new Paragraph();
							p.setFontSize(FONT_SIZE);
							p.setUnderline();
							p.add("Employee ID: " + employee.getId());
							doc.add(p);
							Cell heading;
							for (int i = 0; i < 6; i++) {
								heading = new Cell();
								heading.setTextAlignment(TextAlignment.CENTER);
								heading.setFontSize(FONT_SIZE);
								heading.setFontColor(Color.WHITE);
								heading.setBackgroundColor(Color.GRAY, 20);
								heading.add(new Paragraph(table_heading[i]));
								table.addCell(heading);
							}
							isPrintHeader = false;
						}
						Cell nameCell = new Cell();
						nameCell.setTextAlignment(TextAlignment.CENTER);
						nameCell.setFontSize(FONT_SIZE);
						nameCell.add(employee.getName());
						table.addCell(nameCell);

						Cell fromCell = new Cell();
						fromCell.setTextAlignment(TextAlignment.CENTER);
						fromCell.setFontSize(FONT_SIZE);
						fromCell.add(schedule.getFrom_date().toString());
						table.addCell(fromCell);

						Cell toCell = new Cell();
						toCell.setTextAlignment(TextAlignment.CENTER);
						toCell.setFontSize(FONT_SIZE);
						toCell.add(schedule.getTo_date().toString());
						table.addCell(toCell);

						Cell desc = new Cell();
						desc.setTextAlignment(TextAlignment.CENTER);
						desc.setFontSize(FONT_SIZE);
						desc.add(schedule.getDescription());
						table.addCell(desc);

						Cell type = new Cell();
						type.setTextAlignment(TextAlignment.CENTER);
						type.setFontSize(FONT_SIZE);
						type.add(schedule.getLeave_type());
						table.addCell(type);

						Cell status = new Cell();
						status.setTextAlignment(TextAlignment.CENTER);
						status.setFontSize(FONT_SIZE);
						status.add(schedule.getApproval_status() + " BY " + schedule.getApproved_by() + " ON "
								+ schedule.getTime_of_approval().toString());
						table.addCell(status);
					}

				}
				doc.add(table);
				Paragraph p = new Paragraph();
				p.setFontSize(FONT_SIZE);
				p.setUnderline();
				p.add("Remaining leaves: CL- " + employee.getLeave_count().getCl_count() + ", PL-"
						+ employee.getLeave_count().getPl_count() + ", SL-" + employee.getLeave_count().getSl_count());
				doc.add(p);
				doc.close();
			}
		}
	}

	public void generateLeaveReportDeptWise(Date from_date, Date to_date, String deptname) throws Exception {
		SimpleDateFormat date_format = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat time_format = new SimpleDateFormat("HH:mm:ss");
		String dest = AppConfigInfo.getDefaultStorage() + "leave_report_[" + deptname + "]("
				+ date_format.format(from_date) + " to " + date_format.format(to_date) + ").pdf";
		String[] table_heading = { "Name", "From date", "To date", "Description", "Type", "Status" };

		PdfDocument pdfDoc = new PdfDocument(new PdfWriter(dest));
		Document doc = new Document(pdfDoc);

		try (SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
				Session session = sessionFactory.openSession()) {
			DetachedCriteria criteria1 = DetachedCriteria.forClass(Department.class);
			criteria1.add(Restrictions.eq("department_name", deptname));
			List dept_list = criteria1.getExecutableCriteria(session).list();
			if (dept_list.size() > 0) {
				Department dept = (Department) dept_list.iterator().next();

				Set emp_list = dept.getEmployee();
				if (emp_list.size() > 0) {
					Iterator emp_itr = emp_list.iterator();
					while (emp_itr.hasNext()) {
						Table table = new Table(6);
						Employee emp = (Employee) emp_itr.next();
						DetachedCriteria criteria = DetachedCriteria.forClass(LeaveSchedule.class);
						criteria.add(Restrictions.eq("employee", emp));
						criteria.addOrder(Order.asc("id"));
						List leave_list = criteria.getExecutableCriteria(session).list();
						if (leave_list.size() > 0) {
							Iterator itr = leave_list.iterator();
							while (itr.hasNext()) {
								LeaveSchedule schedule = (LeaveSchedule) itr.next();
								if (schedule.getFrom_date().compareTo(from_date) >= 0
										&& schedule.getTo_date().compareTo(to_date) <= 0) {
									if (isPrintHeader) {
										Paragraph p = new Paragraph();
										p.setFontSize(FONT_SIZE);
										p.setUnderline();
										p.add("Employee ID: " + emp.getId());
										doc.add(p);
										Cell heading;
										for (int i = 0; i < 6; i++) {
											heading = new Cell();
											heading.setTextAlignment(TextAlignment.CENTER);
											heading.setFontSize(FONT_SIZE);
											heading.setFontColor(Color.WHITE);
											heading.setBackgroundColor(Color.GRAY, 20);
											heading.add(new Paragraph(table_heading[i]));
											table.addCell(heading);
										}
										isPrintHeader = false;
									}
									Cell nameCell = new Cell();
									nameCell.setTextAlignment(TextAlignment.CENTER);
									nameCell.setFontSize(FONT_SIZE);
									nameCell.add(emp.getName());
									table.addCell(nameCell);

									Cell fromCell = new Cell();
									fromCell.setTextAlignment(TextAlignment.CENTER);
									fromCell.setFontSize(FONT_SIZE);
									fromCell.add(schedule.getFrom_date().toString());
									table.addCell(fromCell);

									Cell toCell = new Cell();
									toCell.setTextAlignment(TextAlignment.CENTER);
									toCell.setFontSize(FONT_SIZE);
									toCell.add(schedule.getTo_date().toString());
									table.addCell(toCell);

									Cell desc = new Cell();
									desc.setTextAlignment(TextAlignment.CENTER);
									desc.setFontSize(FONT_SIZE);
									desc.add(schedule.getDescription());
									table.addCell(desc);

									Cell type = new Cell();
									type.setTextAlignment(TextAlignment.CENTER);
									type.setFontSize(FONT_SIZE);
									type.add(schedule.getLeave_type());
									table.addCell(type);

									Cell status = new Cell();
									status.setTextAlignment(TextAlignment.CENTER);
									status.setFontSize(FONT_SIZE);
									status.add(schedule.getApproval_status() + " BY " + schedule.getApproved_by()
											+ " ON " + schedule.getTime_of_approval().toString());
									table.addCell(status);

								}

							}
							doc.add(table);

						}
						isPrintHeader = true;
					}
				}
				doc.close();

			}
		}

	}

	public void generateLeaveReportEntire(Date from_date, Date to_date) throws Exception {
		SimpleDateFormat date_format = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat time_format = new SimpleDateFormat("HH:mm:ss");
		String dest = AppConfigInfo.getDefaultStorage() + "leave_report_all(" + date_format.format(from_date) + " to "
				+ date_format.format(to_date) + ").pdf";
		String[] table_heading = { "Name", "From date", "To date", "Description", "Type", "Status" };

		PdfDocument pdfDoc = new PdfDocument(new PdfWriter(dest));
		Document doc = new Document(pdfDoc);

		try (SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
				Session session = sessionFactory.openSession()) {
			DetachedCriteria criteria1 = DetachedCriteria.forClass(Employee.class);
			List emp_list = criteria1.getExecutableCriteria(session).list();

			if (emp_list.size() > 0) {
				Iterator emp_itr = emp_list.iterator();
				while (emp_itr.hasNext()) {
					Table table = new Table(6);
					Employee emp = (Employee) emp_itr.next();
					DetachedCriteria criteria = DetachedCriteria.forClass(LeaveSchedule.class);
					criteria.add(Restrictions.eq("employee", emp));
					criteria.addOrder(Order.asc("id"));
					List leave_list = criteria.getExecutableCriteria(session).list();
					if (leave_list.size() > 0) {
						Iterator itr = leave_list.iterator();
						while (itr.hasNext()) {
							LeaveSchedule schedule = (LeaveSchedule) itr.next();
							if (schedule.getFrom_date().compareTo(from_date) >= 0
									&& schedule.getTo_date().compareTo(to_date) <= 0) {
								if (isPrintHeader) {
									Paragraph p = new Paragraph();
									p.setFontSize(FONT_SIZE);
									p.setUnderline();
									p.add("Employee ID: " + emp.getId());
									doc.add(p);
									Cell heading;
									for (int i = 0; i < 6; i++) {
										heading = new Cell();
										heading.setTextAlignment(TextAlignment.CENTER);
										heading.setFontSize(FONT_SIZE);
										heading.setFontColor(Color.WHITE);
										heading.setBackgroundColor(Color.GRAY, 20);
										heading.add(new Paragraph(table_heading[i]));
										table.addCell(heading);
									}
									isPrintHeader = false;
								}
								Cell nameCell = new Cell();
								nameCell.setTextAlignment(TextAlignment.CENTER);
								nameCell.setFontSize(FONT_SIZE);
								nameCell.add(emp.getName());
								table.addCell(nameCell);

								Cell fromCell = new Cell();
								fromCell.setTextAlignment(TextAlignment.CENTER);
								fromCell.setFontSize(FONT_SIZE);
								fromCell.add(schedule.getFrom_date().toString());
								table.addCell(fromCell);

								Cell toCell = new Cell();
								toCell.setTextAlignment(TextAlignment.CENTER);
								toCell.setFontSize(FONT_SIZE);
								toCell.add(schedule.getTo_date().toString());
								table.addCell(toCell);

								Cell desc = new Cell();
								desc.setTextAlignment(TextAlignment.CENTER);
								desc.setFontSize(FONT_SIZE);
								desc.add(schedule.getDescription());
								table.addCell(desc);

								Cell type = new Cell();
								type.setTextAlignment(TextAlignment.CENTER);
								type.setFontSize(FONT_SIZE);
								type.add(schedule.getLeave_type());
								table.addCell(type);

								Cell status = new Cell();
								status.setTextAlignment(TextAlignment.CENTER);
								status.setFontSize(FONT_SIZE);
								status.add(schedule.getApproval_status() + " BY " + schedule.getApproved_by() + " ON "
										+ schedule.getTime_of_approval().toString());
								table.addCell(status);

							}

						}
						doc.add(table);
						Paragraph p = new Paragraph();
						p.setFontSize(FONT_SIZE);
						p.setUnderline();
						p.add("Remaining leaves: CL- " + emp.getLeave_count().getCl_count() + ", PL-"
								+ emp.getLeave_count().getPl_count() + ", SL-" + emp.getLeave_count().getSl_count());
						doc.add(p);
					}
					isPrintHeader = true;
				}
			}
			doc.close();
		}
	}

	public static void main(String[] args) throws Exception {
		SimpleDateFormat date_format = new SimpleDateFormat("yyyy-MM-dd");
		new LeaveReport().generateLeaveReport(date_format.parse("2017-06-01"), date_format.parse("2017-06-30"), "1001");
		new LeaveReport().generateLeaveReportDeptWise(date_format.parse("2017-06-01"), date_format.parse("2017-06-30"),
				"IT");
		new LeaveReport().generateLeaveReportEntire(date_format.parse("2017-06-01"), date_format.parse("2017-06-30"));
	}

}
