<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单详情 - 网上商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
    <style>
        .order-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 30px;
        }

        .status-badge {
            font-size: 1.1rem;
            padding: 8px 16px;
        }

        .info-section {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .section-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #e9ecef;
            border-radius: 8px 8px 0 0;
        }

        .section-content {
            padding: 20px;
        }

        .product-item {
            border-bottom: 1px solid #e9ecef;
            padding: 15px 0;
        }

        .product-item:last-child {
            border-bottom: none;
        }

        .timeline {
            position: relative;
            padding-left: 30px;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #e9ecef;
        }

        .timeline-item {
            position: relative;
            margin-bottom: 20px;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -23px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #28a745;
            border: 3px solid #fff;
            box-shadow: 0 0 0 2px #28a745;
        }

        .timeline-item.pending::before {
            background: #ffc107;
            box-shadow: 0 0 0 2px #ffc107;
        }

        .timeline-item.inactive::before {
            background: #e9ecef;
            box-shadow: 0 0 0 2px #e9ecef;
        }

        .order-actions {
            position: sticky;
            top: 20px;
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>

<div class="container mt-4">
    <!-- 订单头部信息 -->
    <div class="order-header">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h3 class="mb-2">订单详情</h3>
                <p class="mb-1">订单号：${order.id}</p>
                <p class="mb-0">下单时间：<fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
            </div>
            <div class="col-md-4 text-md-end">
                <c:choose>
                    <c:when test="${order.status == 0}">
                        <span class="badge bg-warning status-badge">待支付</span>
                    </c:when>
                    <c:when test="${order.status == 1}">
                        <span class="badge bg-success status-badge">已支付</span>
                    </c:when>
                    <c:when test="${order.status == 2}">
                        <span class="badge bg-info status-badge">已发货</span>
                    </c:when>
                    <c:when test="${order.status == 3}">
                        <span class="badge bg-primary status-badge">已完成</span>
                    </c:when>
                    <c:when test="${order.status == -1}">
                        <span class="badge bg-danger status-badge">已取消</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-secondary status-badge">未知状态</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <!-- 收货信息 -->
            <div class="info-section">
                <div class="section-header">
                    <h5 class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>收货信息</h5>
                </div>
                <div class="section-content">
                    <div class="row">
                        <div class="col-md-6">
                            <p class="mb-1"><strong>收货人：</strong>${order.user.username}</p>
                            <p class="mb-1"><strong>联系电话：</strong>${order.user.phone}</p>
                        </div>
                        <div class="col-md-6">
                            <p class="mb-1"><strong>收货地址：</strong></p>
                            <p class="mb-0">${order.shippingAddress}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 商品信息 -->
            <div class="info-section">
                <div class="section-header">
                    <h5 class="mb-0"><i class="fas fa-shopping-cart me-2"></i>商品信息</h5>
                </div>
                <div class="section-content">
                    <c:forEach var="item" items="${order.orderItems}">
                        <div class="product-item">
                            <div class="row align-items-center">
                                <div class="col-auto">
                                    <img src="${pageContext.request.contextPath}/static/images/products/${empty item.product.image ? 'default.jpg' : item.product.image}" 
                                         class="img-thumbnail" style="width: 80px; height: 80px; object-fit: cover;"
                                         alt="${item.product.name}"
                                         onerror="this.src='${pageContext.request.contextPath}/static/images/products/default.jpg'">
                                </div>
                                <div class="col">
                                    <h6 class="mb-1">${item.product.name}</h6>
                                    <p class="text-muted small mb-0">${item.product.description}</p>
                                </div>
                                <div class="col-auto">
                                    <span class="text-muted">×${item.quantity}</span>
                                </div>
                                <div class="col-auto">
                                    <span class="fw-bold">
                                        <fmt:formatNumber value="${item.price}" pattern="¥#,##0.00"/>
                                    </span>
                                </div>
                                <div class="col-auto">
                                    <span class="fw-bold text-danger">
                                        <fmt:formatNumber value="${item.price * item.quantity}" pattern="¥#,##0.00"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- 订单进度 -->
            <div class="info-section">
                <div class="section-header">
                    <h5 class="mb-0"><i class="fas fa-truck me-2"></i>订单进度</h5>
                </div>
                <div class="section-content">
                    <div class="timeline">
                        <div class="timeline-item ${order.status >= 0 ? '' : 'inactive'}">
                            <h6>订单已提交</h6>
                            <p class="text-muted mb-0">
                                <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </p>
                        </div>
                        <div class="timeline-item ${order.status >= 1 ? '' : order.status == 0 ? 'pending' : 'inactive'}">
                            <h6>订单已支付</h6>
                            <p class="text-muted mb-0">
                                <c:if test="${order.status >= 1}">
                                    等待商家发货
                                </c:if>
                                <c:if test="${order.status == 0}">
                                    等待买家付款
                                </c:if>
                                <c:if test="${order.status == -1}">
                                    订单已取消
                                </c:if>
                            </p>
                        </div>
                        <div class="timeline-item ${order.status >= 2 ? '' : order.status == 1 ? 'pending' : 'inactive'}">
                            <h6>商品已发货</h6>
                            <p class="text-muted mb-0">
                                <c:if test="${order.status >= 2}">
                                    商品正在配送中
                                </c:if>
                                <c:if test="${order.status < 2 && order.status >= 0}">
                                    等待商家发货
                                </c:if>
                            </p>
                        </div>
                        <div class="timeline-item ${order.status >= 3 ? '' : order.status == 2 ? 'pending' : 'inactive'}">
                            <h6>订单已完成</h6>
                            <p class="text-muted mb-0">
                                <c:if test="${order.status >= 3}">
                                    感谢您的购买
                                </c:if>
                                <c:if test="${order.status < 3 && order.status >= 0}">
                                    等待确认收货
                                </c:if>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- 订单摘要 -->
            <div class="order-actions">
                <div class="info-section">
                    <div class="section-header">
                        <h5 class="mb-0"><i class="fas fa-file-invoice me-2"></i>订单摘要</h5>
                    </div>
                    <div class="section-content">
                        <div class="d-flex justify-content-between mb-2">
                            <span>商品总价：</span>
                            <span><fmt:formatNumber value="${order.totalAmount}" pattern="¥#,##0.00"/></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>运费：</span>
                            <span class="text-success">免运费</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>优惠：</span>
                            <span class="text-success">-¥0.00</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between">
                            <span class="fw-bold">实付金额：</span>
                            <span class="fw-bold text-danger fs-5">
                                <fmt:formatNumber value="${order.totalAmount}" pattern="¥#,##0.00"/>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- 操作按钮 -->
                <div class="info-section">
                    <div class="section-content">
                        <c:choose>
                            <c:when test="${order.status == 0}">
                                <button class="btn btn-primary btn-lg w-100 mb-2" onclick="payOrder()">
                                    <i class="fas fa-credit-card me-2"></i>立即支付
                                </button>
                                <button class="btn btn-outline-danger w-100" onclick="cancelOrder()">
                                    <i class="fas fa-times me-2"></i>取消订单
                                </button>
                            </c:when>
                            <c:when test="${order.status == 2}">
                                <button class="btn btn-success btn-lg w-100 mb-2" onclick="confirmReceive()">
                                    <i class="fas fa-check me-2"></i>确认收货
                                </button>
                            </c:when>
                            <c:when test="${order.status == 3}">
                                <button class="btn btn-outline-primary w-100 mb-2" onclick="buyAgain()">
                                    <i class="fas fa-redo me-2"></i>再次购买
                                </button>
                                <button class="btn btn-outline-secondary w-100" onclick="writeReview()">
                                    <i class="fas fa-star me-2"></i>评价商品
                                </button>
                            </c:when>
                        </c:choose>
                        
                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/order/orders" class="btn btn-outline-secondary w-100">
                                <i class="fas fa-arrow-left me-2"></i>返回订单列表
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="common/dependency_js.jsp"/>

<script>
    function payOrder() {
        // 模拟支付流程
        if (confirm('确认支付 ${order.totalAmount} 元吗？')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/order/updateStatus',
                type: 'POST',
                data: {
                    orderId: ${order.id},
                    status: 1
                },
                success: function(response) {
                    if (response.success) {
                        showToast('支付成功！', 'success');
                        setTimeout(function() {
                            location.reload();
                        }, 1500);
                    } else {
                        showToast('支付失败：' + response.message, 'error');
                    }
                },
                error: function() {
                    showToast('网络错误，请重试', 'error');
                }
            });
        }
    }

    function cancelOrder() {
        if (confirm('确认取消订单吗？取消后无法恢复。')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/order/updateStatus',
                type: 'POST',
                data: {
                    orderId: ${order.id},
                    status: -1
                },
                success: function(response) {
                    if (response.success) {
                        showToast('订单已取消', 'success');
                        setTimeout(function() {
                            location.reload();
                        }, 1500);
                    } else {
                        showToast('取消失败：' + response.message, 'error');
                    }
                },
                error: function() {
                    showToast('网络错误，请重试', 'error');
                }
            });
        }
    }

    function confirmReceive() {
        if (confirm('确认已收到商品吗？')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/order/updateStatus',
                type: 'POST',
                data: {
                    orderId: ${order.id},
                    status: 3
                },
                success: function(response) {
                    if (response.success) {
                        showToast('确认收货成功！', 'success');
                        setTimeout(function() {
                            location.reload();
                        }, 1500);
                    } else {
                        showToast('操作失败：' + response.message, 'error');
                    }
                },
                error: function() {
                    showToast('网络错误，请重试', 'error');
                }
            });
        }
    }

    function buyAgain() {
        // 重新购买功能
        const productIds = [<c:forEach var="item" items="${order.orderItems}" varStatus="status">${item.productId}<c:if test="${!status.last}">,</c:if></c:forEach>];
        
        $.ajax({
            url: '${pageContext.request.contextPath}/cart/addBatch',
            type: 'POST',
            data: { productIds: productIds },
            success: function(response) {
                if (response.success) {
                    showToast('商品已加入购物车', 'success');
                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/cart';
                    }, 1500);
                } else {
                    showToast('添加失败：' + response.message, 'error');
                }
            },
            error: function() {
                showToast('网络错误，请重试', 'error');
            }
        });
    }

    function writeReview() {
        showToast('评价功能开发中...', 'info');
    }
</script>
</body>
</html>