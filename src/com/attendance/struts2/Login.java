package com.attendance.struts2;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.interceptor.SessionAware;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;

import com.attendance.config.AppConfigInfo;
import com.attendance.crypto.CryptoUtils;
import com.attendance.login.CheckLoginCredentials;
import com.attendance.model.EmployeeLogin;
import com.opensymphony.xwork2.ActionSupport;

public class Login extends ActionSupport implements SessionAware {

	private Map<String, Object> sessionMap;
	private String userId;
	private String password;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Override
	public void setSession(Map<String, Object> sessionMap) {
		this.sessionMap = sessionMap;
	}

	public void validate() {
		if (StringUtils.isEmpty(userId)) {
			addFieldError("errorField", "Please enter username.");
		}

		else if (StringUtils.isEmpty(password)) {
			addFieldError("errorField", "Please enter password.");
		}

		else if (!CheckLoginCredentials.isAuthenticateUser(userId, password)) {
			addFieldError("errorField", "Wrong User ID or Password");
		}

	}

	public String execute() {
		if (sessionMap.containsKey("id")) {
			return "success";
		}

		if (userId.equals(AppConfigInfo.getUserName())
				&& password.equals(CryptoUtils.doDecrypt(AppConfigInfo.getPassword()))) {
			sessionMap.put("id", "Admin_0");
			sessionMap.put("empName", "Admin");
			sessionMap.put("lastLogin", new Date());
			sessionMap.put("access", "FULL");
			return "success";
		}

		try (SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
				Session session = sessionFactory.openSession()) {
			session.beginTransaction();
			DetachedCriteria detachedCriteria = DetachedCriteria.forClass(EmployeeLogin.class);
			detachedCriteria.add(Restrictions.eq("userName", userId));
			detachedCriteria.add(Restrictions.eq("password", CryptoUtils.doEncrypt(password)));
			List result = detachedCriteria.getExecutableCriteria(session).list();
			EmployeeLogin login = (EmployeeLogin) result.iterator().next();
			if (result.size() > 0) {
				sessionMap.put("id", login.getEmployee().getId());
				sessionMap.put("empName", login.getEmployee().getName());
				sessionMap.put("lastLogin", login.getLast_login());
				sessionMap.put("access", login.getEmployee().getAccessLevel().getAccessLevel());
				sessionMap.put("department", login.getEmployee().getDepartment().getDepartment_name());
				login.setLast_login(new Date());
				session.update(login);
				session.getTransaction().commit();
				return "success";
			}
			return "failure";
		}
	}
}
