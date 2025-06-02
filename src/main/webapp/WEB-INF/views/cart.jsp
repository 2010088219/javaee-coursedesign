<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>购物车 - 网上商城</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
<!-- 导航栏 -->
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>
<jsp:include page="common/profile_nav.jsp">
  <jsp:param name="selected_item" value="2"/>
</jsp:include>

<div class="container mt-4">
  <div class="row">
    <div class="col-lg-10">
      <div class="card">
        <div class="card-header">
          <div class="row align-items-center">
            <div class="col">
              <div class="form-check">
                <input class="form-check-input" type="checkbox" id="selectAll">
                <label class="form-check-label" for="selectAll">全选</label>
              </div>
            </div>
            <div class="col-auto">
              <button class="btn btn-outline-danger btn-sm" id="deleteSelected">删除选中</button>
            </div>
          </div>
        </div>
        <div class="card-body p-0">
          <c:forEach var="item" items="${cartItems}">
            <div class="cart-item" data-cart-id="${item.productId}">
              <div class="row align-items-center p-3">
                <div class="col-auto">
                  <div class="form-check">
                    <input class="form-check-input item-checkbox" type="checkbox"
                           value="${item.productId}" data-price="${item.product.price}">
                  </div>
                </div>
                <div class="col-auto">
                  <img src="${pageContext.request.contextPath}/static/images/products/${empty item.product.image ? 'default.jpg' : item.product.image}"
                       class="img-thumbnail" style="width: 80px; height: 80px; object-fit: cover;"
                       alt="${item.product.name}"
                       onerror="this.src='${pageContext.request.contextPath}/static/images/products/default.jpg'">
                </div>
                <div class="col">
                  <h6 class="mb-1">${item.product.name}</h6>
                  <p class="text-muted small mb-0">
                    <c:choose>
                      <c:when test="${fn:length(item.product.description) > 60}">
                        ${fn:substring(item.product.description, 0, 60)}...
                      </c:when>
                      <c:otherwise>
                        ${item.product.description}
                      </c:otherwise>
                    </c:choose>
                  </p>
                </div>
                <div class="col-auto">
                      <span class="price h6">
                          <fmt:formatNumber value="${item.product.price}" pattern="¥#,##0.00"/>
                      </span>
                </div>
                <div class="col-auto">
                  <div class="input-group" style="width: 120px;">
                    <button class="btn btn-outline-secondary btn-sm quantity-btn"
                            type="button" data-delta="-1" data-cart-id="${item.productId}">
                      <i class="fas fa-minus"></i>
                    </button>
                    <input type="number" class="form-control form-control-sm text-center quantity-input"
                           value="${item.quantity}" data-original-value="${item.quantity}" data-cart-id="${item.productId}">
                    <button class="btn btn-outline-secondary btn-sm quantity-btn"
                            type="button" data-delta="1" data-cart-id="${item.productId}">
                      <i class="fas fa-plus"></i>
                    </button>
                  </div>
                </div>
                <div class="col-auto">
                      <span class="subtotal h6 text-danger">
                          <fmt:formatNumber value="${item.product.price * item.quantity}" pattern="¥#,##0.00"/>
                      </span>
                </div>
                <div class="col-auto">
                  <button class="btn btn-outline-danger btn-sm delete-item" data-cart-id="${item.productId}">
                    <i class="fas fa-trash"></i>
                  </button>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>
    </div>

    <div class="col-lg-2 position-fixed top-10" style="right: 8%">
      <div class="card">
        <div class="card-header">
          <h5 class="mb-0"><i class="fas fa-calculator"></i> 结算信息</h5>
        </div>
        <div class="card-body">
          <div class="d-flex justify-content-between mb-2">
            <strong>已选商品：</strong>
            <strong id="selectedCount">0</strong>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <strong>商品总价：</strong>
            <strong id="totalPrice">¥0.00</strong>
          </div>
          <hr>
          <div class="d-grid">
            <button class="btn btn-primary btn-lg" id="checkoutBtn" disabled>
              <i class="fas fa-credit-card"></i> 去结算
            </button>
          </div>
        </div>
      </div>

      <div class="card mt-3">
        <div class="card-body text-center">
          <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left"></i> 继续购物
          </a>
        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="common/dependency_js.jsp"/>
<script src="${pageContext.request.contextPath}/static/js/cart.js"></script>
</body>
</html>