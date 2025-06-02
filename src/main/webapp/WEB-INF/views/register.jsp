<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>用户注册 - 网上商城</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
<!-- 导航栏 -->
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>

<div class="container">
  <div class="row justify-content-center mt-5">
    <div class="col-md-6 col-lg-5">
      <div class="card shadow">
        <div class="card-header bg-success text-white text-center">
          <h4><i class="fas fa-user-plus"></i> 用户注册</h4>
        </div>
        <div class="card-body">
          <form id="registerForm">
            <div class="mb-3">
              <label for="username" class="form-label">用户名 <span class="text-danger">*</span></label>
              <div class="input-group">
                <span class="input-group-text"><i class="fas fa-user"></i></span>
                <input type="text" class="form-control" id="username" name="username"
                       placeholder="请输入用户名" required>
                <div class="invalid-feedback">
                  用户名不能为空
                </div>
              </div>
              <div class="form-text">用户名长度为3-20个字符</div>
            </div>

            <div class="mb-3">
              <label for="password" class="form-label">密码 <span class="text-danger">*</span></label>
              <div class="input-group">
                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="请输入密码" required>
                <div class="invalid-feedback">
                  密码不能为空
                </div>
              </div>
              <div class="form-text">密码长度不少于6位</div>
            </div>

            <div class="mb-3">
              <label for="confirmPassword" class="form-label">确认密码 <span class="text-danger">*</span></label>
              <div class="input-group">
                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                       placeholder="请再次输入密码" required>
                <div class="invalid-feedback">
                  密码不能为空
                </div>
              </div>
            </div>

            <div class="mb-3">
              <label for="email" class="form-label">邮箱</label>
              <div class="input-group">
                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                <input type="email" class="form-control" id="email" name="email"
                       placeholder="请输入邮箱地址">
              </div>
            </div>

            <div class="d-grid">
              <button type="submit" class="btn btn-success" id="register">
                <i class="fas fa-user-plus"></i> 注册
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="common/dependency_js.jsp"/>

<script>
    document.querySelector('#register').addEventListener('click', event => {
        event.preventDefault()
        const form = document.querySelector('#registerForm');
        if (!form.checkValidity()) {
            form.classList.add('was-validated')
        }

        const password = document.querySelector('#password').value;
        const confirmPassword = document.querySelector('#confirmPassword').value;
        const username = document.querySelector('#username').value.trim();
        const email = document.querySelector('#email').value;
        showLoading(event.target);
        register(username, password, confirmPassword, email)
            .then(redirect => showMessage('注册成功', {
                type: 'success',
                redirect: '${pageContext.request.contextPath}' + redirect
            }))
            .catch(error => showMessage(error.message, 'danger'))
            .finally(() => hideLoading(event.target));
    });
</script>
</body>
</html>