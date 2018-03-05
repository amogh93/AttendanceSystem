package com.attendance.struts2;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import com.attendance.model.Attendance;
import com.attendance.model.Employee;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class LogAttendance extends ActionSupport {

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
			Attendance attendance = new Attendance();
			if (entryType.equalsIgnoreCase("intime")) {
				attendance.setDate(new Date());
				attendance.setIn_time(new Date());
				attendance.setStatus("N");
				attendance.setIn_logging_mode("EMP_LOGIN");
				attendance.setOut_logging_mode("-");
				attendance.setEmployee(employee);
				session.save(attendance);
				session.getTransaction().commit();
				status = true;
				session.close();
				addActionMessage("In-time marked!");
			} else if (entryType.equalsIgnoreCase("outtime")) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				String dt = sdf.format(new Date());
				Date date = sdf.parse(dt);
				Query query = session
						.createQuery("from Attendance where employee_id=:id and date=:date order by id desc");
				query.setParameter("id", sessionMap.get("id").toString());
				query.setParameter("date", date);
				query.setMaxResults(1);
				if (query.getResultList().size() > 0) {
					Attendance a = (Attendance) query.getResultList().iterator().next();
					if (a.getOut_time().toString().equals("00:00:00")) {
						a.setOut_time(new Date());
						a.setOut_logging_mode("EMP_LOGIN");
						session.update(a);
						session.getTransaction().commit();
						status = true;
						session.close();
						addActionMessage("Out-time marked!");
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
