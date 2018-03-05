package com.attendance.struts2;

import java.util.Calendar;
import java.util.Date;
import java.util.Map;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.attendance.model.Employee;
import com.attendance.model.LeaveSchedule;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class LeaveCancellation extends ActionSupport {

	private long id;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void validate() {

	}

	public String execute() {
		Map sessionMap = (Map) ActionContext.getContext().get("session");
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			Boolean status = false;
			System.out.println("in accept");
			session.beginTransaction();
			LeaveSchedule schedule = session.load(LeaveSchedule.class, id);

			Calendar from = Calendar.getInstance();
			Calendar to = Calendar.getInstance();

			from.setTime(schedule.getFrom_date());
			to.setTime(schedule.getTo_date());
			long days = ((to.getTimeInMillis() - from.getTimeInMillis()) / ((1000 * 60 * 60 * 24)));

			long total_days = days + 1;
			Employee e = schedule.getEmployee();
			if (schedule.getLeave_type().equalsIgnoreCase("cl")) {
				long cl = e.getLeave_count().getCl_count();
				if (total_days > 0) {
					status = true;
					if ((cl + total_days) > 14) {
						e.getLeave_count().setCl_count(14);
					} else if ((cl + total_days) <= 14) {
						e.getLeave_count().setCl_count(cl + total_days);
					}

				}
			} else if (schedule.getLeave_type().equalsIgnoreCase("pl")) {
				long pl = e.getLeave_count().getPl_count();
				if (total_days > 0) {
					status = true;
					if ((pl + total_days) > 40) {
						e.getLeave_count().setCl_count(40);
					} else if ((pl + total_days) <= 40) {
						e.getLeave_count().setCl_count(pl + total_days);
					}

				}
			} else if (schedule.getLeave_type().equalsIgnoreCase("sl")) {
				long sl = e.getLeave_count().getSl_count();
				if (total_days > 0) {
					status = true;
					if ((sl + total_days) > 25) {
						e.getLeave_count().setSl_count(25);
					} else if ((sl + total_days) <= 25) {
						e.getLeave_count().setSl_count(sl + total_days);
					}
				}
			}
			if (status) {
				schedule.setApproval_status("CANCELLED");
				schedule.setTime_of_approval(new Date());
				schedule.setApproved_by(sessionMap.get("empName").toString());
				session.save(schedule);
				session.getTransaction().commit();
				addActionMessage("Leave of " + schedule.getEmployee().getName() + " is cancelled.");
				return "success";
			}

		} catch (Exception e) {
			addFieldError("errorField", "Failed to cancel leave.");
		}
		return "failure";
	}

}
