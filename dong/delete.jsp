<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String idxStr = request.getParameter("idx");
    int idx = 0;
    if(idxStr != null && !idxStr.isEmpty()) {
        idx = Integer.parseInt(idxStr);
    }
    String msg = null;
    boolean deleted = false;
    if(idx > 0) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/team_project", "root", "1234");
            String sql = "DELETE FROM board WHERE idx=?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idx);
            int result = pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            if(result > 0) {
                deleted = true;
            } else {
                msg = "삭제에 실패했습니다.";
            }
        } catch(Exception e) {
            msg = "DB 오류: " + e.getMessage();
        }
    } else {
        msg = "잘못된 접근입니다.";
    }
    if(deleted) {
        response.sendRedirect("board.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 삭제</title>
</head>
<body>
    <% if(msg != null) { %>
        <div style="color:red;"><%=msg%></div>
        <a href="board.jsp">목록으로</a>
    <% } %>
</body>
</html> 