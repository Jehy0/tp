package team_project.dong.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import team_project.dong.vo.BoardVO;

public class BoardDAO {
	SqlSession sqlSession;
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	public List<BoardVO> selectList( Map<String, Object> map ){
		List<BoardVO> list = sqlSession.selectList("b.board_list", map);
		return list;
	}
	public int insert( BoardVO vo ) {
		int res = sqlSession.insert("b.board_insert", vo);		
		return res;
	}
	public BoardVO selectOne( int idx ) {
		BoardVO vo = sqlSession.selectOne("b.board_one", idx);
		return vo;
	}
	public int updateReadhit( int idx ) {
		int res = sqlSession.update("b.board_upd_readhit", idx);
		return res;
	}
	public int update_step( BoardVO baseVO ) {
		int res = sqlSession.update("b.board_upd_step", baseVO);
		return res;
	}
	public int reply( BoardVO vo ) {
		int res = sqlSession.insert("b.board_reply", vo);	
		return res;
	}
	public int del_update(int idx) {
		int res = sqlSession.update("b.board_del_upd", idx);
		return res;
	}
	public int getRowTotal( Map<String, Object> map ) {
		int count = sqlSession.selectOne("b.board_count", map);
		return count;
	}
} 