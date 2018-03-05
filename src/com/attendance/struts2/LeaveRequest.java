package com.attendance.struts2;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.attendance.model.Employee;
import com.attendance.model.LeaveSchedule;
import com.attendance.model.LeavesRemaining;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class LeaveRequest extends ActionSupport {

	private String from_date;
	private String to_date;
	private String leave_type;
	private String description;

	public String getFrom_date() {
		return from_date;
	}

	public void setFrom_date(String from_date) {
		this.from_date = from_date;
	}

	public String getTo_date() {
		return to_date;
	}

	public void setTo_date(String to_date) {
		this.to_date = to_date;
	}

	public String getLeave_type() {
		return leave_type;
	}

	public void setLeave_type(String leave_type) {
		this.leave_type = leave_type;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void validate() {
		Map sessionMap = (Map) ActionContext.getContext().get("session");
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar from = Calendar.getInstance();
			Calendar to = Calendar.getInstance();

			from.setTime(sdf.parse(from_date));
			to.setTime(sdf.parse(to_date));
			long days = ((to.getTimeInMillis() - from.getTimeInMillis()) / ((1000 * 60 * 60 * 24)));

			long total_days = days + 1;
			Employee employee = (Employee) session.load(Employee.class, sessionMap.get("id").toString());
			if (leave_type.equalsIgnoreCase("cl")) {
				long cl = employee.getLeave_count().getCl_count();
				if (cl < total_days) {
					addFieldError("errorField", "You do not have sufficient amount of CL");
				}
			} else if (leave_type.equalsIgnoreCase("pl")) {
				long pl = employee.getLeave_count().getPl_count();
				if (total_days >= 15) {
					if (pl < total_days) {
						addFieldError("errorField", "You do not have sufficient amount of PL");
					}
				} else {
					addFieldError("errorField", "Minimum PL should be 15 days or more");
				}

			} else if (leave_type.equalsIgnoreCase("sl")) {
				long sl = employee.getLeave_count().getSl_count();
				if (sl < total_days) {
					addFieldError("errorField", "You do not have sufficient amount of SL");
				}
			}

		} catch (Exception e) {

		}
	}

	public String execute() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Map sessionMap = (Map) ActionContext.getContext().get("session");
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			session.beginTransaction();

			Employee employee = (Employee) session.load(Employee.class, sessionMap.get("id").toString());
			System.out.println(employee.getName());

			LeaveSchedule schedule = new LeaveSchedule();
			schedule.setApproval_status("PENDING");
			schedule.setDescription(description);
			schedule.setFrom_date(sdf.parse(from_date));
			schedule.setTo_date(sdf.parse(to_date));
			schedule.setLeave_type(leave_type);
			schedule.setTime_of_request(new Date());
			schedule.setEmployee(employee);
			employee.getSchedule().add(schedule);
			session.save(schedule);
			session.getTransaction().commit();
			addActionMessage("Leave request sent for approval!");
			return "success";
		} catch (Exception e) {

		}
		return "failure";
	}

}
