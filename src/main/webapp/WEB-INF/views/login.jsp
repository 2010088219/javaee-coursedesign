<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>用户登录 - 网上商城</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="common/toast.jsp"/>
<jsp:include page="common/header.jsp"/>

<div class="container">
  <div class="row justify-content-center mt-5">
    <div class="col-md-6 col-lg-4">
      <div class="card shadow">
        <div class="card-header bg-primary text-white text-center">
          <h4><i class="fas fa-sign-in-alt"></i> 用户登录</h4>
        </div>
        <div class="card-body">
          <form id="loginForm">
            <div class="mb-3">
              <label for="username" class="form-label">用户名</label>
              <div class="input-group">
                <span class="input-group-text"><i class="fas fa-user"></i></span>
                <input type="text" class="form-control" id="username" name="username"
                       placeholder="请输入用户名" required>
                <div class="invalid-feedback">
                  用户名不能为空
                </div>
              </div>
            </div>

            <div class="mb-3">
              <label for="password" class="form-label">密码</label>
              <div class="input-group">
                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="请输入密码" required>
                <div class="invalid-feedback">
                  密码不能为空
                </div>
              </div>
            </div>

            <div class="d-grid">
              <button id="login" type="submit" class="btn btn-primary">
                <i class="fas fa-sign-in-alt"></i> 登录
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
    document.querySelector('#login').addEventListener('click', event => {
        event.preventDefault()
        const form = document.querySelector('#loginForm');
        if (!form.checkValidity()) {
            form.classList.add('was-validated')
            return
        }

        const username = document.querySelector('#username').value.trim();
        const password = document.querySelector('#password').value;
        login(username, password)
            .then(redirect => showMessage('登录成功', {
                type: 'success',
                redirect: '${pageContext.request.contextPath}' + redirect
            }))
            .catch(error => showMessage(error.message, 'danger'))
    });
</script>
</body>
</html>