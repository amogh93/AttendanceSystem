package com.attendance.struts2;

import org.apache.commons.lang3.StringUtils;

import com.attendance.config.AppConfigInfo;
import com.attendance.crypto.CryptoUtils;
import com.opensymphony.xwork2.ActionSupport;

public class AdminPasswordChange extends ActionSupport {

	private String current_password;
	private String new_password;
	private String re_entered_password;

	public String getCurrent_password() {
		return current_password;
	}

	public void setCurrent_password(String current_password) {
		this.current_password = current_password;
	}

	public String getNew_password() {
		return new_password;
	}

	public void setNew_password(String new_password) {
		this.new_password = new_password;
	}

	public String getRe_entered_password() {
		return re_entered_password;
	}

	public void setRe_entered_password(String re_entered_password) {
		this.re_entered_password = re_entered_password;
	}

	public void validate() {
		if (StringUtils.isEmpty(current_password)) {
			addFieldError("errorField", "Please enter your existing password.");
		} else if (StringUtils.isEmpty(new_password)) {
			addFieldError("errorField", "Please enter new password.");
		} else if (StringUtils.isEmpty(re_entered_password)) {
			addFieldError("errorField", "Please re-enter new password.");
		} else if (!new_password.equals(re_entered_password)) {
			addFieldError("errorField", "New and re-entered Password does not match.");
		}
	}

	public String execute() {
		if (!current_password.equals(CryptoUtils.doDecrypt(AppConfigInfo.getPassword()))) {
			addFieldError("errorField", "Wrong password entered.");
		} else {
			AppConfigInfo.ModifyXML("password", new_password);
			return "success";
		}
		return "failure";
	}

}
