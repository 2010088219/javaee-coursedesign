<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="col-lg-3 col-md-6 mb-4">
  <div class="card h-100 product-card">
    <a class="card-img-top-wrapper" href="${pageContext.request.contextPath}/product?id=${param.id}">
      <img class="card-img-top" src="${pageContext.request.contextPath}/static/images/products/${empty param.image ? 'default.jpg' : param.image}"
           alt="${param.name}"
           onerror="this.src='${pageContext.request.contextPath}/static/images/products/default.jpg'">
    </a>
    <div class="card-body d-flex flex-column flex-column-reverse">
      <div class="mt-2 d-grid">
        <c:choose>
          <c:when test="${empty sessionScope.user}">
            <button class="btn btn-outline-primary btn-sm"
                    onclick="showMessage('请先登录', { type: 'warning', redirect: '${pageContext.request.contextPath}/user/login'})">
              <i class="fas fa-shopping-cart"></i> 添加到购物车
            </button>
          </c:when>
          <c:when test="${param.stock > 0}">
            <button class="btn btn-primary btn-sm"
                    onclick="addToCart(${param.id})
                        .then(msg => updateCartCount && updateCartCount(msg))
                        .catch(e => showMessage(e.message, 'danger'))">
              <i class="fas fa-shopping-cart"></i> 添加到购物车
            </button>
          </c:when>
          <c:otherwise>
            <button class="btn btn-secondary btn-sm text-dark" disabled>
              <i class="fas fa-times"></i> 暂时缺货
            </button>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="d-flex justify-content-between align-items-center">
          <span class="h5 text-danger mb-0">
              ¥<fmt:formatNumber value="${param.price}" pattern="#,##0.00"/>
          </span>
        <small class="text-muted">
          <c:choose>
            <c:when test="${param.showSales}">销量: ${param.sales}</c:when>
            <c:otherwise>库存: ${param.stock}</c:otherwise>
          </c:choose>
        </small>
      </div>
      <a href="${pageContext.request.contextPath}/product?id=${param.id}" class="h-100">
        <h5 class="card-title product-name">${param.name}</h5>
        <p class="card-text text-muted small product-description">
          <c:choose>
            <c:when test="${fn:length(param.description) > 50}">
              ${fn:substring(param.description, 0, 50)}...
            </c:when>
            <c:otherwise>
              ${param.description}
            </c:otherwise>
          </c:choose>
        </p>
      </a>
    </div>
  </div>
</div>