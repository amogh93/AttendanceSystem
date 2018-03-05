package com.attendance.struts2;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.attendance.model.AccessLevel;
import com.attendance.model.BiometricTemplate;
import com.attendance.model.Employee;
import com.attendance.model.EmployeeLogin;
import com.opensymphony.xwork2.ActionSupport;

public class EmployeeDeletion extends ActionSupport {

	private String emp_id;

	public String getEmp_id() {
		return emp_id;
	}

	public void setEmp_id(String emp_id) {
		this.emp_id = emp_id;
	}

	public String execute() {
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			session.beginTransaction();
			Employee employee = (Employee) session.load(Employee.class, emp_id);
			EmployeeLogin login = (EmployeeLogin) employee.getEmployeeLogin();
			AccessLevel level = (AccessLevel) employee.getAccessLevel();
			session.delete(login);
			session.delete(level);
			session.delete(employee);
			session.flush();
			addActionMessage("Employee " + emp_id + " deleted successfully.");
		}
		return "success";
	}

}
