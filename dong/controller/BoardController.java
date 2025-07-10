package com.init.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import team_project.dong.common.Common;
import team_project.dong.common.Paging;
import team_project.dong.dao.BoardDAO;
import team_project.dong.dao.CommentDAO;
import team_project.dong.vo.BoardVO;
import team_project.dong.vo.CommentVO;

@Controller
public class BoardController {

	@Autowired
	HttpServletRequest request;

	BoardDAO board_dao;
	public void setBoard_dao(BoardDAO board_dao) {
		this.board_dao = board_dao;
	}

	CommentDAO comment_dao;
	public void setComment_dao(CommentDAO comment_dao) {
		this.comment_dao = comment_dao;
	}

	@RequestMapping( value={"/", "/list.do"} )
	public String list( Model model, String page, String search, String search_text ) {

		int nowPage = 1;//기본페이지
		if( page != null && !page.isEmpty() ) {
			nowPage = Integer.parseInt(page);
		}

		int start = ( nowPage - 1 ) * Common.Board.BLOCKLIST + 1;
		int end = start + Common.Board.BLOCKLIST - 1;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", start);
		map.put("end", end);

		if( search != null && !search.equals("all") ) {

			switch( search ) {
			case "name_subject_content":
				map.put("name", search_text);
				map.put("subject", search_text);
				map.put("content", search_text);
				break;

			case "name":
				map.put("name", search_text);
				break;

			case "subject":
				map.put("subject", search_text);
				break;

			case "content":
				map.put("content", search_text);
				break;
			}

		}

		List<BoardVO> list = board_dao.selectList( map );
		int row_total = board_dao.getRowTotal( map );

		String search_param = 
				String.format("search=%s&search_text=%s", search, search_text);

		String pageMenu = Paging.getPaging(
				"list.do", nowPage, row_total, 
				search_param, 
				Common.Board.BLOCKLIST, 
				Common.Board.BLOCKPAGE);

		request.getSession().removeAttribute("show");

		model.addAttribute("list", list);
		model.addAttribute("pageMenu", pageMenu);

		return Common.Board.VIEW_PATH + "board_list.jsp";

	}

	@RequestMapping("/view.do")
	public String view( Model model, int idx ) {
		BoardVO vo = board_dao.selectOne( idx );

		HttpSession session = request.getSession();
		String show = (String)session.getAttribute("show");

		if( show == null ) {
			board_dao.updateReadhit( idx );
			session.setAttribute("show", "hi");
		}

		model.addAttribute("vo", vo);

		return Common.Board.VIEW_PATH + "board_view.jsp";

	}

	@RequestMapping("/insert_form.do")
	public String insert_form() {
		return Common.Board.VIEW_PATH + "board_write.jsp";
	}

	@RequestMapping("/insert.do")
	public String insert( BoardVO vo ) {

		String ip = request.getRemoteAddr();
		vo.setIp(ip);

		board_dao.insert( vo );

		return "redirect:list.do";

	}

	@RequestMapping("/del.do")
	@ResponseBody
	public String delete( int idx ) {

		int res = board_dao.del_update(idx);

		String result = "no";
		if( res == 1 ) {
			result = "yes";
		}

		return String.format("[{'result':'%s'}]", result);

	}

	@RequestMapping("/reply_form.do")
	public String reply_form() {
		return Common.Board.VIEW_PATH + "board_reply.jsp";
	}

	@RequestMapping("/reply.do")
	public String reply( int page, String search, 
			String search_text, BoardVO vo ) {


		String ip = request.getRemoteAddr();

		BoardVO baseVO = board_dao.selectOne(vo.getIdx());

		board_dao.update_step( baseVO );

		vo.setIp(ip);
		vo.setRef( baseVO.getRef() );
		vo.setStep( baseVO.getStep() + 1 );
		vo.setDepth( baseVO.getDepth() + 1 );

		board_dao.reply( vo );

		String encode = "";
		try {
			encode = URLEncoder.encode(search_text, "UTF8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		return "redirect:list.do?page="+page+"&search="+search+"&search_text="+encode;

	}

	@RequestMapping("/comment_insert.do")
	@ResponseBody
	public String comm_insert( CommentVO vo ) {

		String ip = request.getRemoteAddr();
		vo.setIp(ip);

		int res = comment_dao.insert( vo );

		String result = "no";
		if( res == 1 ) {
			result = "yes";
		}

		String resultStr = String.format("[{'result':'%s'}]", result);
		
		return resultStr;

	}
	
	@RequestMapping("/comment_list.do")
	public String comm_list( Model model, String page, int idx ) {
		
		int nowPage = 1;
		if( page != null && !page.isEmpty() ) {
			nowPage = Integer.parseInt(page);
		}
		
		int start = (nowPage - 1) * Common.Comment.BLOCKLIST + 1;
		int end = start + Common.Comment.BLOCKLIST - 1;
		
		Map<String, Integer> map = new HashMap<String, Integer>();		
		map.put("idx", idx);
		map.put("start", start);
		map.put("end", end);
		
		List<CommentVO> list = comment_dao.selectList(map);
		
		int row_total = comment_dao.getRowTotal(idx);
		
		String pageMenu = 
				Paging.getPaging(
					"comment_list.do", 
					nowPage, row_total, 
					Common.Comment.BLOCKLIST, 
					Common.Comment.BLOCKPAGE);
		
		model.addAttribute("list", list);
		model.addAttribute("pageMenu", pageMenu);
		
		return Common.Comment.VIEW_PATH + "comment_list.jsp";
		
	}
	
	@RequestMapping("/comment_del.do")
	@ResponseBody
	public String comm_del( CommentVO vo ) {
		
		int res = comment_dao.delete( vo );
		
		String result = "no";
		if( res == 1 ) {
			result = "yes";
		}
		
		String resultStr = 
				String.format("[{'result':'%s'}]", result);
		
		return resultStr;
		
	}

} 