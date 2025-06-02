document.addEventListener('DOMContentLoaded', () => {
    function updateTotal() {
        let selectedCount = 0;
        let totalPrice = 0;

        document.querySelectorAll('.item-checkbox:checked').forEach(el => {
            const cartId = el.value;
            const quantity = parseInt(document.querySelector(`.quantity-input[data-cart-id="${cartId}"]`).value);
            const price = parseFloat(el.dataset.price);

            selectedCount += quantity;
            totalPrice += price * quantity;
        });

        document.querySelector('#selectedCount').innerHTML = selectedCount + '';
        document.querySelector('#totalPrice').innerHTML = '¥' + parseFloat(totalPrice).toFixed(2);
        document.querySelector('#checkoutBtn').disabled = selectedCount === 0;
    }

    function updateSelectAll() {
        const totalItems = document.querySelectorAll('.item-checkbox').length;
        const checkedItems = document.querySelectorAll('.item-checkbox:checked').length;
        document.querySelector('#selectAll').checked = totalItems === checkedItems;
    }

    document.querySelector('#selectAll').addEventListener('change', event => {
        const checked = event.target.checked;
        document.querySelectorAll('.item-checkbox').forEach(cb => cb.checked = checked);
        updateTotal();
    })

    document.querySelectorAll('.item-checkbox').forEach(el => el.addEventListener('change', () => {
        updateTotal();
        updateSelectAll();
    }))

    // + -
    document.querySelectorAll('.quantity-btn').forEach(btn => btn.addEventListener('click', () => {
        const delta = parseInt(btn.dataset.delta);
        const cartId = parseInt(btn.dataset.cartId);
        const current = parseInt(document.querySelector(`.quantity-input[data-cart-id="${cartId}"]`).value);
        updateProductCount(cartId, Math.max(1, current + delta));
    }));

    // 直接输入数量
    document.querySelectorAll('.quantity-input').forEach(input => input.addEventListener('change', event => {
        const quantity = parseInt(event.target.value);
        if (!isNaN(quantity) && quantity >= 1) {
            event.target.value = quantity;
            updateProductCount(parseInt(event.target.dataset.cartId), quantity);
        }
    }));

    // 更新购物车数量
    function updateProductCount(cartId, quantity) {
        const buttons = document.querySelectorAll(`.quantity-btn[data-cart-id="${cartId}"]`)
        const input = document.querySelector(`.quantity-input[data-cart-id="${cartId}"]`);
        input.value = input.dataset.originalValue + '';
        buttons.forEach(btn => btn.disabled = true)
        input.disabled = true;
        updateCartProductCount(cartId, quantity)
            .then(() => {
                const sel = document.querySelector(`.item-checkbox[value="${cartId}"]`);
                const price = parseFloat(sel.dataset.price);
                console.log(price, quantity)
                document.querySelector(`.cart-item[data-cart-id="${cartId}"] .subtotal`).innerHTML = (price * quantity) + ''
                input.value = quantity;
                input.dataset.originalValue = quantity;
                updateTotal();
                updateCartCount();
            })
            .catch(e => showMessage(e.message, 'danger'))
            .finally(() => {
                buttons.forEach(btn => btn.disabled = false);
                input.disabled = false;
            });
    }

    // 删除单个商品
    document.querySelectorAll('.delete-item').forEach(btn => btn.addEventListener('click', () => {
        const cartId = parseInt(btn.dataset.cartId);
        if (confirm('删？')) {
            removeCartItem(cartId)
                .then(() => {
                    const el = document.querySelector(`.cart-item[data-cart-id="${cartId}"]`);
                    el.parentNode.removeChild(el);
                    updateTotal();
                    updateSelectAll();
                    updateCartCount();
                    location.reload();
                })
                .catch(error => showMessage(error.message, 'danger'));
        }
    }));

    // 删除选中商品
    document.querySelector('#deleteSelected').addEventListener('click', () => {
        const selectedItems = document.querySelectorAll('.item-checkbox:checked');
        if (selectedItems.length > 0 && confirm("删？")) {
            removeCartItems(Array.from(selectedItems).map(el => el.value))
                .then(deletedItems => {
                    deletedItems
                        .map(id => document.querySelector(`.cart-item[data-cart-id="${id}"]`))
                        .forEach(el => el.parentNode.removeChild(el));

                    updateTotal();
                    updateSelectAll();
                    updateCartCount();
                    showMessage('商品已删除', {type: 'success', reload: true});
                })
                .catch(e => showMessage(e.message, 'danger'))
        }
    });

    // 结算
    document.querySelector('#checkoutBtn').addEventListener('click', event => {
        const selectedItems = document.querySelectorAll('.item-checkbox:checked');
        if (selectedItems.length === 0) {
            showToast('请选择要结算的商品', 'error');
            return;
        }
        
        // 跳转到结算页面
        const productIds = Array.from(selectedItems).map(el => el.value);
        const params = new URLSearchParams();
        productIds.forEach(id => params.append('productIds', id));
        
        window.location.href = '/shop/order/checkout?' + params.toString();
    })

})