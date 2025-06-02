<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>个人中心 - 在线商城</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/profile.css" rel="stylesheet">
</head>
<body>
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>
<jsp:include page="common/profile_nav.jsp">
  <jsp:param name="selected_item" value="0"/>
</jsp:include>

<div class="container mt-4">
  <div class="row">
    <div class="col-md-10">
      <div class="card profile-card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <span><i class="fas fa-user me-2"></i>基本信息</span>
          <button id="edit" type="button" class="btn btn-edit btn-sm text-white">
            <i class="fas fa-edit me-1"></i>编辑
          </button>
        </div>
        <div class="card-body">
          <!-- 显示模式 -->
          <div id="info-display">
            <div class="info-item">
              <span class="info-label">用户名：</span>
              <span class="info-value">${user.username}</span>
            </div>
            <div class="info-item">
              <span class="info-label">注册时间：</span>
              <span class="info-value"><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd"/></span>
            </div>
            <div class="info-item">
              <span class="info-label">邮箱：</span>
              <span class="info-value">${user.email}</span>
            </div>
            <div class="info-item">
              <span class="info-label">手机号：</span>
              <span class="info-value">${user.phone}</span>
            </div>
            <div class="info-item">
              <span class="info-label">地址：</span>
              <span class="info-value">${user.address}</span>
            </div>
            <div class="info-item">
              <span class="info-label">注册时间：</span>
              <span class="info-value"><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
            </div>
          </div>

          <!-- 编辑模式 -->
          <div id="info-edit" class="d-none">
            <form id="profileForm">
              <div class="mb-3">
                <label for="username" class="form-label">用户名</label>
                <input type="text" class="form-control" id="username" value="${user.username}" readonly>
              </div>
              <div class="mb-3">
                <label for="email" class="form-label">邮箱</label>
                <input type="email" class="form-control" id="email" value="${user.email}" placeholder="请输入邮箱">
              </div>
              <div class="mb-3">
                <label for="phone" class="form-label">手机号</label>
                <input type="tel" class="form-control" id="phone" value="${user.phone}" placeholder="请输入手机号">
              </div>
              <div class="mb-3">
                <label for="address" class="form-label">地址</label>
                <textarea class="form-control" id="address" rows="3" placeholder="请输入地址">${user.address}</textarea>
              </div>
              <div class="d-flex gap-2">
                <button id="submit-edit" type="button" class="btn btn-success update_control">
                  <i class="fas fa-save me-1"></i>保存
                </button>
                <button id="cancel-edit" type="button" class="btn btn-secondary update_control">
                  <i class="fas fa-times me-1"></i>取消
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="common/dependency_js.jsp"/>

<script>
    document.querySelector('#edit').addEventListener('click', () => {
        document.querySelector('#info-display').classList.add('d-none')
        document.querySelector('#info-edit').classList.remove('d-none')
    })

    document.querySelector('#cancel-edit').addEventListener('click', () => {
        document.querySelector('#info-edit').classList.add('d-none')
        document.querySelector('#info-display').classList.remove('d-none')
        document.querySelector('#profileForm').reset()
        document.querySelector('#email').value = '${user.email}'
        document.querySelector('#phone').value = '${user.phone}'
        document.querySelector('#address').value = '${user.address}'
    })

    document.querySelector('#submit-edit').addEventListener('click', () => {
        const email = document.querySelector('#email').value.trim();
        const phone = document.querySelector('#phone').value.trim();
        const address = document.querySelector('#address').value.trim();
        const buttons = document.querySelectorAll('.update_control');
        buttons.forEach(showLoading)
        updateProfile(email, phone, address)
            .then(() => showMessage('更新成功', {type: 'success', reload: true}))
            .catch(error => showMessage(error.message, 'danger'))
            .finally(() => buttons.forEach(hideLoading))
    })
</script>
</body>
</html>