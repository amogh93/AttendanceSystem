package com.attendance.struts2;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;

public class AdminMaster {

	public String execute() {
		Map sessionMap = (Map) ActionContext.getContext().get("session");
		if (sessionMap != null) {
			if (sessionMap.get("access").toString().equalsIgnoreCase("full")) {
				return "success";
			}
			return "failure";
		}
		return "failure";
	}

}
