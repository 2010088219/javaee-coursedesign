package com.shop.controller;

import com.shop.entity.User;
import com.shop.service.UserService;
import com.shop.util.*;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * 用户控制器
 */
@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 登录
     */
    @GetMapping("/login")
    public String login() {
        return "login";
    }

    /**
     * 注册
     */
    @GetMapping("/register")
    public String register() {
        return "register";
    }

    /**
     * 用户登录
     */
    @ResponseBody
    @PostMapping("/login")
    public JsonResult<String> login(@RequestBody UserLoginRequest user, HttpSession session) {
        User loginedUser = userService.login(user.getUsername().trim(), user.getPassword());
        if (loginedUser != null) {
            // 登录成功，保存用户信息到session
            session.setAttribute("user", loginedUser);
            return JsonResult.success("登录成功", user.getRedirect());
        } else {
            return JsonResult.error("用户名或密码错误");
        }
    }

    /**
     * 用户注册
     */
    @ResponseBody
    @PostMapping("/register")
    public JsonResult<String> register(@RequestBody UserRegisterRequest user,
                                       HttpSession session) {
        String username = user.getUsername();
        if (username == null || username.length() < 3 || username.length() > 20) {
            return JsonResult.error("用户名长度为3-20个字符");
        }
        username = username.trim();
        if (userService.isUsernameExists(username.trim())) {
            return JsonResult.error("用户名已存在");
        }

        String password = user.getPassword();
        if (password == null || password.length() < 6) {
            return JsonResult.error("密码长度不少于6位");
        }

        String email = user.getEmail();
        if (!StringUtils.isEmail(email)) {
            return JsonResult.error("邮箱格式不正确");
        }
        if (userService.isEmailExists(email.trim())) {
            return JsonResult.error("邮箱已存在");
        }

        User registeredUser = User.forRegister(username, password, email);
        if (userService.register(registeredUser)) {
            session.setAttribute("user", registeredUser);
            return JsonResult.success("注册成功", user.getRedirect());
        } else {
            return JsonResult.error("注册失败，请稍后重试");
        }
    }

    /**
     * 用户退出
     */
    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("user");
        session.invalidate();
        return "redirect:/";
    }

    /**
     * 个人中心
     */
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        // 获取最新的用户信息
        User currentUser = userService.findById(user.getId());
        model.addAttribute("user", currentUser);

        return "profile";
    }

    /**
     * 更新个人信息
     */
    @ResponseBody
    @PostMapping("/profile")
    public JsonResult<Void> updateProfile(@RequestBody UpdateProfileRequest request, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        if (request.getEmail() != null && !StringUtils.isEmail(request.getEmail())) {
            return JsonResult.error("邮箱格式错误");
        }

        if (request.getEmail() != null && userService.isEmailExists(request.getEmail())) {
            return JsonResult.error("邮箱已存在");
        }

        if (request.getPhone() != null && !StringUtils.isPhone(request.getPhone())) {
            return JsonResult.error("手机号码格式错误");
        }

        user.apply(request);
        if (userService.updateUser(user)) {
            // 更新session中的用户信息
            User newUser = userService.findById(user.getId());
            session.setAttribute("user", newUser);
            return JsonResult.success("更新成功");
        } else {
            return JsonResult.error("更新失败");
        }
    }

    /**
     * 修改密码
     */
    @PostMapping("/password")
    @ResponseBody
    public JsonResult<String> updatePassword(@RequestBody UpdatePasswordRequest request, HttpSession session) {

        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) {
            return JsonResult.error("请先登录");
        }

        String oldPassword = request.getOldPassword();
        String newPassword = request.getNewPassword();

        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            return JsonResult.error("原密码不能为空");
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            return JsonResult.error("新密码不能为空");
        }

        if (newPassword.length() < 6) {
            return JsonResult.error("新密码长度不能少于6位");
        }

        // 验证原密码
        User user = userService.findById(sessionUser.getId());
        if (!user.getPassword().equals(StringUtils.md5(oldPassword))) {
            return JsonResult.error("原密码错误");
        }

        // 更新密码
        user.setPassword(StringUtils.md5(newPassword));
        if (userService.updateUser(user)) {
            session.setAttribute("user", null);
            return JsonResult.success("密码修改成功");
        } else {
            return JsonResult.error("密码修改失败");
        }
    }
}