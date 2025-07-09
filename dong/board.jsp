<%@ page import="java.sql.*" %>
<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/team_project", "root", "1234");
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM board ORDER BY idx DESC");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시판</title>
    <link rel="stylesheet" href="css/board.css">
    <link rel="stylesheet" href="css/header.css">
</head>
<body>
    <!-- ... 기존 헤더/네비게이션/푸터 등 ... -->
    <div class="container">
        <div class="board-header">
            <h1 class="board-title">사용자 후기 / 팁 / 정보 게시판</h1>
            <div class="header-actions">
                <div class="search-box">
                    <input type="text" class="search-input" placeholder="게시글 검색...">
                    <button class="search-btn">🔍</button>
                </div>
                <button class="view-toggle-btn" onclick="toggleView()">카드형 보기</button>
            </div>
        </div>
        <!-- ... 필터/카테고리 영역 ... -->
        <div style="display: flex; justify-content: flex-end;">
            <a href="write.jsp" class="write-btn">글쓰기</a>
        </div>
        <div class="post-list">
        <% while(rs.next()){ %>
            <a href="detail.jsp?idx=<%=rs.getInt("idx")%>" class="post-list-item">
                <div class="post-list-title"><%=rs.getString("subject")%></div>
                <div class="post-info">
                    <div class="post-meta">
                        <span><%=rs.getString("name")%></span> • 
                        <span><%=rs.getString("regdate")%></span> • 
                        <span>조회수 <%=rs.getInt("readhit")%></span>
                    </div>
                </div>
            </a>
        <% } %>
        </div>
    </div>
    <% rs.close(); stmt.close(); conn.close(); %>
    <!-- ... 기존 푸터 ... -->
</body>
</html> 