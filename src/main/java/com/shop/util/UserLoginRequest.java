package com.shop.util;

import lombok.Data;

@Data
public class UserLoginRequest {

    private String username;
    private String password;
    private String redirect;
}
