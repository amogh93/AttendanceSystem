package com.attendance.struts2;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;

import com.attendance.crypto.CryptoUtils;
import com.attendance.model.Employee;
import com.attendance.model.EmployeeLogin;
import com.opensymphony.xwork2.ActionSupport;

public class ResetEmployeePassword extends ActionSupport {

	private String id;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String execute() {
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			session.beginTransaction();
			Employee employee = (Employee) session.load(Employee.class, id);

			DetachedCriteria criteria = DetachedCriteria.forClass(EmployeeLogin.class);
			criteria.add(Restrictions.eq("employee", employee));

			EmployeeLogin login = (EmployeeLogin) criteria.getExecutableCriteria(session).list().iterator().next();

			login.setPassword(CryptoUtils.doEncrypt("password"));

			session.update(login);
			session.getTransaction().commit();
			addActionMessage("Password reset done for username: " + employee.getEmployeeLogin().getUserName());
			return "success";
		} catch (Exception e) {
			addFieldError("errorField", "Failed to reset password.");
		}
		return "failure";
	}

}
