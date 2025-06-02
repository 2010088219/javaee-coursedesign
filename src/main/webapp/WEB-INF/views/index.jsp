<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>网上商城 - 首页</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
</head>
<body>
<jsp:include page="common/toast.jsp"/>
<jsp:include page="common/header.jsp"/>
<div class="container my-5">
  <!-- 热销商品 -->
  <section class="mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2><i class="fas fa-fire text-danger"></i> 热销商品</h2>
      <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
        查看更多 <i class="fas fa-arrow-right"></i>
      </a>
    </div>

    <div class="row">
      <c:forEach items="${hotProducts}" var="product" varStatus="status">
        <c:if test="${status.index < 4}">
          <jsp:include page="common/product-card.jsp">
            <jsp:param name="id" value="${product.id}"/>
            <jsp:param name="name" value="${product.name}"/>
            <jsp:param name="description" value="${product.description}"/>
            <jsp:param name="price" value="${product.price}"/>
            <jsp:param name="sales" value="${product.sales}"/>
            <jsp:param name="stock" value="${product.stock}"/>
            <jsp:param name="image" value="${product.image}"/>
            <jsp:param name="showSales" value="true"/>
          </jsp:include>
        </c:if>
      </c:forEach>
    </div>
  </section>

  <!-- 最新商品 -->
  <section>
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2><i class="fas fa-star text-warning"></i> 最新商品</h2>
      <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
        查看更多 <i class="fas fa-arrow-right"></i>
      </a>
    </div>

    <div class="row">
      <c:forEach items="${latestProducts}" var="product" varStatus="status">
        <c:if test="${status.index < 4}">
          <jsp:include page="common/product-card.jsp">
            <jsp:param name="id" value="${product.id}"/>
            <jsp:param name="name" value="${product.name}"/>
            <jsp:param name="description" value="${product.description}"/>
            <jsp:param name="price" value="${product.price}"/>
            <jsp:param name="sales" value="${product.sales}"/>
            <jsp:param name="stock" value="${product.stock}"/>
            <jsp:param name="image" value="${product.image}"/>
            <jsp:param name="showSales" value="false"/>
          </jsp:include>
        </c:if>
      </c:forEach>
    </div>
  </section>
</div>

<jsp:include page="common/dependency_js.jsp"/>
<script src="${pageContext.request.contextPath}/static/js/search.js"></script>
</body>
</html>