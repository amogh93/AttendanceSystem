package com.attendance.struts2;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.attendance.model.Employee;
import com.opensymphony.xwork2.ActionSupport;

public class EditData extends ActionSupport {

	private String employee_id;
	private String emp_name;
	private String emp_mail;
	private String emp_mobile;

	public String getEmp_name() {
		return emp_name;
	}

	public void setEmp_name(String emp_name) {
		this.emp_name = emp_name;
	}

	public String getEmp_mail() {
		return emp_mail;
	}

	public void setEmp_mail(String emp_mail) {
		this.emp_mail = emp_mail;
	}

	public String getEmp_mobile() {
		return emp_mobile;
	}

	public void setEmp_mobile(String emp_mobile) {
		this.emp_mobile = emp_mobile;
	}

	public String getEmployee_id() {
		return employee_id;
	}

	public void setEmployee_id(String employee_id) {
		this.employee_id = employee_id;
	}

	public String execute() {
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			session.beginTransaction();
			Employee employee = (Employee) session.load(Employee.class, employee_id);
			employee.setContactNumber(emp_mobile);
			employee.setEmail(emp_mail);
			session.update(employee);
			session.getTransaction().commit();
			addActionMessage("Details updated successfully!");
			return "success";
		} catch (Exception e) {

		}
		return "failure";
	}

}
