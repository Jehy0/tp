package team_project.dong.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import team_project.dong.vo.CommentVO;

public class CommentDAO {
	SqlSession sqlSession;
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	//comment작성
	public int insert( CommentVO vo ) {
		int res = sqlSession.insert("c.comment_insert", vo);
		return res;
	}
	//comment조회
	public List<CommentVO> selectList( Map<String, Integer> map ){
		List<CommentVO> list = 
				sqlSession.selectList("c.comment_list_page", map);
		return list;
	}
	//comment삭제
	public int delete( CommentVO vo ) {
		int res = sqlSession.delete("c.comment_delete", vo);
		return res;
	}
	//comment 수
	public int getRowTotal( int idx ) {
		int count = sqlSession.selectOne("c.comment_idx_count", idx);
		return count;
	}
} 