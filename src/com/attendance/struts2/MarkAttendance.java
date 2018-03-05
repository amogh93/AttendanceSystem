package com.attendance.struts2;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import com.attendance.config.AppConfigInfo;
import com.attendance.crypto.CryptoUtils;
import com.attendance.date.DateFormatter;
import com.attendance.model.AttendanceEncrypted;
import com.attendance.model.Employee;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class MarkAttendance extends ActionSupport {

	private String entryType;
	private String date;

	public String getEntryType() {
		return entryType;
	}

	public void setEntryType(String entryType) {
		this.entryType = entryType;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String execute() {
		boolean status = false;
		Map sessionMap = (Map) ActionContext.getContext().get("session");

		SessionFactory sessionFactory = (new Configuration()).configure().buildSessionFactory();
		Session session = sessionFactory.openSession();
		session.beginTransaction();
		try {
			Employee employee = (Employee) session.get(Employee.class, sessionMap.get("id").toString());
			AttendanceEncrypted attendance = new AttendanceEncrypted();
			if (entryType.equalsIgnoreCase("intime")) {
				attendance.setDate(new Date());
				attendance.setIn_time(CryptoUtils.doEncrypt(DateFormatter.getFormattedTime(new Date())));
				attendance.setStatus("N");
				attendance.setIn_logging_mode("EMP_LOGIN");
				attendance.setOut_logging_mode("-");
				attendance.setEmployee(employee);
				session.save(attendance);
				session.getTransaction().commit();
				status = true;
				session.close();
			} else if (entryType.equalsIgnoreCase("outtime")) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				String dt = sdf.format(new Date());
				Date date = sdf.parse(dt);

				DetachedCriteria criteria = DetachedCriteria.forClass(AttendanceEncrypted.class);
				criteria.add(Restrictions.eq("date", date));
				criteria.add(Restrictions.eq("employee", employee));
				criteria.addOrder(Order.desc("id"));
				List atten_list = criteria.getExecutableCriteria(session).setMaxResults(1).list();

				if (atten_list.size() > 0) {
					AttendanceEncrypted a = (AttendanceEncrypted) atten_list.iterator().next();
					if (a.getOut_time().toString().equals("00:00:00")) {
						a.setOut_time(CryptoUtils.doEncrypt(DateFormatter.getFormattedTime(new Date())));
						a.setOut_logging_mode("EMP_LOGIN");
						session.update(a);
						session.getTransaction().commit();
						status = true;
						session.close();
					} else {
						session.close();
						addFieldError("errorField", "You have already marked your out time for today.");
					}
				} else {
					session.close();
					addFieldError("errorField", "You have not marked your in time for today.");
				}
			}
		} catch (Exception exception) {
		}
		if (status) {
			return "success";
		} else {
			return "failure";
		}

	}

}
