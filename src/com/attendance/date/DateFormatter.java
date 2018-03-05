package com.attendance.date;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateFormatter {

	private static final String TIME_FORMAT = "HH:mm:ss";
	private static final String DATE_FORMAT = "yyyy-MM-ss";

	public static String getFormattedTime(Date time) throws Exception {
		DateFormat df = new SimpleDateFormat(TIME_FORMAT);
		return df.format(time);
	}

	public static String getFormattedDate(Date date) throws Exception {
		DateFormat df = new SimpleDateFormat(DATE_FORMAT);
		return df.format(date);
	}
}
