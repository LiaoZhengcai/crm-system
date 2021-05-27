package com.crm.exception;

public class LoginException extends Exception{
    // 异常信息
    private String message;

    public LoginException(String message){
        super(message);
        this.message = message;
    }

    @Override
    public String getMessage() {
        return message;
    }
}
