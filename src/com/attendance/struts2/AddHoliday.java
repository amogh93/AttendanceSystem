package com.attendance.struts2;

import java.text.SimpleDateFormat;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.attendance.model.HolidayMaster;
import com.opensymphony.xwork2.ActionSupport;

public class AddHoliday extends ActionSupport {

	private String holiday_date;
	private String holiday_description;
	private String holiday_type;

	public String getHoliday_date() {
		return holiday_date;
	}

	public void setHoliday_date(String holiday_date) {
		this.holiday_date = holiday_date;
	}

	public String getHoliday_description() {
		return holiday_description;
	}

	public void setHoliday_description(String holiday_description) {
		this.holiday_description = holiday_description;
	}

	public String getHoliday_type() {
		return holiday_type;
	}

	public void setHoliday_type(String holiday_type) {
		this.holiday_type = holiday_type;
	}

	public void validate() {
		if (holiday_date.equals("")) {
			addFieldError("errorField", "Please select holiday date.");
		} else if (holiday_description.equals("")) {
			addFieldError("errorField", "Please enter holiday description.");
		} else if (holiday_type.equalsIgnoreCase("none")) {
			addFieldError("errorField", "Please select holiday type.");
		}
	}

	public String execute() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			session.beginTransaction();
			System.out.println(holiday_date.toString());
			HolidayMaster holidayMaster = new HolidayMaster();
			holidayMaster.setDate(sdf.parse(sdf.format(sdf.parse(holiday_date))));
			holidayMaster.setDescription(holiday_description);
			holidayMaster.setType(holiday_type);
			session.save(holidayMaster);
			session.getTransaction().commit();
			addActionMessage("Holiday added successfully!");
			return "success";
		} catch (Exception e) {
			addFieldError("errorField", "Failed to add holiday, please try later.");
		}
		return "failure";
	}

}
