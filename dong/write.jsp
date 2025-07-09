<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    request.setCharacterEncoding("UTF-8");
    String method = request.getMethod();
    String msg = null;
    if("POST".equalsIgnoreCase(method)) {
        String name = request.getParameter("name");
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        String category = request.getParameter("category");
        String pwd = request.getParameter("pwd");
        String ip = request.getRemoteAddr();
        String regdate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
        int readhit = 0;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/team_project", "root", "1234");
            String sql = "INSERT INTO board (name, subject, content, pwd, ip, regdate, readhit) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, subject);
            pstmt.setString(3, content);
            pstmt.setString(4, pwd);
            pstmt.setString(5, ip);
            pstmt.setString(6, regdate);
            pstmt.setInt(7, readhit);
            int result = pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            if(result > 0) {
                response.sendRedirect("board.jsp");
                return;
            } else {
                msg = "글 작성에 실패했습니다.";
            }
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
    <title>게시글 작성</title>
    <link rel="stylesheet" href="css/board.css">
    <link rel="stylesheet" href="css/header.css">
</head>
<body>
    <!-- ... 기존 헤더 ... -->
    <div class="container">
        <form class="write-form" method="post" action="write.jsp">
            <div class="form-group">
                <label class="form-label">카테고리</label>
                <select class="form-input form-select" name="category" required>
                    <option value="">카테고리 선택</option>
                    <option value="review">후기</option>
                    <option value="tip">팁</option>
                    <option value="info">정보</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">제목</label>
                <input type="text" class="form-input" name="subject" required>
            </div>
            <div class="form-group">
                <label class="form-label">작성자</label>
                <input type="text" class="form-input" name="name" required>
            </div>
            <div class="form-group">
                <label class="form-label">비밀번호</label>
                <input type="password" class="form-input" name="pwd" required>
            </div>
            <div class="form-group">
                <label class="form-label">내용</label>
                <textarea class="form-input form-textarea" name="content" required></textarea>
            </div>
            <div class="action-buttons">
                <button type="submit" class="btn btn-primary">작성</button>
                <a href="board.jsp" class="btn btn-secondary">취소</a>
            </div>
        </form>
        <% if(msg != null) { %>
            <div style="color:red;"><%=msg%></div>
        <% } %>
    </div>
    <!-- ... 기존 푸터 ... -->
</body>
</html> 