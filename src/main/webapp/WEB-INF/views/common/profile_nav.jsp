<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--<c:set var="selected" value="${not empty param.selected_item ?  param.selected_item : ''}"/>--%>

<div class="col-md-1 position-fixed top-10 mt-4" style="left: 5%">
  <div class="card profile-card">
    <div class="card-header">
      <i class="fas fa-user-cog me-2"></i>个人中心
    </div>
    <div class="list-group list-group-flush">
      <a href="${pageContext.request.contextPath}/user/profile"
         class="list-group-item list-group-item-action ${param.selected_item eq '0' ? 'active' : ''}">
        <i class="fas fa-user me-2"></i>基本信息
      </a>
      <a href="${pageContext.request.contextPath}/order/orders"
         class="list-group-item list-group-item-action ${param.selected_item eq '1' ? 'active' : ''}">
        <i class="fas fa-shopping-bag me-2"></i>我的订单
      </a>
      <a href="${pageContext.request.contextPath}/cart/"
         class="list-group-item list-group-item-action ${param.selected_item eq '2' ? 'active' : ''}">
        <i class="fas fa-shopping-cart me-2"></i>购物车
      </a>
      <a href="#" class="list-group-item list-group-item-action"
         data-bs-toggle="modal" data-bs-target="#changePasswordModal">
        <i class="fas fa-key me-2"></i>修改密码
      </a>
    </div>
  </div>
</div>

<div class="modal fade" id="changePasswordModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-key me-2"></i>修改密码</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form id="changePasswordForm">
        <div class="modal-body">
          <div class="mb-3">
            <label for="oldPassword" class="form-label">原密码</label>
            <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
          </div>
          <div class="mb-3">
            <label for="newPassword" class="form-label">新密码</label>
            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
            <div class="form-text">密码长度不能少于6位</div>
          </div>
          <div class="mb-3">
            <label for="confirmPassword" class="form-label">确认新密码</label>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
          <button type="submit" class="btn btn-primary">确认修改</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
    document.querySelector('#changePasswordForm').addEventListener('submit', e => {
        e.preventDefault();
        const oldPassword = document.querySelector('#oldPassword').value.trim();
        const newPassword = document.querySelector('#newPassword').value.trim();
        const confirmPassword = document.querySelector('#confirmPassword').value.trim();
        updatePassword(oldPassword, newPassword, confirmPassword)
            .then(() => showMessage('修改密码成功', {
                type: 'success',
                redirect: '${pageContext.request.contextPath}/user/login'
            }))
            .catch(e => showMessage(e.message, 'danger'));
    });
</script>