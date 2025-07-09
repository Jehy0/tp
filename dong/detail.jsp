<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String idxStr = request.getParameter("idx");
    int idx = 0;
    if(idxStr != null && !idxStr.isEmpty()) {
        idx = Integer.parseInt(idxStr);
    }
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/team_project", "root", "1234");
    PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM board WHERE idx = ?");
    pstmt.setInt(1, idx);
    ResultSet rs = pstmt.executeQuery();
    boolean found = rs.next();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 상세</title>
    <link rel="stylesheet" href="css/board.css">
    <link rel="stylesheet" href="css/header.css">
</head>
<body>
    <!-- ... 기존 헤더 ... -->
    <div class="container">
        <article class="post-detail">
        <% if(found) { %>
            <div class="post-header">
                <h1 class="post-title"><%=rs.getString("subject")%></h1>
                <div class="post-meta">
                    <div class="post-author">
                        <span><%=rs.getString("name")%></span>
                        <span>•</span>
                        <span><%=rs.getString("regdate")%></span>
                        <span>•</span>
                        <span>조회수</span>
                        <span><%=rs.getInt("readhit")%></span>
                    </div>
                </div>
            </div>
            <div class="post-content">
                <div class="post-text"><%=rs.getString("content")%></div>
            </div>
            <div class="action-buttons">
                <a href="write.jsp?edit=1&idx=<%=rs.getInt("idx")%>" class="btn btn-primary">수정</a>
                <a href="delete.jsp?idx=<%=rs.getInt("idx")%>" class="btn btn-danger">삭제</a>
                <a href="board.jsp" class="btn btn-secondary">목록</a>
            </div>
        <% } else { %>
            <div>해당 게시글을 찾을 수 없습니다.</div>
        <% } %>
        </article>
    </div>
    <% rs.close(); pstmt.close(); conn.close(); %>
    <!-- ... 기존 푸터 ... -->
</body>
</html> 