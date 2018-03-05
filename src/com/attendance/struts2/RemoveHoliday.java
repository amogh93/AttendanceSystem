package com.attendance.struts2;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.attendance.model.HolidayMaster;
import com.opensymphony.xwork2.ActionSupport;

public class RemoveHoliday extends ActionSupport {

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
			HolidayMaster holidayMaster = session.load(HolidayMaster.class, Long.valueOf(id));
			String holiday_name = holidayMaster.getDescription();
			session.delete(holidayMaster);
			session.getTransaction().commit();
			addActionMessage("Holiday for " + holiday_name + " is removed");
			return "success";
		}
	}

}
