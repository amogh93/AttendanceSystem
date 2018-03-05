package com.attendance.report;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;

import com.attendance.model.Employee;
import com.attendance.model.HolidayMaster;
import com.attendance.model.LeaveSchedule;

public class CheckHolidayAndLeaves {

	public static boolean isHoliday(Date holiday_date) {
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			session.beginTransaction();
			DetachedCriteria criteria = DetachedCriteria.forClass(HolidayMaster.class);
			criteria.add(Restrictions.eq("date", holiday_date));
			List holiday_list = criteria.getExecutableCriteria(session).list();
			if (holiday_list.size() > 0) {
				return true;
			}
			return false;
		}
	}

	public static String getHoliday(Date holiday_date) {
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			session.beginTransaction();
			DetachedCriteria criteria = DetachedCriteria.forClass(HolidayMaster.class);
			criteria.add(Restrictions.eq("date", holiday_date));
			List holiday_list = criteria.getExecutableCriteria(session).list();
			if (holiday_list.size() > 0) {
				Iterator itr = holiday_list.iterator();
				HolidayMaster master = (HolidayMaster) itr.next();
				return master.getDescription();
			}
			return "N/A";
		}
	}

	public static boolean isOnLeave(Employee employee, Date date) {
		boolean leave = false;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			session.beginTransaction();
			Set<LeaveSchedule> leave_set = employee.getSchedule();
			if (leave_set.size() > 0) {
				Iterator itr = leave_set.iterator();
				while (itr.hasNext()) {
					LeaveSchedule schedule = (LeaveSchedule) itr.next();
					if (schedule.getApproval_status().equalsIgnoreCase("approved")) {
						if (date.compareTo(schedule.getFrom_date()) >= 0
								&& date.compareTo(schedule.getTo_date()) <= 0) {
							leave = true;
							break;
						}
					}
				}
			}
			return leave;
		}
	}
}
