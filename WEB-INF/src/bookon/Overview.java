package bookon;

import java.awt.BasicStroke;
import java.awt.Color;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.StandardChartTheme;
import org.jfree.chart.block.BlockBorder;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.RingPlot;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.ui.RectangleEdge;

public class Overview extends HttpServlet {

	@Override
	  protected void doGet(HttpServletRequest request, HttpServletResponse response)
	      throws ServletException, IOException {
		
		HttpSession session = request.getSession(true);
		
		System.out.println("Book On -> Overview page -> Start");
		Runtime runtime = Runtime.getRuntime();
		System.out.println("TotalMemory : " + (runtime.totalMemory() / 1024 / 1024) + "MB");
		System.out.println("MemoryUsage : " + ((runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024) + "MB");

		long startTime = System.currentTimeMillis();
		
		ServletContext context = this.getServletContext();
		
		ArrayList<NumberOfBooksByClassification> list = NumberOfBooksByClassification.getInfos();
	 
	    // 円グラフのデータ作成
	    DefaultPieDataset data = new DefaultPieDataset();
	    
	    for(NumberOfBooksByClassification item : list) {
	    	data.setValue(item.getClassification(), item.getNumber());
	    }
	 
	    // 日本語の文字化けを抑制
	    ChartFactory.setChartTheme(StandardChartTheme.createLegacyTheme());
	    
		// JFreeChartオブジェクト作成
	    JFreeChart chart = ChartFactory.createRingChart("", data, true, true, false);
	    
	    // 背景色を削除
	    chart.setBackgroundPaint(Color.WHITE);
	    // 凡例のアウトラインを削除
	    chart.getLegend().setFrame(BlockBorder.NONE);
	    // 凡例の位置を右に固定
	    chart.getLegend().setPosition(RectangleEdge.RIGHT);
	    
	    RingPlot plot = (RingPlot) chart.getPlot();
	    
	    // セクション間の境界線の削除(リングチャート)
	    plot.setSeparatorsVisible(false);
	    // リングチャートの太さを設定
	    plot.setSectionDepth(0.5);
	    // アウトラインを削除
	    plot.setOutlineVisible(false);
	    // ラベルを削除
	    plot.setLabelGenerator(null);
	    // セクション間の境界線の削除
	    //plot.setBaseSectionOutlinePaint(new Color(0, 0, 0, 0));
	    // セクション間の境界線を設定
	    plot.setBaseSectionOutlinePaint(Color.WHITE);
	    plot.setBaseSectionOutlineStroke(new BasicStroke(3, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
	    // 影の削除
	    plot.setShadowPaint(null);

	    File file = new File(context.getRealPath("temp") + "/NumberOfBooksByClassificationChart.png");
	    try {
	      ChartUtilities.saveChartAsPNG(file, chart, 300, 300);
	    } catch (IOException e) {
	      e.printStackTrace();
	    }
	    
	    ArrayList<CirculationByClassificationOfThisYear> list2 = CirculationByClassificationOfThisYear.getInfos();
	 
	    // 円グラフのデータ作成
	    DefaultPieDataset data2 = new DefaultPieDataset();

	    for(CirculationByClassificationOfThisYear item : list2) {
	    	data2.setValue(item.getClassification(), item.getNumber());
	    }
	 
	    // 日本語の文字化けを抑制
	    ChartFactory.setChartTheme(StandardChartTheme.createLegacyTheme());
	    
		// JFreeChartオブジェクト作成
	    JFreeChart chart2 = ChartFactory.createRingChart("", data2, true, true, false);
	    
	    // 背景色を削除
	    chart2.setBackgroundPaint(Color.WHITE);
	    // 凡例のアウトラインを削除
	    chart2.getLegend().setFrame(BlockBorder.NONE);
	    // 凡例の位置を右に固定
	    chart2.getLegend().setPosition(RectangleEdge.RIGHT);
	    
	    RingPlot plot2 = (RingPlot) chart2.getPlot();
	    
	    // セクション間の境界線の削除(リングチャート)
	    plot2.setSeparatorsVisible(false);
	    // リングチャートの太さを設定
	    plot2.setSectionDepth(0.5);
	    // アウトラインを削除
	    plot2.setOutlineVisible(false);
	    // ラベルを削除
	    plot2.setLabelGenerator(null);
	    // セクション間の境界線の削除
	    //plot.setBaseSectionOutlinePaint(new Color(0, 0, 0, 0));
	    // セクション間の境界線を設定
	    plot2.setBaseSectionOutlinePaint(Color.WHITE);
	    plot2.setBaseSectionOutlineStroke(new BasicStroke(3, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
	    // 影の削除
	    plot2.setShadowPaint(null);

	    File file2 = new File(context.getRealPath("temp") + "/CirculationByClassificationOfThisYearChart.png");
	    try {
	      ChartUtilities.saveChartAsPNG(file2, chart2, 300, 300);
	    } catch (IOException e) {
	      e.printStackTrace();
	    }
	    
		long endTime = System.currentTimeMillis();
		
		System.out.println("RunTime : " + (endTime - startTime) + "ms");
		
		System.out.println("Session ID : " + session.getId());
		if((session.getAttribute("login") != null) && session.getAttribute("login").equals("true")) {
			System.out.println("UserName :" + session.getAttribute("last_name") + " " + session.getAttribute("first_name"));
		}
		
		
		ArrayList<CirculationByMonths> list3 = CirculationByMonths.getInfos();
		
		// 円グラフのデータ作成
	    DefaultCategoryDataset data3 = new DefaultCategoryDataset();
	    
	    for(CirculationByMonths item : list3) {
	    	data3.addValue(item.getNumber(), item.getClassification(), item.getMonth() + "月");
	    }
	 
	    // 日本語の文字化けを抑制
	    ChartFactory.setChartTheme(StandardChartTheme.createLegacyTheme());
	    
		// JFreeChartオブジェクト作成
	    JFreeChart chart3 = ChartFactory.createStackedBarChart("", "", "貸出冊数", data3, PlotOrientation.VERTICAL, true, true, false);
	    
	    // 背景色を削除
	    chart3.setBackgroundPaint(Color.WHITE);
	    // 凡例のアウトラインを削除
	    chart3.getLegend().setFrame(BlockBorder.NONE);
	    // 凡例の位置を右に固定
	    chart3.getLegend().setPosition(RectangleEdge.RIGHT);

	    File file3 = new File(context.getRealPath("temp") + "/CirculationByMonthsChart.png");
	    try {
	      ChartUtilities.saveChartAsPNG(file3, chart3, 600, 300);
	    } catch (IOException e) {
	      e.printStackTrace();
	    }
	    
	    this.getServletContext().getRequestDispatcher("/overview.jsp")
		.forward(request, response);
	  }
}
