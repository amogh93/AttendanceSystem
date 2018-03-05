package com.attendance.struts2;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Pattern;

import javax.swing.JOptionPane;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;

import com.attendance.crypto.CryptoUtils;
import com.attendance.model.AccessLevel;
import com.attendance.model.BiometricTemplate;
import com.attendance.model.Department;
import com.attendance.model.Employee;
import com.attendance.model.EmployeeLogin;
import com.attendance.model.LeavesRemaining;
import com.opensymphony.xwork2.ActionSupport;

public class NewRegistration extends ActionSupport {

	private String id;
	private String name;
	private Date date_of_birth;
	private String contact;
	private char gender;
	private String department;
	private String email;
	private Date joining_date;
	private String user_id;
	private String password;
	private String employee_type;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getDate_of_birth() {
		return date_of_birth;
	}

	public void setDate_of_birth(Date date_of_birth) {
		this.date_of_birth = date_of_birth;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getJoining_date() {
		return joining_date;
	}

	public void setJoining_date(Date joining_date) {
		this.joining_date = joining_date;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public char getGender() {
		return gender;
	}

	public void setGender(char gender) {
		this.gender = gender;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getEmployee_type() {
		return employee_type;
	}

	public void setEmployee_type(String employee_type) {
		this.employee_type = employee_type;
	}

	public void validate() {
		if (id.equals("")) {
			addFieldError("errorField", "Please enter employee id.");
		} else if (name.equals("")) {
			addFieldError("errorField", "Please enter employee name.");
		} else if (date_of_birth.equals("")) {
			addFieldError("errorField", "Please enter date of birth.");
		} else if (contact.equals("")) {
			addFieldError("errorField", "Please enter contact number.");
		} else if (contact.length() > 10) {
			addFieldError("errorField", "Contact number length shold not exceed 10 digits.");
		} else if (department.equalsIgnoreCase("NA")) {
			addFieldError("errorField", "Please select your department.");
		} else if (email.equals("")) {
			addFieldError("errorField", "Please enter email id.");
		} else if (joining_date.equals("")) {
			addFieldError("errorField", "Please enter joining date.");
		} else if (user_id.equals("")) {
			addFieldError("errorField", "Please enter username.");
		} else if (password.equals("")) {
			addFieldError("errorField", "Please enter password.");
		} else if (employee_type.equalsIgnoreCase("NA")) {
			addFieldError("errorField", "Please select employee type.");
		} else if (!Pattern.matches("[0-9]{10}", contact)) {
			addFieldError("errorField", "Incorrect contact number format.");
		} else if (!Pattern.matches(
				"^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$",
				email)) {
			addFieldError("errorField", "Incorrect email format.");
		}

	}

	public String display() {
		return "none";
	}

	public String execute() {
		try (SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
				Session session = sessionFactory.openSession();) {
			session.beginTransaction();

			Employee employee = new Employee();
			AccessLevel level = new AccessLevel();
			EmployeeLogin login = new EmployeeLogin();
			LeavesRemaining leaves = new LeavesRemaining();

			if (employee_type.equalsIgnoreCase("probationary")) {
				leaves.setCl_count(5);
				leaves.setPl_count(0);
				leaves.setSl_count(6);
			} else {
				leaves.setCl_count(14);
				leaves.setPl_count(40);
				leaves.setSl_count(25);
			}

			DetachedCriteria criteria = DetachedCriteria.forClass(Department.class);
			criteria.add(Restrictions.eq("department_name", department));
			Department dept = (Department) criteria.getExecutableCriteria(session).list().iterator().next();
			System.out.println(dept.getDepartment_name());

			employee.setId(id);
			employee.setName(name);
			employee.setGender(gender);
			employee.setContactNumber(contact);
			employee.setDateOfBirth(date_of_birth);
			employee.setEmail(email);
			employee.setJoiningDate(joining_date);

			level.setAccessLevel("RESTRICTED");
			employee.setAccessLevel(level);

			login.setUserName(user_id);
			login.setPassword(CryptoUtils.doEncrypt(password));
			employee.setEmployeeLogin(login);
			employee.setDepartment(dept);

			login.setEmployee(employee);
			level.setEmployee(employee);
			leaves.setEmployee(employee);

			session.save(login);
			session.save(level);
			session.save(dept);
			session.save(leaves);
			session.save(employee);
			session.getTransaction().commit();
			addActionMessage("Employee registered!");
		}

		return "success";
	}

}
