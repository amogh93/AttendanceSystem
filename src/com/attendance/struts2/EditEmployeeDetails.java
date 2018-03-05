package com.attendance.struts2;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;

import com.attendance.model.AccessLevel;
import com.attendance.model.Department;
import com.attendance.model.Employee;
import com.opensymphony.xwork2.ActionSupport;

public class EditEmployeeDetails extends ActionSupport {

	private String employee_id;
	private String emp_name;
	private String emp_mobile;
	private String emp_mail;
	private String emp_access_level;
	private String emp_department;

	public String getEmployee_id() {
		return employee_id;
	}

	public void setEmployee_id(String employee_id) {
		this.employee_id = employee_id;
	}

	public String getEmp_name() {
		return emp_name;
	}

	public void setEmp_name(String emp_name) {
		this.emp_name = emp_name;
	}

	public String getEmp_mobile() {
		return emp_mobile;
	}

	public void setEmp_mobile(String emp_mobile) {
		this.emp_mobile = emp_mobile;
	}

	public String getEmp_mail() {
		return emp_mail;
	}

	public void setEmp_mail(String emp_mail) {
		this.emp_mail = emp_mail;
	}

	public String getEmp_access_level() {
		return emp_access_level;
	}

	public void setEmp_access_level(String emp_access_level) {
		this.emp_access_level = emp_access_level;
	}

	public String getEmp_department() {
		return emp_department;
	}

	public void setEmp_department(String emp_department) {
		this.emp_department = emp_department;
	}

	public void validate() {

	}

	public String execute() {
		try (SessionFactory factory = new Configuration().configure().buildSessionFactory();
				Session session = factory.openSession()) {
			session.beginTransaction();
			DetachedCriteria criteria = DetachedCriteria.forClass(Department.class);
			criteria.add(Restrictions.eq("department_name", emp_department));

			Department department = (Department) criteria.getExecutableCriteria(session).list().iterator().next();
			System.out.println(department.getDepartment_name());
			Employee employee = session.get(Employee.class, employee_id);
			AccessLevel level = employee.getAccessLevel();
			level.setAccessLevel(emp_access_level);
			employee.setEmail(emp_mail);
			employee.setContactNumber(emp_mobile);
			employee.setName(emp_name);
			employee.setDepartment(department);
			session.update(level);
			session.update(department);
			session.update(employee);
			session.getTransaction().commit();
			addActionMessage("Employee details areupdated for id " + employee_id);
		}
		return "success";
	}
}
