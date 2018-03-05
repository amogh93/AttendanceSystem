package com.attendance.struts2;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import com.attendance.model.Attendance;
import com.attendance.model.Employee;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class BackDatedAttendanceMarking extends ActionSupport {

	private String particular_emp_id;
	private String date;
	private String time;
	private String entryType;
	private String override_attendance = "false";

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getOverride_attendance() {
		return override_attendance;
	}

	public void setOverride_attendance(String override_attendance) {
		this.override_attendance = override_attendance;
	}

	public String getParticular_emp_id() {
		return particular_emp_id;
	}

	public void setParticular_emp_id(String particular_emp_id) {
		this.particular_emp_id = particular_emp_id;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getEntryType() {
		return entryType;
	}

	public void setEntryType(String entryType) {
		this.entryType = entryType;
	}

	public String execute() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdt = new SimpleDateFormat("HH:mm:ss");
		boolean status = false;

		Map sessionMap = (Map) ActionContext.getContext().get("session");

		try (SessionFactory sessionFactory = (new Configuration()).configure().buildSessionFactory();
				Session session = sessionFactory.openSession();) {
			session.beginTransaction();

			Employee employee = (Employee) session.load(Employee.class, particular_emp_id);

			if (entryType.equalsIgnoreCase("intime")) {

				DetachedCriteria criteria = DetachedCriteria.forClass(Attendance.class);
				criteria.add(Restrictions.eq("date", sdf.parse(date)));
				criteria.add(Restrictions.eq("employee", employee));
				criteria.addOrder(Order.desc("id"));
				List attn_list = criteria.getExecutableCriteria(session).list();

				if (attn_list.size() > 0) {
					if (override_attendance.equalsIgnoreCase("true")) {
						Iterator itr = attn_list.iterator();
						while (itr.hasNext()) {
							Attendance a = (Attendance) itr.next();
							session.delete(a);
						}
						Attendance attendance = new Attendance();
						attendance.setDate(sdf.parse(date));
						attendance.setIn_time(sdt.parse(time));
						attendance.setStatus("N");
						attendance.setIn_logging_mode("ADMIN_LOGIN");
						attendance.setOut_logging_mode("-");
						attendance.setEmployee(employee);
						session.save(attendance);
						session.getTransaction().commit();
						status = true;
						addActionMessage("Caution! In-time overridden!");
					} else {
						addFieldError("errorField", "In-time already exists.");
					}
				} else {
					Attendance attendance = new Attendance();
					attendance.setDate(sdf.parse(date));
					attendance.setIn_time(sdt.parse(time));
					attendance.setStatus("N");
					attendance.setIn_logging_mode("ADMIN_LOGIN");
					attendance.setOut_logging_mode("-");
					attendance.setEmployee(employee);
					session.save(attendance);
					session.getTransaction().commit();
					status = true;
					addActionMessage("In-time marked!");
				}
			} else if (entryType.equalsIgnoreCase("outtime")) {
				DetachedCriteria criteria = DetachedCriteria.forClass(Attendance.class);
				criteria.add(Restrictions.eq("date", sdf.parse(date)));
				criteria.add(Restrictions.eq("employee", employee));
				criteria.addOrder(Order.desc("id"));
				List attn_list = criteria.getExecutableCriteria(session).setMaxResults(1).list();

				if (attn_list.size() > 0) {
					Attendance attendance = (Attendance) attn_list.iterator().next();

					if (override_attendance.equalsIgnoreCase("true")) {
						if (attendance.getIn_time().compareTo(sdt.parse(time)) > 0) {
							addFieldError("errorField", "Out-time less than in-time");
						} else {
							String message = "";
							if (attendance.getOut_time().toString().equals("00:00:00")) {
								message = "Out-time marked.";
							} else {
								message = "Caution! Out-time overridden.";
							}

							attendance.setOut_time(sdt.parse(time));
							attendance.setOut_logging_mode("ADMIN_LOGIN");
							session.update(attendance);
							session.flush();
							status = true;
							addActionMessage(message);
						}
					} else if (!override_attendance.equalsIgnoreCase("true")) {
						if (attendance.getOut_time().toString().equals("00:00:00")) {
							if (attendance.getIn_time().compareTo(sdt.parse(time)) > 0) {
								addFieldError("errorField", "Out-time less than in-time");
							} else {
								attendance.setOut_time(sdt.parse(time));
								attendance.setOut_logging_mode("ADMIN_LOGIN");
								session.update(attendance);
								session.flush();
								status = true;
								addActionMessage("Out-time marked!");
							}

						} else {
							addFieldError("errorField", "Out-time already exists.");
						}
					}
				} else {
					addFieldError("errorField", "Marking out-time without in-time.");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (status) {
			return "success";
		} else {
			return "failure";
		}
	}
}
