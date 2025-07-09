<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    request.setCharacterEncoding("UTF-8");
    String idxStr = request.getParameter("idx");
    int idx = 0;
    if(idxStr != null && !idxStr.isEmpty()) {
        idx = Integer.parseInt(idxStr);
    }
    String method = request.getMethod();
    String msg = null;
    String name = "";
    String subject = "";
    String content = "";
    String category = "";
    String pwd = "";
    if("POST".equalsIgnoreCase(method)) {
        name = request.getParameter("name");
        subject = request.getParameter("subject");
        content = request.getParameter("content");
        category = request.getParameter("category");
        pwd = request.getParameter("pwd");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/team_project", "root", "1234");
            String sql = "UPDATE board SET name=?, subject=?, content=?, category=?, pwd=? WHERE idx=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, subject);
            pstmt.setString(3, content);
            pstmt.setString(4, category);
            pstmt.setString(5, pwd);
            pstmt.setInt(6, idx);
            int result = pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            if(result > 0) {
                response.sendRedirect("detail.jsp?idx="+idx);
                return;
            } else {
                msg = "글 수정에 실패했습니다.";
            }
        } catch(Exception e) {
            msg = "DB 오류: " + e.getMessage();
        }
    } else if(idx > 0) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/team_project", "root", "1234");
            String sql = "SELECT * FROM board WHERE idx=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idx);
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()) {
                name = rs.getString("name");
                subject = rs.getString("subject");
                content = rs.getString("content");
                category = rs.getString("category");
                pwd = rs.getString("pwd");
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch(Exception e) {
            msg = "DB 오류: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 수정</title>
    <link rel="stylesheet" href="css/board.css">
    <link rel="stylesheet" href="css/header.css">
</head>
<body>
    <!-- ... 기존 헤더 ... -->
    <div class="container">
        <form class="write-form" method="post" action="edit.jsp?idx=<%=idx%>">
            <div class="form-group">
                <label class="form-label">카테고리</label>
                <select class="form-input form-select" name="category" required>
                    <option value="">카테고리 선택</option>
                    <option value="review" <%=category.equals("review")?"selected":""%>>후기</option>
                    <option value="tip" <%=category.equals("tip")?"selected":""%>>팁</option>
                    <option value="info" <%=category.equals("info")?"selected":""%>>정보</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">제목</label>
                <input type="text" class="form-input" name="subject" value="<%=subject%>" required>
            </div>
            <div class="form-group">
                <label class="form-label">작성자</label>
                <input type="text" class="form-input" name="name" value="<%=name%>" required>
            </div>
            <div class="form-group">
                <label class="form-label">비밀번호</label>
                <input type="password" class="form-input" name="pwd" value="<%=pwd%>" required>
            </div>
            <div class="form-group">
                <label class="form-label">내용</label>
                <textarea class="form-input form-textarea" name="content" required><%=content%></textarea>
            </div>
            <div class="action-buttons">
                <button type="submit" class="btn btn-primary">수정</button>
                <a href="detail.jsp?idx=<%=idx%>" class="btn btn-secondary">취소</a>
            </div>
        </form>
        <% if(msg != null) { %>
            <div style="color:red;"><%=msg%></div>
        <% } %>
    </div>
    <!-- ... 기존 푸터 ... -->
</body>
</html> 