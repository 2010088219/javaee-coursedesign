<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>商品列表 - 网上商城</title>
  <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/style.css" rel="stylesheet">
  <style>
    .search-highlight {
      background-color: #fff3cd;
      padding: 0 2px;
      border-radius: 2px;
      font-weight: 500;
    }
    
    .search-suggestions {
      font-family: inherit;
    }
    
    .hot-search-tags {
      margin-top: 10px;
    }
    
    .hot-search-tags .badge {
      margin-right: 8px;
      margin-bottom: 5px;
      cursor: pointer;
      transition: all 0.2s;
    }
    
    .hot-search-tags .badge:hover {
      transform: translateY(-1px);
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
  </style>
</head>
<body>
<!-- 导航栏 -->
<jsp:include page="common/header.jsp"/>
<jsp:include page="common/toast.jsp"/>

<div class="container mt-4">
  <!-- 搜索 筛选 -->
  <div class="row mb-4">
    <div class="col-md-10">
      <div class="input-group">
        <input type="text" class="form-control" id="searchKeyword"
               placeholder="搜索商品名称、描述..." value="${param.keyword}"
               autocomplete="off">
        <button class="btn btn-primary" type="button" id="searchBtn">
          <i class="fas fa-search"></i> 搜索
        </button>
      </div>
      <!-- 热门搜索标签 -->
      <div class="hot-search-tags" id="hotSearchTags" style="display: none;">
        <small class="text-muted">热门搜索：</small>
        <div id="hotSearchContainer"></div>
      </div>
    </div>
    <div class="col-md-2">
      <select class="form-select" id="sortSelect">
        <option value="default">默认</option>
        <option value="price_asc">价格升序</option>
        <option value="price_desc">价格降序</option>
        <option value="sales_desc">销量降序</option>
        <option value="create_time_desc">最新</option>
      </select>
    </div>
  </div>

  <!-- 商品列表 -->
  <div class="row" id="productList">
    <c:forEach var="product" items="${products}">
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
    </c:forEach>
  </div>

  <!-- 无商品 -->
  <c:if test="${empty products}">
    <div class="empty-state">
      <i class="fas fa-search"></i>
      <h4>没有找到相关商品</h4>
      <p>请尝试其他关键词或浏览所有商品</p>
      <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
        <i class="fas fa-list"></i> 浏览所有商品
      </a>
    </div>
  </c:if>

  <!-- 分页 -->
  <c:if test="${not empty products}">
    <nav aria-label="商品分页">
      <ul class="pagination justify-content-center">
        <c:if test="${currentPage > 1}">
          <li class="page-item">
            <a class="page-link" href="?page=${currentPage - 1}&keyword=${param.keyword}&sort=${param.sort}">
              <i class="fas fa-chevron-left"></i>
            </a>
          </li>
        </c:if>

        <c:forEach begin="1" end="${totalPages}" var="i">
          <li class="page-item ${i == currentPage ? 'active' : ''}">
            <a class="page-link" href="?page=${i}&keyword=${param.keyword}&sort=${param.sort}">${i}</a>
          </li>
        </c:forEach>

        <c:if test="${currentPage < totalPages}">
          <li class="page-item">
            <a class="page-link" href="?page=${currentPage + 1}&keyword=${param.keyword}&sort=${param.sort}">
              <i class="fas fa-chevron-right"></i>
            </a>
          </li>
        </c:if>
      </ul>
    </nav>
  </c:if>
</div>

<jsp:include page="common/dependency_js.jsp"/>
<script src="${pageContext.request.contextPath}/static/js/search.js"></script>

<script>
    const searchButton = document.querySelector('#searchBtn');
    const sortSelect = document.querySelector('#sortSelect');
    const searchKeyword = document.querySelector('#searchKeyword');
    const hotSearchTags = document.querySelector('#hotSearchTags');
    const hotSearchContainer = document.querySelector('#hotSearchContainer');

    // 初始化搜索增强功能
    const searchEnhancer = new SearchEnhancer({
        searchInput: searchKeyword,
        searchButton: searchButton,
        contextPath: '${pageContext.request.contextPath}',
        debounceDelay: 300,
        maxSuggestions: 8
    });

    function search() {
        const keyword = searchKeyword.value.trim();
        const sort = sortSelect.value;
        let url = '${pageContext.request.contextPath}/products';

        // 组装查询参数
        let params = [];
        if (keyword)
            params.push('keyword=' + encodeURIComponent(keyword));
        if (sort && sort !== 'default')
            params.push('sort=' + sort);
        if (params.length > 0)
            url += '?' + params.join('&');

        window.location.href = url;
    }

    // 设置当前排序
    let currentSort = '${param.sort}';
    if (currentSort) {
        sortSelect.value = currentSort;
    }

    // 绑定事件
    sortSelect.addEventListener('change', search);
    searchButton.addEventListener('click', search);
    searchKeyword.addEventListener('keypress', e => {
        if (e.key === 'Enter') {
            search();
        }
    });

    // 加载热门搜索标签
    async function loadHotSearchTags() {
        try {
            const response = await fetch('${pageContext.request.contextPath}/api/search/hot-keywords?limit=6');
            const data = await response.json();
            
            if (data.success && data.keywords && data.keywords.length > 0) {
                hotSearchContainer.innerHTML = '';
                data.keywords.forEach(keyword => {
                    const badge = document.createElement('span');
                    badge.className = 'badge bg-light text-dark';
                    badge.textContent = keyword;
                    badge.style.cursor = 'pointer';
                    badge.addEventListener('click', () => {
                        searchKeyword.value = keyword;
                        search();
                    });
                    hotSearchContainer.appendChild(badge);
                });
                hotSearchTags.style.display = 'block';
            }
        } catch (error) {
            console.error('加载热门搜索失败:', error);
        }
    }

    // 页面加载完成后执行
    document.addEventListener('DOMContentLoaded', () => {
        loadHotSearchTags();
        
        // 如果有搜索关键词，高亮显示搜索结果
        const currentKeyword = '${param.keyword}';
        if (currentKeyword) {
            SearchEnhancer.highlightSearchResults(currentKeyword);
        }
    });
</script>
</body>
</html>