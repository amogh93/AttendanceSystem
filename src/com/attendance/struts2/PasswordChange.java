package com.attendance.struts2;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;

import com.attendance.crypto.CryptoUtils;
import com.attendance.model.Employee;
import com.attendance.model.EmployeeLogin;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class PasswordChange extends ActionSupport {

	private String current_password;
	private String new_password;
	private String re_entered_password;

	public String getCurrent_password() {
		return current_password;
	}

	public void setCurrent_password(String current_password) {
		this.current_password = current_password;
	}

	public String getNew_password() {
		return new_password;
	}

	public void setNew_password(String new_password) {
		this.new_password = new_password;
	}

	public String getRe_entered_password() {
		return re_entered_password;
	}

	public void setRe_entered_password(String re_entered_password) {
		this.re_entered_password = re_entered_password;
	}

	public void validate() {
		if (StringUtils.isEmpty(current_password)) {
			addFieldError("errorField", "Please enter your existing password.");
		} else if (StringUtils.isEmpty(new_password)) {
			addFieldError("errorField", "Please enter new password.");
		} else if (StringUtils.isEmpty(re_entered_password)) {
			addFieldError("errorField", "Please re-enter new password.");
		} else if (!new_password.equals(re_entered_password)) {
			addFieldError("errorField", "New and re-entered Password does not match.");
		}
	}

	public String execute() {
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			Map sessionMap = (Map) ActionContext.getContext().get("session");
			Employee employee = (Employee) session.load(Employee.class, sessionMap.get("id").toString());

			DetachedCriteria criteria = DetachedCriteria.forClass(EmployeeLogin.class);
			criteria.add(Restrictions.eq("employee", employee));
			List list = criteria.getExecutableCriteria(session).list();
			if (list.size() > 0) {
				EmployeeLogin login = (EmployeeLogin) list.iterator().next();
				if (!current_password.equals(CryptoUtils.doDecrypt(login.getPassword()))) {
					addFieldError("errorField", "Wrong password entered.");
				} else {
					session.beginTransaction();
					login.setPassword(CryptoUtils.doEncrypt(new_password));
					session.update(login);
					session.flush();
					return "success";
				}
			}
		}
		addFieldError("errorField", "Failed to change the password.");
		return "failure";
	}

}
