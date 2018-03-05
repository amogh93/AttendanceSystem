package com.attendance.login;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import com.attendance.config.AppConfigInfo;
import com.attendance.crypto.CryptoUtils;
import com.attendance.model.EmployeeLogin;

public class CheckLoginCredentials {

	public static boolean isAuthenticateUser(String user_id, String password) {
		if (user_id.equals(AppConfigInfo.getUserName())
				&& password.equals(CryptoUtils.doDecrypt(AppConfigInfo.getPassword()))) {
			return true;
		}

		try (SessionFactory sessionFactory = (new Configuration()).configure().buildSessionFactory();
				Session session = sessionFactory.openSession();) {
			DetachedCriteria detachedCriteria = DetachedCriteria.forClass(EmployeeLogin.class);
			detachedCriteria.add(Restrictions.eq("userName", user_id));
			detachedCriteria.add(Restrictions.eq("password", CryptoUtils.doEncrypt(password)));
			detachedCriteria.setProjection(Projections.property("userName"));
			detachedCriteria.setProjection(Projections.property("password"));
			List result = detachedCriteria.getExecutableCriteria(session).list();
			if (result.size() <= 0) {
				return false;
			}
			return true;
		}
	}
}
