package com.wingsinus.ep;

public class Module {
	public String itemNameCheck(int name) {
		String ret = "";
		
		if(name == 100001) {
			ret = "티켓";
		}
		else if(name == 100002) {
			ret = "젬";
		}
		else if(name == 0) {
			ret = "-";
		}
		else {
			ret = String.valueOf(name);
		}
		
		return ret;
	}
}
