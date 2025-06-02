package com.shop.controller;

import com.shop.entity.Order;
import com.shop.entity.User;
import com.shop.service.OrderService;
import com.shop.util.Either;
import com.shop.util.JsonResult;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    /**
     * 我的订单页面
     */
    @RequestMapping("/orders")
    public String orders(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        List<Order> orders = orderService.findByUserId(user.getId());
        model.addAttribute("orders", orders);
        return "orders";
    }

    /**
     * 订单详情页面
     */
    @RequestMapping("/detail/{id}")
    public String orderDetail(@PathVariable int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        Order order = orderService.findById(id);
        if (order == null || order.getUserId() != user.getId()) {
            return "redirect:/order/orders";
        }

        model.addAttribute("order", order);
        return "order-detail";
    }

    /**
     * 结算页面
     */
    @RequestMapping("/checkout")
    public String checkout(@RequestParam("productIds") List<Integer> productIds, 
                          HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        if (productIds == null || productIds.isEmpty()) {
            return "redirect:/cart";
        }

        model.addAttribute("productIds", productIds);
        model.addAttribute("user", user);
        return "checkout";
    }

    /**
     * 创建订单
     */
    @PostMapping("/create")
    @ResponseBody
    public JsonResult<Order> createOrder(@RequestParam("productIds") List<Integer> productIds,
                                        @RequestParam(value = "shippingAddress", required = false) String shippingAddress,
                                        HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        // 如果提供了新的收货地址，更新用户地址
        if (shippingAddress != null && !shippingAddress.trim().isEmpty()) {
            user.setAddress(shippingAddress.trim());
        }

        Either<Order> result = orderService.createOrder(user, productIds);
        if (!result.isSuccess()) {
            return JsonResult.error(result.error());
        }

        return JsonResult.success(result.result());
    }

    /**
     * 更新订单状态
     */
    @PostMapping("/updateStatus")
    @ResponseBody
    public JsonResult<String> updateOrderStatus(@RequestParam int orderId, 
                                               @RequestParam int status,
                                               HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        // 验证订单是否属于当前用户
        Order order = orderService.findById(orderId);
        if (order == null || order.getUserId() != user.getId()) {
            return JsonResult.error("订单不存在");
        }

        // 只允许用户取消待支付的订单
        if (status == -1 && order.getStatus() == 0) {
            boolean success = orderService.updateStatus(orderId, -1);
            return success ? JsonResult.success("订单已取消") : JsonResult.error("取消失败");
        }

        return JsonResult.error("操作不允许");
    }

    /**
     * 根据状态筛选订单
     */
    @GetMapping("/filter")
    @ResponseBody
    public JsonResult<List<Order>> filterOrders(@RequestParam(required = false) Integer status,
                                               HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return JsonResult.error("请先登录");
        }

        List<Order> orders;
        if (status == null) {
            orders = orderService.findByUserId(user.getId());
        } else {
            // 这里需要在OrderService中添加根据用户ID和状态查询的方法
            orders = orderService.findByUserId(user.getId());
            orders = orders.stream()
                    .filter(order -> order.getStatus() == status)
                    .toList();
        }

        return JsonResult.success(orders);
    }
}
