package bookon;

public class Pagination {
	
	private int totalPage;
	private int page;
	private int begin;
	
	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getBegin() {
		return begin;
	}

	public void setBegin(int begin) {
		this.begin = begin;
	}

	public static Pagination getInfos(String numberOfRows, String page) {
		
		Pagination pagination = new Pagination();
		
		int totalPage = Integer.parseInt(numberOfRows) / 10;
		
		if(totalPage % 10 != 0) {
			totalPage += 1;
		}
		
		pagination.setTotalPage(totalPage);
		if(page != null) {
			pagination.setPage(Integer.parseInt(page));
		}
		
		if(page == null || pagination.getPage() < 6) {
			pagination.setBegin(1);
		} else if(page != null) {
		
			int middle = (int)((1 + 10) * 5 / 10);
			
			if(pagination.getPage() > middle) {
				if(pagination.getPage() - middle + 10 > pagination.getTotalPage()) {
					pagination.setBegin(pagination.getTotalPage() - 10);
				} else {
					pagination.setBegin(pagination.getPage() - middle);
				}
			}
		}
		
		return pagination;
		
	}

}
