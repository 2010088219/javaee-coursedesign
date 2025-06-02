<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/">
      <i class="fas fa-shopping-cart"></i> 网上商城
    </a>

    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/">首页</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/products">商品列表</a>
        </li>
      </ul>

      <!-- 搜索框 -->
      <form class="d-flex me-3" action="${pageContext.request.contextPath}/products" method="get">
        <div class="input-group" style="position: relative;">
          <input id="search-input" class="form-control" type="search" name="keyword" placeholder="搜索商品..." value="${param.keyword}" autocomplete="off">
          <button class="btn btn-light" type="submit" id="header-search-btn">
            <i class="fas fa-search"></i>
          </button>
        </div>
      </form>

      <ul class="navbar-nav">
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <!-- 已登录 -->
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/cart/">
                <i class="fas fa-shopping-cart"></i> 购物车
                <span class="badge bg-warning text-dark" id="cartCount">0</span>
              </a>
            </li>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                <i class="fas fa-user"></i> ${sessionScope.user.username}
              </a>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">
                  <i class="fas fa-user-cog"></i> 个人中心</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/logout">
                  <i class="fas fa-sign-out-alt"></i> 退出登录</a></li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/user/login">
                <i class="fas fa-sign-in-alt"></i> 登录
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/user/register">
                <i class="fas fa-user-plus"></i> 注册
              </a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<script>
    // 购物车
    window.APP_CONTEXT_PATH = '${pageContext.request.contextPath}';
    document.addEventListener('DOMContentLoaded', () => {
        updateCartCount();
        
        // 初始化头部搜索框的自动补全功能
        const headerSearchInput = document.querySelector('#search-input');
        const headerSearchBtn = document.querySelector('#header-search-btn');
        
        if (headerSearchInput && typeof SearchEnhancer !== 'undefined') {
            new SearchEnhancer({
                searchInput: headerSearchInput,
                searchButton: headerSearchBtn,
                contextPath: '${pageContext.request.contextPath}',
                debounceDelay: 300,
                maxSuggestions: 6
            });
        }
    });

    function updateCartCount(message = undefined) {
        <c:if test="${not empty sessionScope.user}">
        getCartCount().then(count => document.querySelector('#cartCount').innerHTML = count + '');
        if (message) {
            showMessage(message, 'success')
        }
        </c:if>
    }
</script>