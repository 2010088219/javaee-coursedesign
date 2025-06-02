<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单结算 - 网上商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
    <style>
        .checkout-section {
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

        .address-item {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .address-item:hover {
            border-color: #007bff;
        }

        .address-item.selected {
            border-color: #007bff;
            background-color: #f8f9ff;
        }

        .product-item {
            border-bottom: 1px solid #e9ecef;
            padding: 15px 0;
        }

        .product-item:last-child {
            border-bottom: none;
        }

        .payment-method {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .payment-method:hover {
            border-color: #007bff;
        }

        .payment-method.selected {
            border-color: #007bff;
            background-color: #f8f9ff;
        }

        .order-summary {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            position: sticky;
            top: 20px;
        }

        .summary-item {
            display: flex;
            justify-content: between;
            margin-bottom: 10px;
        }

        .total-amount {
            font-size: 1.2rem;
            font-weight: bold;
            color: #dc3545;
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>

<div class="container mt-4">
    <div class="row">
        <div class="col-lg-8">
            <!-- 收货地址 -->
            <div class="checkout-section">
                <div class="section-header">
                    <h5 class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>收货地址</h5>
                </div>
                <div class="section-content">
                    <div class="address-item selected" data-address="${user.address}">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">${user.username}</h6>
                                <p class="mb-1">${user.phone}</p>
                                <p class="mb-0 text-muted">${user.address}</p>
                            </div>
                            <span class="badge bg-primary">默认</span>
                        </div>
                    </div>
                    
                    <!-- 新增地址 -->
                    <div class="mt-3">
                        <button class="btn btn-outline-primary" type="button" data-bs-toggle="collapse" 
                                data-bs-target="#newAddressForm">
                            <i class="fas fa-plus me-2"></i>使用新地址
                        </button>
                        <div class="collapse mt-3" id="newAddressForm">
                            <div class="card card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <label class="form-label">收货人</label>
                                        <input type="text" class="form-control" id="newReceiverName" 
                                               value="${user.username}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">联系电话</label>
                                        <input type="text" class="form-control" id="newReceiverPhone" 
                                               value="${user.phone}">
                                    </div>
                                </div>
                                <div class="mt-3">
                                    <label class="form-label">详细地址</label>
                                    <textarea class="form-control" id="newAddress" rows="3" 
                                              placeholder="请输入详细的收货地址"></textarea>
                                </div>
                                <div class="mt-3">
                                    <button class="btn btn-primary" onclick="useNewAddress()">使用此地址</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 商品信息 -->
            <div class="checkout-section">
                <div class="section-header">
                    <h5 class="mb-0"><i class="fas fa-shopping-cart me-2"></i>商品信息</h5>
                </div>
                <div class="section-content" id="productList">
                    <!-- 商品列表将通过JavaScript动态加载 -->
                    <div class="text-center py-4">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">加载中...</span>
                        </div>
                        <p class="mt-2 text-muted">正在加载商品信息...</p>
                    </div>
                </div>
            </div>

            <!-- 支付方式 -->
            <div class="checkout-section">
                <div class="section-header">
                    <h5 class="mb-0"><i class="fas fa-credit-card me-2"></i>支付方式</h5>
                </div>
                <div class="section-content">
                    <div class="payment-method selected" data-method="alipay">
                        <div class="d-flex align-items-center">
                            <i class="fab fa-alipay fa-2x text-primary me-3"></i>
                            <div>
                                <h6 class="mb-0">支付宝</h6>
                                <small class="text-muted">推荐使用支付宝快捷支付</small>
                            </div>
                        </div>
                    </div>
                    <div class="payment-method" data-method="wechat">
                        <div class="d-flex align-items-center">
                            <i class="fab fa-weixin fa-2x text-success me-3"></i>
                            <div>
                                <h6 class="mb-0">微信支付</h6>
                                <small class="text-muted">微信安全支付</small>
                            </div>
                        </div>
                    </div>
                    <div class="payment-method" data-method="bank">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-university fa-2x text-info me-3"></i>
                            <div>
                                <h6 class="mb-0">银行卡支付</h6>
                                <small class="text-muted">支持各大银行卡</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- 订单摘要 -->
            <div class="order-summary">
                <h5 class="mb-3"><i class="fas fa-file-invoice me-2"></i>订单摘要</h5>
                
                <div class="summary-item">
                    <span>商品总价：</span>
                    <span id="subtotal">¥0.00</span>
                </div>
                <div class="summary-item">
                    <span>运费：</span>
                    <span class="text-success">免运费</span>
                </div>
                <div class="summary-item">
                    <span>优惠：</span>
                    <span class="text-success">-¥0.00</span>
                </div>
                <hr>
                <div class="summary-item">
                    <span class="fw-bold">应付总额：</span>
                    <span class="total-amount" id="totalAmount">¥0.00</span>
                </div>

                <div class="mt-4">
                    <button class="btn btn-danger btn-lg w-100" id="submitOrderBtn" disabled>
                        <i class="fas fa-lock me-2"></i>提交订单
                    </button>
                </div>

                <div class="mt-3 text-center">
                    <small class="text-muted">
                        <i class="fas fa-shield-alt me-1"></i>
                        您的支付信息将被加密保护
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="common/dependency_js.jsp"/>

<script>
    var selectedProducts = [];
    var selectedAddress = '${user.address}';
    var selectedPaymentMethod = 'alipay';
    var totalAmount = 0;
    
    // 获取URL参数的兼容函数
    function getUrlParams() {
        var params = {};
        var search = window.location.search.substring(1);
        if (search) {
            var pairs = search.split('&');
            for (var i = 0; i < pairs.length; i++) {
                var pair = pairs[i].split('=');
                params[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1] || '');
            }
        }
        return params;
    }

    $(document).ready(function() {
        // 获取商品ID列表
        var urlParams = getUrlParams();
        var productIdsParam = urlParams['productIds'];
        var productIds = [];
        if (productIdsParam) {
            var idStrings = productIdsParam.split(',');
            for (var i = 0; i < idStrings.length; i++) {
                productIds.push(parseInt(idStrings[i]));
            }
        }
        console.log('Product IDs:', productIds);
        
        if (productIds.length === 0) {
            showMessage('没有选择商品', {type: 'error'});
            return;
        }
        
        // 加载商品信息
        loadProducts(productIds);
        
        // 初始化已选中的地址
        var defaultAddress = $('.address-item.selected');
        console.log('找到的地址元素数量:', defaultAddress.length);
        if (defaultAddress.length > 0) {
            selectedAddress = defaultAddress.data('address');
            console.log('初始化地址:', selectedAddress);
        }
        
        // 地址选择 - 使用事件委托
        $(document).on('click', '.address-item', function() {
            $('.address-item').removeClass('selected');
            $(this).addClass('selected');
            selectedAddress = $(this).data('address');
        });
        
        // 支付方式选择 - 使用事件委托
        $(document).on('click', '.payment-method', function() {
            $('.payment-method').removeClass('selected');
            $(this).addClass('selected');
            selectedPaymentMethod = $(this).data('method');
        });
        
        // 提交订单
        $('#submitOrderBtn').click(function() {
            submitOrder();
        });
    });

    function loadProducts(productIds) {
        console.log('Loading products for IDs:', productIds);
        
        // 构建表单数据
        var formData = new FormData();
        for (var i = 0; i < productIds.length; i++) {
            formData.append('productIds', productIds[i]);
        }
        
        $.ajax({
            url: '${pageContext.request.contextPath}/cart/getSelectedItems',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                console.log('AJAX Response:', response);
                if (response.success) {
                    displayProducts(response.data);
                    calculateTotal();
                } else {
                    showMessage('加载商品信息失败：' + response.message, {type: 'error'});
                }
            },
            error: function(xhr, status, error) {
                console.error('AJAX Error:', error);
                console.error('Response:', xhr.responseText);
                showMessage('网络错误，请重试', {type: 'error'});
            }
        });
    }

    function displayProducts(products) {
        selectedProducts = products;
        var html = '';
        
        for (var i = 0; i < products.length; i++) {
            var item = products[i];
            html += 
                '<div class="product-item">' +
                    '<div class="row align-items-center">' +
                        '<div class="col-auto">' +
                            '<img src="${pageContext.request.contextPath}/static/images/products/' + (item.product.image || 'default.jpg') + '"' + 
                                 ' class="img-thumbnail" style="width: 60px; height: 60px; object-fit: cover;"' +
                                 ' onerror="this.src=\'${pageContext.request.contextPath}/static/images/products/default.jpg\'">' +
                        '</div>' +
                        '<div class="col">' +
                            '<h6 class="mb-1">' + item.product.name + '</h6>' +
                            '<p class="text-muted small mb-0">' + item.product.description + '</p>' +
                        '</div>' +
                        '<div class="col-auto">' +
                            '<span class="text-muted">×' + item.quantity + '</span>' +
                        '</div>' +
                        '<div class="col-auto">' +
                            '<span class="fw-bold">¥' + (item.product.price * item.quantity).toFixed(2) + '</span>' +
                        '</div>' +
                    '</div>' +
                '</div>';
        }
        
        $('#productList').html(html);
    }

    function calculateTotal() {
        var subtotal = 0;
        for (var i = 0; i < selectedProducts.length; i++) {
            var item = selectedProducts[i];
            subtotal += item.product.price * item.quantity;
        }
        
        totalAmount = subtotal;
        $('#subtotal').text('¥' + subtotal.toFixed(2));
        $('#totalAmount').text('¥' + totalAmount.toFixed(2));
        
        // 启用提交按钮
        $('#submitOrderBtn').prop('disabled', false);
    }

    function useNewAddress() {
        var receiverName = $('#newReceiverName').val().trim();
        var receiverPhone = $('#newReceiverPhone').val().trim();
        var newAddress = $('#newAddress').val().trim();
        
        if (!receiverName || !receiverPhone || !newAddress) {
            showMessage('请填写完整的地址信息', {type: 'error'});
            return;
        }
        
        selectedAddress = newAddress;
        
        // 更新地址显示
        $('.address-item').removeClass('selected');
        var newAddressHtml = 
            '<div class="address-item selected" data-address="' + newAddress + '">' +
                '<div class="d-flex justify-content-between align-items-start">' +
                    '<div>' +
                        '<h6 class="mb-1">' + receiverName + '</h6>' +
                        '<p class="mb-1">' + receiverPhone + '</p>' +
                        '<p class="mb-0 text-muted">' + newAddress + '</p>' +
                    '</div>' +
                    '<span class="badge bg-success">新地址</span>' +
                '</div>' +
            '</div>';
        
        $('.section-content').prepend(newAddressHtml);
        $('#newAddressForm').collapse('hide');
        
        showMessage('地址已更新', {type: 'success'});
    }

    function submitOrder() {
        console.log('提交订单时的地址:', selectedAddress);
        if (!selectedAddress) {
            showMessage('请选择收货地址', {type: 'error'});
            return;
        }
        
        if (selectedProducts.length === 0) {
            showMessage('没有选择商品', {type: 'error'});
            return;
        }
        
        $('#submitOrderBtn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>提交中...');
        
        var productIds = [];
        for (var i = 0; i < selectedProducts.length; i++) {
            productIds.push(selectedProducts[i].productId);
        }
        
        $.ajax({
            url: '${pageContext.request.contextPath}/order/create',
            type: 'POST',
            data: {
                productIds: productIds,
                shippingAddress: selectedAddress
            },
            success: function(response) {
                if (response.success) {
                    showMessage('订单创建成功！', {type: 'success'});
                    // 跳转到订单详情页面
                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/order/detail/' + response.data.id;
                    }, 1500);
                } else {
                    showToast('订单创建失败：' + response.message, 'error');
                    $('#submitOrderBtn').prop('disabled', false).html('<i class="fas fa-lock me-2"></i>提交订单');
                }
            },
            error: function() {
                showMessage('网络错误，请重试', {type: 'error'});
                $('#submitOrderBtn').prop('disabled', false).html('<i class="fas fa-lock me-2"></i>提交订单');
            }
        });
    }
</script>
</body>
</html>