package com.attendance.interceptor;

import java.util.Map;

import com.attendance.struts2.Login;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.Interceptor;

public class SessionCheckInterceptor implements Interceptor {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
	}

	@Override
	public void init() {
		// TODO Auto-generated method stub
	}

	@Override
	public String intercept(ActionInvocation invocation) throws Exception {

		Map<String, Object> sessionMap = invocation.getInvocationContext().getSession();

		if (sessionMap.get("id") == null) {
			if (invocation.getAction().getClass().equals(Login.class)) {
				return invocation.invoke();
			}

			return "login";
		}
		return invocation.invoke();
	}
}
